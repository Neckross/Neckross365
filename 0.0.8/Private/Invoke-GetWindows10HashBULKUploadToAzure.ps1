function Invoke-GetWindows10HashBULKUploadToAzure {
  <#
  .SYNOPSIS
  Capture Windows 10 Hashes and upload to Azure Blob automatically (UPDATE values inside script)

  .DESCRIPTION
  Capture Windows 10 Hashes and upload to Azure Blob automatically (UPDATE values inside script)
  It can be pushed via desktop management system (ex. KACE, Intune, etc..)

  [REQUIREMENTS]
  MUST UPDATE VALUES!!!

  $BlobContainerUrl = "https://autopilothashes.blob.core.windows.net"
  $BlobContainerResources = "resources"
  $BlobContainerHashes = "windows10hashes"
  $BlobKey = "KtpGF+Nk4dRMCxQS3G1vwG0lDqUfJfxC9kUlfzML74WUQ=="

  .EXAMPLE
  [ex. From KACE]
  powershell.exe -ExecutionPolicy Bypass -File ". C:\Scripts\Invoke-GetWindows10HashBULKUploadToAzure.ps1

  .EXAMPLE
  [ex. From Intune]
  Invoke-GetWindows10HashBULKUploadToAzure.ps1

  .NOTES
  General notes
  #>

  # VALUES           <<<MUST BE UPDATED>>>
  $BlobContainerUrl = "https://autopilothashes.blob.core.windows.net"
  $BlobContainerResources = "resources"
  $BlobContainerHashes = "windows10hashes"
  $BlobKey = "KtpGF+Nk4dRMCxQS3G1vwG0lDqUfJfxC9kUlfzML74WUQ=="

  # Defining
  $fileName = "$env:computername" + "_" + "$env:username" + "_" + ".csv"
  $outputPath = Join-Path $env:windir "temp\Autopilot"
  $azCopyExe = Join-Path $outputPath "AzCopy\AzCopy.exe"
  $outputFile = Join-Path $outputPath $fileName
  #$scriptPath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)
  #$autoPilotScript = Join-Path $scriptPath "Get-WindowsAutoPilotInfo.ps1"
  $autoPilotScript = Join-Path $PSScriptRoot "Get-WindowsAutoPilotInfo.ps1"

  # Creating directory
  if (-not (Test-Path $outputPath)) {
    $null = New-Item -Path $outputPath -ItemType Directory
  }

  # Downloading resources (Get-WindowsAutoPilotInfo.ps1 + AZCopy) from Azure Blob
  if (-not (Test-Path $autoPilotScript)) {
    Start-BitsTransfer -Source "$BlobContainerUrl/$BlobContainerResources/Get-WindowsAutoPilotInfo.ps1" -Destination $outputPath
  }
  if (-not (Test-Path $azCopyExe)) {
    Start-BitsTransfer -Source "$BlobContainerUrl/$BlobContainerResources/AzCopy.zip" -Destination $outputPath
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::ExtractToDirectory($(Join-Path $outputPath "AzCopy.zip"), $(Join-Path $outputPath "AzCopy"))
  }

  # Collecting the Computer Hashes
  $autoPilotScript = Join-Path $outputPath "Get-WindowsAutoPilotInfo.ps1"
  Start-Command -Command "powershell.exe" -Arguments "-ExecutionPolicy Bypass -File `"$autoPilotScript`" -ComputerName $env:computername -OutputFile `"$outputFile`"" | Out-Null

  # Uploading the Computer Hashes to Azure Blob
  $azCopyExe = Join-Path $outputPath "AzCopy\AzCopy.exe"
  $url = "$BlobContainerUrl/$BlobContainerHashes"
  Start-Command -Command "`"$azCopyExe`"" -Arguments "/Source:`"$outputPath`" /Dest:$url /Pattern:$fileName /Y /Z:`"$(Join-Path $outputPath "AzCopy")`" /DestKey:`"$blobKey`"" | Out-Null

  # Results
  Write-Host -ForegroundColor Green "Locate Windows10Hash file under: " -NoNewline
  Write-Host -ForegroundColor Cyan $outputFile

  # Cleanup
  Remove-Item -Path $(Join-Path $outputPath "AzCopy.zip") -Force -ErrorAction SilentlyContinue | Out-Null
  Remove-Item -Path $(Join-Path $outputPath "AzCopy") -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
  Remove-Item -Path $(Join-Path $outputPath "Get-WindowsAutoPilotInfo.ps1") -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
}

# HELPER
Function Start-Command {
  Param(
    [Parameter (Mandatory)]
    [string]
    $Command,
    [Parameter (Mandatory)]
    [string]
    $Arguments
  )
  $pinfo = New-Object System.Diagnostics.ProcessStartInfo
  $pinfo.FileName = $Command
  $pinfo.RedirectStandardError = $true
  $pinfo.RedirectStandardOutput = $true
  $pinfo.CreateNoWindow = $true
  $pinfo.UseShellExecute = $false
  $pinfo.Arguments = $Arguments
  $p = New-Object System.Diagnostics.Process
  $p.StartInfo = $pinfo
  $p.Start() | Out-Null
  $p.WaitForExit()
  [pscustomobject]@{
    stdout   = $p.StandardOutput.ReadToEnd()
    stderr   = $p.StandardError.ReadToEnd()
    ExitCode = $p.ExitCode
  }
}
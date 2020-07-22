function Get-Windows10HashBULKUploadToAzure {
  <#
  .SYNOPSIS
  Capture Windows 10 Hashes and upload to Azure Blob automatically (BULK approach)

  .DESCRIPTION
  Capture Windows 10 Hashes and upload to Azure Blob automatically (BULK approach)
  It's meant to be used for multiple Windows 10 devices
  Additional configuration is required for Azure Blob (MUST be completed first)
  MUST need a dekstop management system to push the script (ex. KACE, SCCM, etc..)


  [REQUIREMENTS] for BULK approach using a BATCH FILE
  Download the CMD file (Get-Windows10HashBULKUploadToAzure_batchfile.cmd)
  Define the values inside the batch file before running this script:
  BlobContainerUrl = Storage Account Blob URL
  BlobContainerResources = Blob Container name for the resources
  BlobContainerHashes = Blob Container name for the Windows 10 hashes
  BlobKey = Blob Storage Account Key

  Example:
  powershell.exe -ExecutionPolicy Bypass -Command ". C:\Scripts\Get-Windows10HashBULKUploadToAzure.ps1 ; Get-Windows10HashBULKUploadToAzure -BlobContainerUrl 'https://autopilothashes.blob.core.windows.net' -BlobContainerResources 'resources' -BlobContainerHashes 'windows10hashes' -BlobKey 'KtpGF+Nk4dRMCxQS3G1vwG0lDqUfJfxC9kUlfzML74WUQ=='"

  [Encapsulate the batch file to run as an Scheduled Task]
  $User = "NT AUTHORITY\SYSTEM"
  $Trigger = New-ScheduledTaskTrigger -At 12:00PM -Daily
  $Action = New-ScheduledTaskAction -Execute 'C:\Scripts\Get-Windows10HashBULKUploadToAzure_batchfile.cmd'
  Register-ScheduledTask -TaskName "Collect_Upload_AzureBlob" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force

  .EXAMPLE
  As PowerShell
  Get-Windows10HashBULKUploadToAzure -BlobContainerUrl "https://autopilothashes.blob.core.windows.net" -BlobContainerResources resources -BlobContainerHashes windows10hashes -BlobKey "KtpGF+Nk4dRMCxQS3G1vwG0lDqUfJfxC9kUlfzML74WUQ=="

  .EXAMPLE
  As CMD
  powershell.exe -ExecutionPolicy Bypass -Command ". C:\Scripts\Get-Windows10HashBULKUploadToAzure.ps1 ; Get-Windows10HashBULKUploadToAzure -BlobContainerUrl 'https://autopilothashes.blob.core.windows.net' -BlobContainerResources 'resources' -BlobContainerHashes 'windows10hashes' -BlobKey 'KtpGF+Nk4dRMCxQS3G1vwG0lDqUfJfxC9kUlfzML74WUQ=='"

  .NOTES
  General notes
  #>

  param (
    [Parameter(Mandatory)]
    $BlobContainerUrl,
    [Parameter(Mandatory)]
    $BlobContainerResources,
    [Parameter(Mandatory)]
    $BlobContainerHashes,
    [Parameter(Mandatory)]
    $BlobKey
  )

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

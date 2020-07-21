function Get-Windows10Hash {
    <#
    .SYNOPSIS
    Capture Windows 10 Hashes and upload to Intune automatically

    .DESCRIPTION
    Capture Windows 10 Hashes and upload to Intune automatically

    .EXAMPLE
    Get-Windows10Hash

    .NOTES
    General notes
    #>

    # Log
    $fileName = "$env:computername" + "_" + "$env:username" + "_" + ".csv"
    $outputPath = Join-Path $env:windir "temp\Autopilot"
    $outputFile = Join-Path $outputPath $fileName

    if (-not (Test-Path $outputPath)) {
        New-Item -Path $outputPath -ItemType Directory | Out-Null
    }

    # Run as Local Admin
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false | Out-Null
    Install-Script -Name Get-WindowsAutoPilotInfo -Force -Confirm:$false
    Get-WindowsAutoPilotInfo.ps1 -OutputFile $outputFile

    # Locate file
    Write-Host -ForegroundColor Green "Locate Windows10Hash file under: " -NoNewline
    Write-Host -ForegroundColor Cyan "$outputFile"

}
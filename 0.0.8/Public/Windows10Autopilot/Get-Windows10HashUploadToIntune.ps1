function Get-Windows10HashUploadToIntune {
    <#
    .SYNOPSIS
    Capture Windows 10 Hashes and upload to Intune automatically

    .DESCRIPTION
    Capture Windows 10 Hashes and upload to Intune automatically

    .EXAMPLE
    Get-Windows10HasUploadToIntune

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

    # Requirements
    $module1 = Import-Module AzureRM -PassThru -ErrorAction Ignore
    if (-not $module1) {
        Write-Host "Installing module AzureRM"
        Install-Module AzureRM -Force
    }
    Import-Module AzureRM -Scope Global

    # Run as Local Admin
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false | Out-Null
    Install-Script -Name Get-WindowsAutoPilotInfo -Force -Confirm:$false
    Get-WindowsAutoPilotInfo.ps1 -OutputFile $outputFile -Online

    # Locate file
    Write-Host -ForegroundColor Green "Locate Windows10Hash file under: " -NoNewline
    Write-Host -ForegroundColor Cyan "$outputFile"

}
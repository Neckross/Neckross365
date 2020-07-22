function Get-Windows10HashBULKDownloadFromAzureUploadToIntune {
  <#
  .SYNOPSIS
  Download CSVs from Azure Blob and Combine them into single CSV and Upload to Intune (BULK approach)

  .DESCRIPTION
  Download CSVs from Azure Blob and Combine them into single CSV and Upload to Intune (BULK approach)

  [REQUIREMENTS]
  BlobConnectionString = Storage Account Connection String
  BlobContainerHashes = Blob Container name for the Windows 10 Hashes

  .EXAMPLE
  Example1:
  Get-Windows10HashBULKDownloadFromAzureUploadToIntune -BlobConnectionString "oMYJLjKhlmMyyMxM1I5/IcnEtiMO/fey1A==" -BlobContainerHashes "windows10hashes"

  Example2:
  DOT SOURCE it
  . .\Get-Windows10HashBULKDownloadFromAzureUploadToIntune.ps1
  Get-Windows10HashBULKDownloadFromAzureUploadToIntune -BlobConnectionString "oMYJLjKhlmMyyMxM1I5/IcnEtiMO/fey1A==" -BlobContainerHashes "windows10hashes"

  .NOTES
  General notes
  #>

  param (
    [Parameter(Mandatory)]
    $BlobConnectionString,

    [Parameter(Mandatory)]
    $BlobContainerHashes
  )

  # Logs
  $outputPath = Join-Path $env:windir "temp\Autopilot"
  $outputCombined = "$outputPath\AutopilotHashes.csv"
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

  $module2 = Import-Module WindowsAutopilotIntune -PassThru -ErrorAction Ignore
  if (-not $module2) {
    Write-Host "Installing module WindowsAutopilotIntune"
    Install-Module WindowsAutopilotIntune -Force
  }
  Import-Module WindowsAutopilotIntune -Scope Global

  # Connect to Azure/MSGraph
  $azure = Connect-AzureRmAccount
  Write-Host -ForegroundColor Blue "Connected to Azure tenant $($azure.Context.Tenant.Directory)"
  $graph = Connect-MSGraph
  Write-Host -ForegroundColor Yellow "Connected to MSGraph tenant $($graph.TenantId)"

  # Script
  $connection_string = $BlobConnectionString
  $storage_account = New-AzureStorageContext -ConnectionString $connection_string
  $container_name = $BlobContainerHashes
  $blobs = Get-AzureStorageBlob -Container $container_name -Context $storage_account
  foreach ($blob in $blobs) {
    Write-Host "Exporting Win10Hashes"
    Get-AzureStorageBlobContent -Container $container_name -Blob $blob.Name -Destination $outputPath -Context $storage_account
  }

  # Intune has a limit for 500 rows as maximum allowed import currently! We select max 500 csv files to combine them
  $downloadFiles = Get-ChildItem -Path $outputPath -Filter "*.csv" | select -First 500

  # Combine All hashes into a single CSV
  Set-Content -Path $outputCombined -Value "Device Serial Number,Windows Product ID,Hardware Hash" -Encoding Unicode
  Write-Host "Locate combined Windows10Hashes CSV files from Blob into single CSV: " -NoNewline
  $downloadFiles | % { Get-Content $_.FullName | Select -Index 1 } | Add-Content -Path $outputCombined -Encoding Unicode
  Write-Host -ForegroundColor Green "$outputCombined"

  # Upload Hashes to Intune
  Import-AutopilotCSV -csvFile $outputCombined

}
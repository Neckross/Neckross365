function Get-O365SoftDeletedAccounts {
  <#
  .SYNOPSIS
  Captures and output an Excel report on ALL Office 365 deleted accounts

  .DESCRIPTION
  Captures and output an Excel report on ALL Office 365 deleted accounts:
  MsolDeletedUsers
  SoftDeletedMailboxes
  SoftDeletedMailUsers

  .PARAMETER SearchString
  Parameter description

  .EXAMPLE
  Get-O365SoftDeletedAccounts
  This will export to an Excel sheet "Discovery.xlsx" in your Desktop
  It will include ALL SoftDeletedAccounts found in Office 365

  .EXAMPLE
  Get-O365SoftDeletedAccounts -SearchString "keyword"
  This will Out-Gridview to multiple windows found SoftDeletedAccounts with the selected keyword

  .NOTES
  General notes
  #>

  [CmdletBinding(DefaultParameterSetName = 'Placeholder')]
  param
  (
    [Parameter(ParameterSetName = "SearchString")]
    $SearchString
  )

  # Requirements Modules
  $module1 = Import-Module MSOnline -PassThru -ErrorAction Ignore
  if (-not $module1) {
    Write-Verbose "Installing module MSOnline"
    Install-Module MSOnline -Force
  }
  Import-Module MSOnline -Scope Global

  $module2 = Import-Module AzureAD -PassThru -ErrorAction Ignore
  if (-not $module2) {
    Write-Verbose "Installing module AzureAD"
    Install-Module AzureAD -Force
  }
  Import-Module AzureAD -Scope Global

  $module3 = Import-Module ExchangeOnlineManagement -PassThru -ErrorAction Ignore
  if (-not $module3) {
    Write-Verbose "Installing module ExchangeOnlineManagement"
    Install-Module ExchangeOnlineManagement -Force
  }
  Import-Module ExchangeOnlineManagement -Scope Global

  # Define export objects
  $SoftDeletedUsers = @(
    'DisplayName'
    'UserPrincipalName'
    'SoftDeletionTimestamp'
    'BlockCredential'
    'UserType'
    'IsLicensed'
    'Department'
    'LastPasswordChangeTimestamp'
    'WhenCreated'
    'ObjectId'
  )
  $SoftDeletedMailboxes = @(
    'DisplayName'
    'AccountDisabled'
    'RecipientTypeDetails'
    'IsDirSynced'
    'PrimarySmtpAddress'
    'WhenSoftDeleted'
    'UserPrincipalName'
    'SamAccountName'
    'Alias'
    'IsSoftDeletedByRemove'
    'IsSoftDeletedByDisable'
    'IsInactiveMailbox'
    'IsMailboxEnabled'
    'ProhibitSendReceiveQuota'
    'LitigationHoldEnabled'
    'RetentionHoldEnabled'
    'MailboxPlan'
    'WhenMailboxCreated'
    'WhenCreated'
    'WhenChanged'
    'Identity'
    'ExchangeGuid'
    'Guid'
  )
  $SoftDeletedMailUsers = @(
    'DisplayName'
    'AccountDisabled'
    'RecipientTypeDetails'
    'IsDirSynced'
    'PrimarySmtpAddress'
    'WhenSoftDeleted'
    'UserPrincipalName'
    'Alias'
    'IsSoftDeletedByRemove'
    'IsSoftDeletedByDisable'
    'IsInactiveMailbox'
    'WhenCreated'
    'WhenChanged'
    'Identity'
    'ExchangeObjectId'
    'Guid'
  )

  # Location
  $NeckrossPath = Join-Path ([Environment]::GetFolderPath("Desktop")) -ChildPath 'Neckross365'
  $Discovery = Join-Path $NeckrossPath -ChildPath 'Discovery'
  $Detailed = Join-Path $Discovery -ChildPath 'Detailed'
  $Csv = Join-Path $Discovery -ChildPath 'CSV'
  $null = New-Item -ItemType Directory -Path $Discovery -ErrorAction SilentlyContinue
  $null = New-Item -ItemType Directory -Path $Detailed  -ErrorAction SilentlyContinue
  $null = New-Item -ItemType Directory -Path $Csv -ErrorAction SilentlyContinue

  $CsvSplat = @{
    NoTypeInformation = $true
    Encoding          = 'UTF8'
  }

  # Script
  if ($SearchString) {
    #SoftDeletedUsers
    $users = Get-MsolUser -ReturnDeletedUsers -SearchString $SearchString
    $users | Select-Object $SoftDeletedUsers | Out-GridView -Title "SoftDeletedUsers keyword '$($SearchString)'"
    #SoftDeletedMailboxes
    $mbxs = Get-Mailbox -SoftDeletedMailbox -Anr $SearchString
    $mbxs | Select-Object $SoftDeletedMailboxes | Out-GridView -Title "SoftDeletedMailboxes keyword '$($SearchString)'"
    #SoftDeletedMailUsers
    $mailusers = Get-MailUser -SoftDeletedMailUser -Anr $SearchString
    $mailusers | Select-Object $SoftDeletedMailUsers | Out-GridView -Title "SoftDeletedMailUsers keyword '$($SearchString)'"
  }
  else {
    #SoftDeletedUsers
    $users = Get-MsolUser -ReturnDeletedUsers -All
    $users | Select-Object $SoftDeletedUsers | Sort-Object DisplayName | Export-Csv @CsvSplat -Path (Join-Path -Path $Csv -ChildPath 'SoftDeletedUsers.csv')
    #SoftDeletedMailboxes
    $mbxs = Get-Mailbox -SoftDeletedMailbox -ResultSize Unlimited
    $mbxs | Select-Object $SoftDeletedMailboxes | Sort-Object DisplayName | Export-Csv @CsvSplat -Path (Join-Path -Path $Csv -ChildPath 'SoftDeletedMailboxes.csv')
    #SoftDeletedMailUsers
    $mailusers = Get-MailUser -SoftDeletedMailUser -ResultSize Unlimited
    $mailusers | Select-Object $SoftDeletedMailUsers | Sort-Object DisplayName | Export-Csv @CsvSplat -Path (Join-Path -Path $Csv -ChildPath 'SoftDeletedMailUsers.csv')
  }

  # Create Excel Workbook
  $ExcelSplat = @{
    TableStyle              = 'Medium2'
    FreezeTopRowFirstColumn = $true
    FreezeFirstColumn       = $true
    AutoSize                = $true
    BoldTopRow              = $false
    ClearSheet              = $true
    ErrorAction             = 'SilentlyContinue'
  }
  Get-ChildItem -Path $CSV -Filter "*.csv" | Sort-Object BaseName |
  ForEach-Object { Import-Csv $_.fullname | Export-Excel @ExcelSplat -Path (Join-Path $Discovery 'O365_SoftDeletedAccounts.xlsx') -WorksheetName $_.basename }

  # Complete
  Write-Verbose "Script Complete"
  Write-Verbose "Results can be found on the Desktop in a folder named, Discovery"
}

function Get-NewBatches {
  <#
  .SYNOPSIS
  Capture a new set of Batches to update Batches.xlsx

  .DESCRIPTION
  Capture a new set of Batches to update Batches.xlsx
  You need a CSV file with existing columns:
  SamAccountName
  PrimarySmtpAddress

  .EXAMPLE
  Get-NewBatches -CsvFile "C:\Users\juan.sifuentes\Desktop\Core\AdditionalUsers_AddtoBATCHES.csv" | Export-Csv .\NewBatches.csv -NoTypeInformation

  .NOTES
  General notes
  #>

  [CmdletBinding()]
  param (
    [Parameter()]
    $CsvFile
  )

  $csv = Import-Csv -Path $CsvFile
  foreach ($CurCsv in $csv) {
    $AD, $EX, $EX2, $EX3 = $null
    $AD = Get-ADUser -Properties * -Identity $CurCsv.SamAccountName
    $EX = Get-Mailbox -Identity $CurCsv.PrimarySmtpAddress
    $EX2 = Get-MailboxRegionalConfiguration -Identity $CurCsv.PrimarySmtpAddress
    $EX3 = Get-MailboxStatistics -Identity $CurCsv.PrimarySmtpAddress
    if ($EX.ForwardingAddress) {
      $EX4 = (Get-Recipient -Identity $EX.ForwardingAddress).RecipientTypeDetails
    }
    Write-Host -ForegroundColor Green "Created new Batches for user: " -NoNewline
    Write-Host -ForegroundColor Cyan "$($AD.DisplayName)"
    [PSCustomObject]@{
      BatchName                  = ''
      DisplayName                = $AD.DisplayName
      Enabled                    = $AD.Enabled
      Department                 = $AD.Department
      MigrationDate              = ''
      OrganizationalUnit         = $EX.OrganizationalUnit
      UserPrincipalName          = $AD.UserPrincipalName
      PrimarySmtpAddress         = $EX.PrimarySmtpAddress
      IntuneMDMiOS               = ''
      IntuneMAMiOSAndroid        = ''
      LicenseGroup               = ''
      RecipientTypeDetails       = $EX.RecipientTypeDetails
      ConvertToShared            = ''
      NoMFA                      = ''
      TimeZone                   = $EX2.TimeZone
      RetentionPolicy            = $EX.RetentionPolicy
      TotalGB                    = [Math]::Round([Double]($EX3.TotalItemSize -replace '^.*\(| .+$|,') / 1GB, 4)
      ForwardingAddress          = $EX.ForwardingAddress
      ForwardingRecipientType    = $EX4
      ForwardingSmtpAddress      = $EX.ForwardingSmtpAddress
      DeliverToMailboxAndForward = $EX.DeliverToMailboxAndForward
      ExchangeGuid               = $EX.ExchangeGuid
      ItemCount                  = $EX3.ItemCount
      Alias                      = $EX.Alias
      Database                   = $EX.Database
      ServerName                 = $EX.ServerName
      Office                     = $AD.Office
      SamAccountName             = $AD.SamAccountName
      MIGRATEDTargetAddress      = $AD.targetAddress
      ONPREMServerName           = $AD.msExchHomeServerName
    }
  }
}

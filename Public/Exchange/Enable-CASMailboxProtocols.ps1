function Enable-CASMailboxProtocols {
  <#
.SYNOPSIS
Run first Get-CASMailboxProtocols to review CAS mailbox protocols state
Force enable ALL CAS mailboxes protocols to TRUE

.DESCRIPTION
Run first Get-CASMailboxProtocols to review CAS mailbox protocols state
Force enable ALL CAS mailboxes protocols to TRUE

.EXAMPLE
Enable-CASMailboxProtocols -CsvFile C:\Scripts\GetCASMailboxProtocols.csv | Out-GridView

.NOTES
General notes
#>

  param (
    [Parameter(Mandatory)]
    $CsvFile
  )

  $Enabled = $true
  $csv = Import-Csv -Path $CsvFile
  foreach ($CurCsv in $csv) {
    $SetCAS = @{
      Identity                = $CurCsv.PrimarySmtpAddress
      ActiveSyncEnabled       = $Enabled
      OWAEnabled              = $Enabled
      OWAforDevicesEnabled    = $Enabled
      EwsEnabled              = $Enabled
      PopEnabled              = $Enabled
      ImapEnabled             = $Enabled
      MAPIEnabled             = $Enabled
      UniversalOutlookEnabled = $Enabled
      OutlookMobileEnabled    = $Enabled
      MacOutlookEnabled       = $Enabled
      ErrorAction             = "Stop"
    }
    $SetMbx = @{
      Identity     = $CurCsv.PrimarySmtpAddress
      AuditEnabled = $Enabled
      ErrorAction  = "Stop"
    }
    try {
      Set-CASMailbox @SetCAS
      [PSCustomObject]@{
        DisplayName          = $CurCsv.DisplayName
        PrimarySmtpAddress   = $CurCsv.PrimarySmtpAddress
        RecipientTypeDetails = $CurCsv.RecipientTypeDetails
        Result               = 'SUCCESS'
        Log                  = 'SUCCESS'
      }
    }
    catch {
      [PSCustomObject]@{
        DisplayName          = $CurCsv.DisplayName
        PrimarySmtpAddress   = $CurCsv.PrimarySmtpAddress
        RecipientTypeDetails = $CurCsv.RecipientTypeDetails
        Result               = 'FAILED'
        Log                  = "$($_.Exception.Message)"
      }
    }
    try {
      Set-Mailbox @SetMbx
      [PSCustomObject]@{
        DisplayName          = $CurCsv.DisplayName
        PrimarySmtpAddress   = $CurCsv.PrimarySmtpAddress
        RecipientTypeDetails = $CurCsv.RecipientTypeDetails
        Result               = 'SUCCESS'
        Log                  = 'SUCCESS'
      }
    }
    catch {
      [PSCustomObject]@{
        DisplayName          = $CurCsv.DisplayName
        PrimarySmtpAddress   = $CurCsv.PrimarySmtpAddress
        RecipientTypeDetails = $CurCsv.RecipientTypeDetails
        Result               = 'FAILED'
        Log                  = "$($_.Exception.Message)"
      }
    }
  }
}

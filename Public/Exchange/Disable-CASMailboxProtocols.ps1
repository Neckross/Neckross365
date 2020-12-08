function Disable-CASMailboxProtocols {
  <#
.SYNOPSIS
Run first Get-CASMailboxProtocols to review CAS mailbox protocols state
Force disable ALL CAS mailboxes protocols to FALSE

.DESCRIPTION
Run first Get-CASMailboxProtocols to review CAS mailbox protocols state
Force disable ALL CAS mailboxes protocols to FALSE

.EXAMPLE
Disable-CASMailboxProtocols -CsvFile C:\Scripts\GetCASMailboxProtocols.csv | Out-GridView

.NOTES
General notes
#>

  param
  (
    [Parameter(ParameterSetName = "CsvFile")]
    $CsvFile,

    [Parameter(ParameterSetName = "PrimarySmtpAddress")]
    $PrimarySmtpAddress
  )

  if ($CsvFile) {
    $Disabled = $false
    $csv = $null
    $csv = Import-Csv -Path $CsvFile
    foreach ($CurCsv in $csv) {
      $SetCAS = @{
        Identity                = $CurCsv.PrimarySmtpAddress
        ActiveSyncEnabled       = $Disabled
        OWAEnabled              = $Disabled
        OWAforDevicesEnabled    = $Disabled
        EwsEnabled              = $Disabled
        PopEnabled              = $Disabled
        ImapEnabled             = $Disabled
        MAPIEnabled             = $Disabled
        UniversalOutlookEnabled = $Disabled
        OutlookMobileEnabled    = $Disabled
        MacOutlookEnabled       = $Disabled
        ErrorAction             = "Stop"
      }
      try {
        Set-CASMailbox @SetCAS
        [PSCustomObject]@{
          DisplayName          = $CurCsv.DisplayName
          PrimarySmtpAddress   = $CurCsv.PrimarySmtpAddress
          RecipientTypeDetails = $CurCsv.RecipientTypeDetails
          Result               = 'SET-CASMailbox'
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

  elseif ($PrimarySmtpAddress) {
    $Disabled = $false
    $CASmbx = $null
    $mbx = $null
    $CASmbx = Get-CASMailbox -Identity $PrimarySmtpAddress
    $mbx = Get-Mailbox -Identity $PrimarySmtpAddress
    foreach ($CurCASmbx in $CASmbx) {
      $SetCAS = @{
        Identity                = $CurCASmbx.PrimarySmtpAddress
        ActiveSyncEnabled       = $Disabled
        OWAEnabled              = $Disabled
        OWAforDevicesEnabled    = $Disabled
        EwsEnabled              = $Disabled
        PopEnabled              = $Disabled
        ImapEnabled             = $Disabled
        MAPIEnabled             = $Disabled
        UniversalOutlookEnabled = $Disabled
        OutlookMobileEnabled    = $Disabled
        MacOutlookEnabled       = $Disabled
        ErrorAction             = "Stop"
      }
      try {
        Set-CASMailbox @SetCAS
        [PSCustomObject]@{
          DisplayName          = $CurCASmbx.DisplayName
          PrimarySmtpAddress   = $CurCASmbx.PrimarySmtpAddress
          RecipientTypeDetails = $mbx.RecipientTypeDetails
          Result               = 'SET-CASMailbox'
          Log                  = 'SUCCESS'
        }
      }
      catch {
        [PSCustomObject]@{
          DisplayName          = $CurCASmbx.DisplayName
          PrimarySmtpAddress   = $CurCASmbx.PrimarySmtpAddress
          RecipientTypeDetails = $mbx.RecipientTypeDetails
          Result               = 'FAILED'
          Log                  = "$($_.Exception.Message)"
        }
      }
    }
  }
}
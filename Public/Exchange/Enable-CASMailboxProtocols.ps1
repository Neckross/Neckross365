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

  param
  (
    [Parameter(ParameterSetName = "CsvFile")]
    $CsvFile,

    [Parameter(ParameterSetName = "PrimarySmtpAddress")]
    $PrimarySmtpAddress
  )

  if ($CsvFile) {
    $Enabled = $true
    $csv = $null
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
      try {
        Set-Mailbox @SetMbx
        [PSCustomObject]@{
          DisplayName          = $CurCsv.DisplayName
          PrimarySmtpAddress   = $CurCsv.PrimarySmtpAddress
          RecipientTypeDetails = $CurCsv.RecipientTypeDetails
          Result               = 'Set-Mailbox'
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
    $Enabled = $true
    $CASmbx = $null
    $mbx = $null
    $CASmbx = Get-CASMailbox -Identity $PrimarySmtpAddress
    $mbx = Get-Mailbox -Identity $PrimarySmtpAddress
    foreach ($CurCASmbx in $CASmbx) {
      $SetCAS = @{
        Identity                = $CurCASmbx.PrimarySmtpAddress
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
        Identity     = $CurCASmbx.PrimarySmtpAddress
        AuditEnabled = $Enabled
        ErrorAction  = "Stop"
      }
      try {
        Set-CASMailbox @SetCAS
        [PSCustomObject]@{
          DisplayName          = $CurCASmbx.DisplayName
          PrimarySmtpAddress   = $CurCASmbx.PrimarySmtpAddress
          RecipientTypeDetails = $mbx.RecipientTypeDetails
          Result               = 'Set-CASMailbox'
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
      try {
        Set-Mailbox @SetMbx
        [PSCustomObject]@{
          DisplayName          = $CurCASmbx.DisplayName
          PrimarySmtpAddress   = $CurCASmbx.PrimarySmtpAddress
          RecipientTypeDetails = $mbx.RecipientTypeDetails
          Result               = 'Set-Mailbox'
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
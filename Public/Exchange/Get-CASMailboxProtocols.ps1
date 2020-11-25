function Get-CASMailboxProtocols {
  <#
.SYNOPSIS
Reports on ALL CAS Mailboxes Protocols state

.DESCRIPTION
Reports on ALL CAS Mailboxes Protocols state

.EXAMPLE
Get-CASMailboxProtocols -All | Out-GridView
Get-CASMailboxProtocols -All | Export-Csv "C:\Scripts\GetCASMailboxProtocols.csv" -nti
Get-CASMailboxProtocols -CsvFile "C:\Scripts\GetCASMailboxProtocols.csv" | Out-GridView
Get-CASMailboxProtocols -CsvFile "C:\Scripts\GetCASMailboxProtocols.csv" | Export-Csv "C:\Scripts\NEWGetCASMailboxProtocols.csv" -nti

.NOTES
General notes
#>

  [CmdletBinding()]
  param
  (
    [Parameter()]
    [switch]
    $All,

    [Parameter()]
    $CsvFile
  )

  if ($All) {
    $CASmbxs = Get-CASMailbox -ResultSize unlimited
    foreach ($CurCASMbx in $CASmbxs) {
      $mbxs = $null
      $mbxs = Get-Mailbox -Identity $CurCASMbx.PrimarySmtpAddress
      [PSCustomObject]@{
        DisplayName             = $CurCASMbx.DisplayName
        PrimarySmtpAddress      = $CurCASMbx.PrimarySmtpAddress
        RecipientTypeDetails    = $mbxs.RecipientTypeDetails
        AuditEnabled            = $mbxs.AuditEnabled
        ActiveSyncEnabled       = $CurCASMbx.ActiveSyncEnabled
        OWAEnabled              = $CurCASMbx.OWAEnabled
        OWAforDevicesEnabled    = $CurCASMbx.OWAforDevicesEnabled
        EwsEnabled              = $CurCASMbx.EwsEnabled
        PopEnabled              = $CurCASMbx.PopEnabled
        ImapEnabled             = $CurCASMbx.ImapEnabled
        MAPIEnabled             = $CurCASMbx.MAPIEnabled
        UniversalOutlookEnabled = $CurCASMbx.UniversalOutlookEnabled
        OutlookMobileEnabled    = $CurCASMbx.OutlookMobileEnabled
        MacOutlookEnabled       = $CurCASMbx.MacOutlookEnabled
      }
    }
  }
  else {
    $csv = Import-Csv -Path $CsvFile
    foreach ($CurCsv in $csv) {
      $mbxs = $null
      $CASmbxs = $null
      $CASmbxs = Get-CASMailbox -Identity $CurCsv.PrimarySmtpAddress
      $mbxs = Get-Mailbox -Identity $CurCsv.PrimarySmtpAddress
      [PSCustomObject]@{
        DisplayName             = $CASmbxs.DisplayName
        PrimarySmtpAddress      = $CASmbxs.PrimarySmtpAddress
        RecipientTypeDetails    = $mbxs.RecipientTypeDetails
        AuditEnabled            = $mbxs.AuditEnabled
        ActiveSyncEnabled       = $CASmbxs.ActiveSyncEnabled
        OWAEnabled              = $CASmbxs.OWAEnabled
        OWAforDevicesEnabled    = $CASmbxs.OWAforDevicesEnabled
        EwsEnabled              = $CASmbxs.EwsEnabled
        PopEnabled              = $CASmbxs.PopEnabled
        ImapEnabled             = $CASmbxs.ImapEnabled
        MAPIEnabled             = $CASmbxs.MAPIEnabled
        UniversalOutlookEnabled = $CASmbxs.UniversalOutlookEnabled
        OutlookMobileEnabled    = $CASmbxs.OutlookMobileEnabled
        MacOutlookEnabled       = $CASmbxs.MacOutlookEnabled
      }
    }
  }
}

function Get-MailboxReport {
  <#
  .SYNOPSIS
  Capture Mailboxes Report

  .DESCRIPTION
  Capture Mailboxes Report
  It can capture all mailboxes or from a CSV file (PrimarySmtpAddress needed)

  .EXAMPLE
  Get-MailboxReport | Out-GridView

  .EXAMPLE
  Get-MailboxReport -CsvFile C:\Scripts\file.csv | Out-GridView

  .NOTES
  General notes
  #>

  [CmdletBinding(DefaultParameterSetName = 'Placeholder')]
  param
  (
    [Parameter(ParameterSetName = "CsvFile")]
    $CsvFile
  )

  if ($CsvFile) {
    $csv = Import-Csv -Path $CsvFile
    foreach ($CurCsv in $csv) {
      $mbxs = Get-Mailbox -Identity $CurCsv.PrimarySmtpAddress
      if ($mbxs.ForwardingAddress) {
        $forwarding = (Get-Recipient -Identity $mbxs.ForwardingAddress).RecipientTypeDetails
      }
      [PSCustomObject]@{
        Name                       = $mbxs.Name
        DisplayName                = $mbxs.DisplayName
        AccountDisabled            = $mbxs.AccountDisabled
        PrimarySmtpAddress         = $mbxs.PrimarySmtpAddress
        UserPrincipalName          = $mbxs.UserPrincipalName
        SamAccountName             = $mbxs.SamAccountName
        Alias                      = $mbxs.Alias
        RecipientTypeDetails       = $mbxs.RecipientTypeDetails
        ForwardingAddress          = $mbxs.ForwardingAddress
        ForwardingRecipientType    = $forwarding
        ForwardingSmtpAddress      = $mbxs.ForwardingSmtpAddress
        DeliverToMailboxAndForward = $mbxs.DeliverToMailboxAndForward
        EmailAddressPolicyEnabled  = $mbxs.EmailAddressPolicyEnabled
        HiddenFromGAL              = $mbxs.HiddenFromAddressListsEnabled
        OrganizationalUnit         = $mbxs.OrganizationalUnit
        RetentionPolicy            = $mbxs.RetentionPolicy
        Database                   = $mbxs.Database
        ServerName                 = $mbxs.ServerName
        ExchangeGuid               = $mbxs.ExchangeGuid
        Guid                       = $mbxs.Guid
        LegacyExchangeDN           = $mbxs.LegacyExchangeDN
        O365TenantProxy            = @($mbxs.EmailAddresses) -like "*mail.onmicrosoft.com" -join "|"
        EmailAddresses             = @($mbxs.EmailAddresses) -ne '' -join '|'
      }
    }
  }
  else {
    $mbxs = Get-Mailbox -ResultSize Unlimited
    foreach ($CurMbx in $mbxs) {
      if ($CurMbx.ForwardingAddress) {
        $forwarding = (Get-Recipient -Identity $CurMbx.ForwardingAddress).RecipientTypeDetails
      }
      [PSCustomObject]@{
        Name                       = $CurMbx.Name
        DisplayName                = $CurMbx.DisplayName
        AccountDisabled            = $CurMbx.AccountDisabled
        PrimarySmtpAddress         = $CurMbx.PrimarySmtpAddress
        UserPrincipalName          = $CurMbx.UserPrincipalName
        SamAccountName             = $CurMbx.SamAccountName
        Alias                      = $CurMbx.Alias
        RecipientTypeDetails       = $CurMbx.RecipientTypeDetails
        ForwardingAddress          = $CurMbx.ForwardingAddress
        ForwardingRecipientType    = $forwarding
        ForwardingSmtpAddress      = $CurMbx.ForwardingSmtpAddress
        DeliverToMailboxAndForward = $CurMbx.DeliverToMailboxAndForward
        EmailAddressPolicyEnabled  = $CurMbx.EmailAddressPolicyEnabled
        HiddenFromGAL              = $CurMbx.HiddenFromAddressListsEnabled
        OrganizationalUnit         = $CurMbx.OrganizationalUnit
        RetentionPolicy            = $CurMbx.RetentionPolicy
        Database                   = $CurMbx.Database
        ServerName                 = $CurMbx.ServerName
        ExchangeGuid               = $CurMbx.ExchangeGuid
        Guid                       = $CurMbx.Guid
        LegacyExchangeDN           = $CurMbx.LegacyExchangeDN
        O365TenantProxy            = @($CurMbx.EmailAddresses) -like "*mail.onmicrosoft.com" -join "|"
        EmailAddresses             = @($CurMbx.EmailAddresses) -ne '' -join '|'
      }
    }
  }
}

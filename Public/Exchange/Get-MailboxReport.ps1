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
      foreach ($CurMbx in $mbxs) {
        $users = Get-ADUser -Identity $CurMbx.Guid.toString()
        if ($CurMbx.ForwardingAddress) {
          $forwardingType = (Get-Recipient -Identity $CurMbx.ForwardingAddress).RecipientTypeDetails
          $forwardingAddress = (Get-Recipient -Identity $CurMbx.ForwardingAddress).PrimarySmtpAddress
        } foreach ($CurUser in $users) {
          [PSCustomObject]@{
            Name                       = $CurMbx.Name
            DisplayName                = $CurMbx.DisplayName
            Enabled                    = $CurUser.Enabled
            PrimarySmtpAddress         = $CurMbx.PrimarySmtpAddress
            UserPrincipalName          = $CurMbx.UserPrincipalName
            SamAccountName             = $CurMbx.SamAccountName
            Alias                      = $CurMbx.Alias
            RecipientTypeDetails       = $CurMbx.RecipientTypeDetails
            ForwardingAddress          = $forwardingAddress
            ForwardingRecipientType    = $forwardingType
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
  }
  else {
    $mbxs = Get-Mailbox -ResultSize Unlimited
    foreach ($CurMbx in $mbxs) {
      $users = Get-ADUser -Identity $CurMbx.Guid.toString()
      if ($CurMbx.ForwardingAddress) {
        $forwardingType = (Get-Recipient -Identity $CurMbx.ForwardingAddress).RecipientTypeDetails
        $forwardingAddress = (Get-Recipient -Identity $CurMbx.ForwardingAddress).PrimarySmtpAddress
      } foreach ($CurUser in $users) {
        [PSCustomObject]@{
          Name                       = $CurMbx.Name
          DisplayName                = $CurMbx.DisplayName
          Enabled                    = $CurUser.Enabled
          PrimarySmtpAddress         = $CurMbx.PrimarySmtpAddress
          UserPrincipalName          = $CurMbx.UserPrincipalName
          SamAccountName             = $CurMbx.SamAccountName
          Alias                      = $CurMbx.Alias
          RecipientTypeDetails       = $CurMbx.RecipientTypeDetails
          ForwardingAddress          = $forwardingAddress
          ForwardingRecipientType    = $forwardingType
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
}
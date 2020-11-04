function Get-MailboxBrokenEAP {
  <#
  .SYNOPSIS
  Captures users missing the Office 365 tenant proxy address
  (tenant.mail.onmicrosoft.com)

  .DESCRIPTION
  You will then use the function Set-MailboxBrokenEAP to apply NEWAlias + MissingO365Proxy

  .EXAMPLE
  Get-MailboxBrokenEAP -O365TenantProxy "newportgroupinc.mail.onmicrosoft.com" | Out-GridView -Title "List of users MISSING Office365 Tenant proxyaddress"
  Get-MailboxBrokenEAP -O365TenantProxy "newportgroupinc.mail.onmicrosoft.com" | Export-Csv -Path "C:\Scripts\GetMailboxBrokenEAP.csv" -NoTypeInformation

  .NOTES
  General notes
  #>

  param (
    [Parameter(Mandatory)]
    $O365TenantProxy
  )

  $mbxs = Get-Mailbox -ResultSize Unlimited
  foreach ($CurMbx in $mbxs) {
    if (($CurMbx.EmailAddresses -join '|') -notmatch $O365TenantProxy) {
      $CurUser = Get-ADUser -Identity $CurMbx.SamAccountName -Properties *
      [PSCustomObject]@{
        DisplayName               = $CurMbx.DisplayName
        UserPrincipalName         = $CurMbx.UserPrincipalName
        PrimarySmtpAddress        = $CurMbx.PrimarySmtpAddress
        EmailAddressPolicyEnabled = $CurMbx.EmailAddressPolicyEnabled
        Alias                     = $CurMbx.Alias
        NEWAlias                  = ''
        OrganizationalUnit        = $CurMbx.OrganizationalUnit
        Office                    = $CurMbx.Office
        Description               = $CurUser.Description
        SamAccountName            = $CurMbx.SamAccountName
        EmailAddresses            = ($CurMbx.EmailAddresses -join '|')
      }
    }
  }
}
function Get-OnpremSipUsers {
  <#
.SYNOPSIS
Captures AD users with an existing SIP address

.DESCRIPTION
Captures AD users with an existing SIP address

.EXAMPLE
Get-OnpremSipUsers | Out-GridView

.NOTES
General notes
#>

  $users = Get-ADUser -Properties * -Filter *
  foreach ($CurUser in $users) {
    foreach ($Proxy in $CurUser.ProxyAddresses) {
      if ($Proxy -like "sip:*") {
        [PSCustomObject]@{
          DisplayName    = $CurUser.DisplayName
          UPN            = $CurUser.UserPrincipalName
          SMTP           = $CurUser.Mail
          SIPproxy       = $Proxy
          SIPprimary     = $CurUser.'msRTCSIP-PrimaryUserAddress'
          SIPenabled     = $CurUser.'msRTCSIP-UserEnabled'
          SIPpool        = $CurUser.'msRTCSIP-DeploymentLocator'
          ProxyAddresses = @($CurUser.ProxyAddresses) -ne '' -join '|'
        }
      }
    }
  }
}
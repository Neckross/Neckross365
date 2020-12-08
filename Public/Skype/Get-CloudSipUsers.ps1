function Get-CloudSipUsers {
  <#
.SYNOPSIS
Captures MSOL users with an existing SIP address

.DESCRIPTION
Captures MSOL users with an existing SIP address

.EXAMPLE
Get-CloudSipUsers | Out-GridView

.NOTES
General notes
#>

  $users = Get-MsolUser -All
  foreach ($CurUser in $users) {
    foreach ($SIPprimary in $CurUser.MSRtcSipPrimaryUserAddress) {
      if ($SIPprimary -like "sip:*") {
        $Skype = Get-CsOnlineUser -Identity $CurUser.UserPrincipalName
        [PSCustomObject]@{
          DisplayName        = $CurUser.DisplayName
          UPN                = $CurUser.UserPrincipalName
          SMTP               = $Skype.WindowsEmailAddress
          DirSyncEnabled     = $Skype.DirSyncEnabled
          TeamsMode          = $Skype.TeamsUpgradeEffectiveMode
          CloudSIPproxy      = $Skype.SipProxyAddress
          CloudSIPprimary    = $Skype.SipAddress
          CloudEnabled       = $Skype.Enabled
          CloudVoiceEnabled  = $Skype.EnterpriseVoiceEnabled
          CloudPool          = $Skype.HostingProvider
          OnPremSIPproxy     = $SIPprimary
          OnPremSIPprimary   = $Skype.OnPremSipAddress
          OnpremEnabled      = $Skype.OnPremSIPEnabled
          OnpremVoiceEnabled = $Skype.OnPremEnterpriseVoiceEnabled
          OnpremPool         = $Skype.OnPremHostingProvider
          ProxyAddresses     = @($CurUser.ProxyAddresses) -ne '' -join '|'
        }
      }
    }
  }
}
function Get-CloudSipUsers {
  <#
.SYNOPSIS
Captures CSOnline skype users with an existing SIP address

.DESCRIPTION
Captures CSOnline skype users with an existing SIP address

.EXAMPLE
Get-CloudSipUsers | Out-GridView

.NOTES
General notes
#>

  $skype = Get-CsOnlineUser -ResultSize Unlimited
  foreach ($CurSkype in $skype) {
    $users = Get-MsolUser -UserPrincipalName $CurSkype.UserPrincipalName
    [PSCustomObject]@{
      DisplayName         = $CurSkype.DisplayName
      UPN                 = $CurSkype.UserPrincipalName
      SMTP                = $CurSkype.WindowsEmailAddress
      DirSyncEnabled      = $CurSkype.DirSyncEnabled
      TeamsMode           = $CurSkype.TeamsUpgradeEffectiveMode
      InterpretedUserType = $CurSkype.InterpretedUserType
      CloudSIPproxy       = $CurSkype.SipProxyAddress
      CloudSIPprimary     = $CurSkype.SipAddress
      CloudEnabled        = $CurSkype.Enabled
      CloudVoiceEnabled   = $CurSkype.EnterpriseVoiceEnabled
      CloudPool           = $CurSkype.HostingProvider
      OnPremSIPproxy      = $users.MSRtcSipPrimaryUserAddress
      OnPremSIPprimary    = $CurSkype.OnPremSipAddress
      OnpremEnabled       = $CurSkype.OnPremSIPEnabled
      OnpremVoiceEnabled  = $CurSkype.OnPremEnterpriseVoiceEnabled
      OnpremPool          = $CurSkype.OnPremHostingProvider
      ProxyAddresses      = @($CurSkype.ProxyAddresses) -ne '' -join '|'
    }
  }
}
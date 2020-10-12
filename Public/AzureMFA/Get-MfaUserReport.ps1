function Get-MfaUserReport {

  <#
    .SYNOPSIS
    Gather Azure MFA user report

    .DESCRIPTION
    Gather Azure MFA user report

    .EXAMPLE
    Get-MfaUserReport -UserPrincipalName <user@domain.com>

    .EXAMPLE
    Get-MfaUserReport -All

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
    $UserPrincipalName
  )

  if ($All) {
    $MSOLUserMFAProperties = @(
      'DisplayName'
      'BlockCredential'
      'UserPrincipalName'
      @{n = "MFA_State"; e = { ($_.StrongAuthenticationRequirements).State } }
      @{n = "DefaultMethod"; e = { ($_.StrongAuthenticationMethods).Where( { $_.IsDefault } ).MethodType } }
      @{n = "Methods"; e = { (($_.StrongAuthenticationMethods).MethodType) -join ";" } }
      @{n = "MethodChoice"; e = { (($_.StrongAuthenticationMethods).IsDefault) -join ";" } }
      @{n = "Auth_AlternatePhoneNumber"; e = { ($_.StrongAuthenticationUserDetails).AlternativePhoneNumber } }
      @{n = "Auth_Email"; e = { ($_.StrongAuthenticationUserDetails).Email } }
      @{n = "Auth_OldPin"; e = { ($_.StrongAuthenticationUserDetails).OldPin } }
      @{n = "Auth_PhoneNumber"; e = { ($_.StrongAuthenticationUserDetails).PhoneNumber } }
      @{n = "Auth_Pin"; e = { ($_.StrongAuthenticationUserDetails).Pin } }
      'Department'
      'PhoneNumber'
      'MobilePhone'
      'Office'
      'LastDirSyncTime'
      'IsLicensed'
    )
    Get-MsolUser -All:$true | Select-Object $MSOLUserMFAProperties
  }

  else {
    $MSOLUserMFAProperties = @(
      'DisplayName'
      'BlockCredential'
      'UserPrincipalName'
      @{n = "MFA_State"; e = { ($_.StrongAuthenticationRequirements).State } }
      @{n = "DefaultMethod"; e = { ($_.StrongAuthenticationMethods).Where( { $_.IsDefault } ).MethodType } }
      @{n = "Methods"; e = { (($_.StrongAuthenticationMethods).MethodType) -join ";" } }
      @{n = "MethodChoice"; e = { (($_.StrongAuthenticationMethods).IsDefault) -join ";" } }
      @{n = "Auth_AlternatePhoneNumber"; e = { ($_.StrongAuthenticationUserDetails).AlternativePhoneNumber } }
      @{n = "Auth_Email"; e = { ($_.StrongAuthenticationUserDetails).Email } }
      @{n = "Auth_OldPin"; e = { ($_.StrongAuthenticationUserDetails).OldPin } }
      @{n = "Auth_PhoneNumber"; e = { ($_.StrongAuthenticationUserDetails).PhoneNumber } }
      @{n = "Auth_Pin"; e = { ($_.StrongAuthenticationUserDetails).Pin } }
      'Department'
      'PhoneNumber'
      'MobilePhone'
      'Office'
      'LastDirSyncTime'
      'IsLicensed'
    )
    Get-MsolUser -UserPrincipalName $UserPrincipalName | Select-Object $MSOLUserMFAProperties
  }
}

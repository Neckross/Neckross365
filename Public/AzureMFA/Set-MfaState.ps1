function Set-MfaState {

  <#
  .SYNOPSIS
  Convert MFA users to Azure MFA Conditional Access users

  .DESCRIPTION
  Convert MFA users to Azure MFA Conditional Access users

  .PARAMETER UserPrincipalName
  Enter UserPrincipalName

  .PARAMETER State
  Enter State

  .EXAMPLE
  Set-MfaState -UserPrincipalName <user@domain.com> -State Disabled

  .EXAMPLE
  Get-MsolUser -All | Set-MfaState -State Disabled

  .NOTES
  General notes
  #>

  [CmdletBinding()]
  param(
    [Parameter(ValueFromPipelineByPropertyName = $True)]
    $ObjectId,
    [Parameter(ValueFromPipelineByPropertyName = $True)]
    $UserPrincipalName,
    [ValidateSet("Disabled", "Enabled", "Enforced")]
    $State
  )

  Process {
    Write-Verbose ("Setting MFA state for user '{0}' to '{1}'." -f $ObjectId, $State)
    $Requirements = @()
    if ($State -ne "Disabled") {
      $Requirement =
      [Microsoft.Online.Administration.StrongAuthenticationRequirement]::new()
      $Requirement.RelyingParty = "*"
      $Requirement.State = $State
      $Requirements += $Requirement
    }

    Set-MsolUser -ObjectId $ObjectId -UserPrincipalName $UserPrincipalName `
      -StrongAuthenticationRequirements $Requirements
  }
}
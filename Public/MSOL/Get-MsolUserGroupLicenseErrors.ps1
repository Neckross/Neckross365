function Get-MsolUserGroupLicenseErrors {
  <#
  .SYNOPSIS
  Capture all users with group licensing errors

  .DESCRIPTION
  Capture all users with group licensing errors

  .EXAMPLE
  Get-MsolUserGroupLicenseErrors | Out-GridView

  .NOTES
  General notes
  #>
  $users = Get-MsolUser -All | ? { $_.IndirectLicenseErrors -notlike $null }
  foreach ($CurUser in $users) {
    $ReferencedObjectId = $null
    $ReferencedObjectId = $CurUser.IndirectLicenseErrors.ReferencedObjectId
    $groups = Get-MsolGroup -ObjectId $ReferencedObjectId
    [PSCustomObject]@{
      UserName     = $CurUser.DisplayName
      UserUPN      = $CurUser.UserPrincipalName
      UserId       = $CurUser.ObjectId
      GroupName    = $groups.DisplayName
      GroupId      = $groups.ObjectId
      LicenseError = $CurUser.IndirectLicenseErrors.Error
      LicenseName  = $CurUser.IndirectLicenseErrors.AccountSku.SkuPartNumber
    }
  }
}

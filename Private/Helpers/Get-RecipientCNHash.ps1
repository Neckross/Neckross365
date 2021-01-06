function Get-RecipientCNHash {
  <#
  .SYNOPSIS
  Builds a Hashable table for Get-Recipient using ALIAS

  .DESCRIPTION
  Builds a Hashable table for Get-Recipient using ALIAS

  .EXAMPLE
  Get-RecipientCNHash

  .NOTES
  General notes
  #>

  [CmdletBinding()]
  param ( )

  $RecipientHash = @{ }
  $RecipientList = Get-Recipient -ResultSize Unlimited
  foreach ($Recipient in $RecipientList) {
    $RecipientHash[$Recipient.Identity] = $Recipient.Alias
  }
  $RecipientHash
}
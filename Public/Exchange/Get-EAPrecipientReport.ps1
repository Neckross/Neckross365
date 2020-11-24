function Get-EAPrecipientReport {
  <#
.SYNOPSIS
Report Email Address Policy assigned to a recipient

.DESCRIPTION
Report Email Address Policy assigned to a recipient

.EXAMPLE
Get-EAPrecipientReport | Out-GridView

.NOTES
General notes
#>
  $recipients = Get-Recipient -ResultSize Unlimited
  foreach ($CurRecipient in $recipients) {
    $policies = $CurRecipient.PoliciesIncluded[0]
    $EAP = Get-EmailAddressPolicy | Where-Object { $_.Guid -match $policies }
    [PSCustomObject]@{
      RecipientName  = $CurRecipient.Name
      EapName        = $EAP.Name
      RecipientOU    = $CurRecipient.OrganizationalUnit
      RecipientType  = $CurRecipient.RecipientTypeDetails
      RecipientSMTP  = $CurRecipient.PrimarySmtpAddress
      EapContainer   = $EAP.RecipientContainer
      EapPriority    = $EAP.Priority
      EapRecipients  = $EAP.IncludedRecipients
      EapPrimarySMTP = $EAP.EnabledPrimarySMTPAddressTemplate
      EapAlias       = $EAP.EnabledEmailAddressTemplates
      RecipientAlias = ($CurRecipient.EmailAddresses -join '|')
    }
  }
}

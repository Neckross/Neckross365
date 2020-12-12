function Get-MailboxQuotaReport {
  <#
.SYNOPSIS
Report EXO mailbox size quota limits for ALL or single mailbox

.DESCRIPTION
Report EXO mailbox size quota limits for ALL or single mailbox

.EXAMPLE
Get-MailboxQuotaReport -PrimarySmtpAddress user@domain.com | Out-GridView
Get-MailboxQuotaReport | Out-GridView

.NOTES
General notes
#>

  [CmdletBinding(DefaultParameterSetName = 'Placeholder')]
  param
  (
    [Parameter(ParameterSetName = "PrimarySmtpAddress")]
    $PrimarySmtpAddress
  )

  if ($PrimarySmtpAddress) {
    $mbxs = Get-Mailbox -Identity $PrimarySmtpAddress
    foreach ($CurMbx in $mbxs) {
      $users = Get-MsolUser -UserPrincipalName $CurMbx.UserPrincipalName
      $mbxStats = Get-MailboxStatistics -Identity $CurMbx.PrimarySmtpAddress
      $mbxPlanStats = Get-MailboxPlan -Identity $CurMbx.MailboxPlan
      [PSCustomObject]@{
        DisplayName                     = $CurMbx.DisplayName
        PrimarySmtpAddress              = $CurMbx.PrimarySmtpAddress
        RecipientTypeDetails            = $CurMbx.RecipientTypeDetails
        IsDirSynced                     = $CurMbx.IsDirSynced
        IsLicensed                      = $users.IsLicensed
        IsArchiveEnabled                = $mbxStats.IsArchiveMailbox
        MailboxSizeGB                   = [Math]::Round([Double]($mbxStats.TotalItemSize -replace '^.*\(| .+$|,') / 1GB, 4)
        Licenses                        = @(($users).Licenses.AccountSku.SkuPartNumber) -ne "" -join "|"
        ProhibitSendQuota               = $CurMbx.ProhibitSendQuota
        IssueWarningQuota               = $CurMbx.IssueWarningQuota
        ProhibitSendReceiveQuota        = $CurMbx.ProhibitSendReceiveQuota
        ArchiveQuota                    = $CurMbx.ArchiveQuota
        ArchiveWarningQuota             = $CurMbx.ArchiveWarningQuota
        MailboxPlan                     = $CurMbx.MailboxPlan
        MailboxPlanProhibitSendQuota    = $mbxPlanStats.ProhibitSendQuota
        MailboxPlanIssueWarningQuota    = $mbxPlanStats.IssueWarningQuota
        MailboxProhibitSendReceiveQuota = $mbxPlanStats.ProhibitSendReceiveQuota
      }
    }
  }
  else {
    $mbxs = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -ne "DiscoveryMailbox" }
    foreach ($CurMbx in $mbxs) {
      $users = Get-MsolUser -UserPrincipalName $CurMbx.UserPrincipalName
      $mbxStats = Get-MailboxStatistics -Identity $CurMbx.PrimarySmtpAddress
      $mbxPlanStats = Get-MailboxPlan -Identity $CurMbx.MailboxPlan
      [PSCustomObject]@{
        DisplayName                     = $CurMbx.DisplayName
        PrimarySmtpAddress              = $CurMbx.PrimarySmtpAddress
        RecipientTypeDetails            = $CurMbx.RecipientTypeDetails
        IsDirSynced                     = $CurMbx.IsDirSynced
        IsLicensed                      = $users.IsLicensed
        IsArchiveEnabled                = $mbxStats.IsArchiveMailbox
        MailboxSizeGB                   = [Math]::Round([Double]($mbxStats.TotalItemSize -replace '^.*\(| .+$|,') / 1GB, 4)
        Licenses                        = @(($users).Licenses.AccountSku.SkuPartNumber) -ne "" -join "|"
        ProhibitSendQuota               = $CurMbx.ProhibitSendQuota
        IssueWarningQuota               = $CurMbx.IssueWarningQuota
        ProhibitSendReceiveQuota        = $CurMbx.ProhibitSendReceiveQuota
        ArchiveQuota                    = $CurMbx.ArchiveQuota
        ArchiveWarningQuota             = $CurMbx.ArchiveWarningQuota
        MailboxPlan                     = $CurMbx.MailboxPlan
        MailboxPlanProhibitSendQuota    = $mbxPlanStats.ProhibitSendQuota
        MailboxPlanIssueWarningQuota    = $mbxPlanStats.IssueWarningQuota
        MailboxProhibitSendReceiveQuota = $mbxPlanStats.ProhibitSendReceiveQuota
      }
    }
  }
}

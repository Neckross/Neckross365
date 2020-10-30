function Set-MailboxMoveTimeZoneAndLanguage {
  <#
    .SYNOPSIS
    Set Mailbox TimeZone and Language

    .DESCRIPTION
    Set Mailbox TimeZone and Language. Defaults to EST and en-US

    .EXAMPLE
    Set-MailboxMoveTimeZoneAndLanguage | Out-GridView

    .EXAMPLE
    Set-MailboxMoveTimeZoneAndLanguage -TimeZone 'Eastern Standard Time' | Out-GridView

    .EXAMPLE
    Set-MailboxMoveTimeZoneAndLanguage -MailboxList (Get-Mailbox -RecipientTypeDetails UserMailbox)

    .NOTES
    General notes
    #>

  param (
    [Parameter()]
    $TimeZone,

    [Parameter()]
    $Language = "en-US"
  )

  $MailboxList = Get-Mailbox -ResultSize Unlimited
  foreach ($Mailbox in $MailboxList) {
    $BeforeChange = Get-MailboxRegionalConfiguration -Identity $Mailbox.PrimarySmtpAddress
    if ($BeforeChange.TimeZone -ne $TimeZone) {
      Set-MailboxRegionalConfiguration -Identity $Mailbox.PrimarySmtpAddress -TimeZone $TimeZone -Language $Language
    }
  }
}
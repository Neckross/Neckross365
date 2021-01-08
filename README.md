# Neckross365
Module was created for Intune Windows 10 Autopilot and Office 365 management (its a work-in-progress).

SHOUT OUT to [Kevin Blumenfeld](https://github.com/kevinblumenfeld)

 [![](https://img.shields.io/powershellgallery/v/Neckross365.svg)](https://www.powershellgallery.com/packages/Neckross365) [![](https://img.shields.io/powershellgallery/dt/Neckross365.svg)](https://www.powershellgallery.com/packages/Neckross365)

###### Install
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy RemoteSigned
Install-Module Neckross365 -Force
Import-Module Neckross365 -Force
```

###### Update
```powershell
Install-Module Neckross365 -Force
Import-Module Neckross365 -Force
```

###### Install without admin access
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Install-Module Neckross365 -Force -Scope CurrentUser
Import-Module Neckross365 -Force -Scope CurrentUser
```

### Windows 10 Autopilot
* **Get-Windows10Hash** Collects Windows 10 hashes and export to CSV.
* **Get-Windows10HashUploadToIntune** Collects Windows 10 hashes and uploads to Intune.
* **Get-Windows10HashBULKUploadToAzure** Collects Windows 10 hashes and uploads to Azure Blob (needs additional Blob configuration)
* **Get-Windows10HashBULKDownloadFromAzureUploadToIntune** Download Windows 10 hashes from Azure Blob, combine them into single CSV and uploads to Intune.


### Office 365 Management
* **Get-MobileDevicesReport** Generates mobile devices report for Exchange Online.
* **Get-MfaUserReport** Generates MSOL users MFA report.
* **Set-MfaState** Converts an MFA user to user Azure AD Conditional Access MFA.
* **Get-NewBatches** It collects a NewBatches csv file to update existing Batches excel sheet.
* **Get-MailboxBrokenEAP** Captures users missing the Office 365 tenant proxy address.
* **Set-MailboxBrokenEAP** Applies to users the the Office 365 tenant proxy address.
* **Get-EAPrecipientReport** Reports Email Address Policy assigned to a recipient.
* **Get-MsolUserGroupLicenseErrorsReport** Capture all users with group-based licensing errors.
* **Get-CASMailboxProtocols** Reports ALL CAS Mailboxes protocols state.
* **Enable-CASMailboxProtocols** Force enable ALL CAS mailboxes protocols to TRUE.
* **Disable-CASMailboxProtocols** Force disable ALL CAS mailboxes protocols to FALSE.
* **Get-OnpremSipUsers** Captures Onprem AD users with an existing SIP address.
* **Get-CloudSipUsers** Captures Cloud Msol users with an existing SIP address.
* **Get-MailboxQuotaReport** Reports on EXO mailbox size quota limits for ALL or single mailbox.
* **Get-MailboxReport** Captures a report of On-prem Mailboxes.
* **Get-DistributionGroupReport** Captures a report of On-prem Distribution Groups.
* **Get-DistributionGroupMemberReport** Captures a report of On-prem Distribution Groups Members and Owners.
* **Get-O365SoftDeletedAccounts** Captures and output an Excel report on ALL Office 365 deleted accounts.

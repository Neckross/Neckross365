# Neckross365
 [![](https://img.shields.io/powershellgallery/v/Neckross365.svg)](https://www.powershellgallery.com/packages/Neckross365) [![](https://img.shields.io/powershellgallery/dt/Neckross365.svg)](https://www.powershellgallery.com/packages/Neckross365)


Module was created for Microsoft 365 tools (Office 365, Intune, Autopilot and Windows 365) and Exchange On-prem management (its a work-in-progress)..

SHOUT OUT to [Kevin Blumenfeld](https://github.com/kevinblumenfeld)


###### Install
```powershell
Set-ExecutionPolicy RemoteSigned
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
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
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Install-Module Neckross365 -Force -Scope CurrentUser
Import-Module Neckross365 -Force
```

### Intune Windows 10 Autopilot
* **Get-Windows10Hash** Collects Windows 10 hashes and export to CSV.
* **Get-Windows10HashUploadToIntune** Collects Windows 10 hashes and uploads to Intune.
* **Get-Windows10HashBULKUploadToAzure** Collects Windows 10 hashes and uploads to Azure Blob (needs additional Blob configuration)
* **Get-Windows10HashBULKDownloadFromAzureUploadToIntune** Download Windows 10 hashes from Azure Blob, combine them into single CSV and uploads to Intune.


### Office 365 Management
* **Get-MobileDevicesReport** Generates mobile devices report for Exchange Online.
* **Get-MfaUserReport** Generates MSOL users MFA report.
* **Set-MfaState** Converts an MFA user to user Azure AD Conditional Access MFA.
* **Get-MsolUserGroupLicenseErrorsReport** Capture all MSOL users with group-based licensing errors.
* **Get-CloudSipUsers** Captures cloud MSOL users with an existing SIP address.
* **Get-MailboxQuotaReport** Reports on cloud EXO mailbox size quota limits for ALL or single mailbox.
* **Get-O365SoftDeletedAccounts** Captures and output an Excel report on ALL Office 365 deleted accounts.


### On-Prem Management
* **Get-NewBatches** It collects a NewBatches csv file to update existing Batches excel sheet.
* **Get-MailboxBrokenEAP** Captures on-prem users missing the Office 365 tenant proxy address.
* **Set-MailboxBrokenEAP** Applies on-prem users the the Office 365 tenant proxy address.
* **Get-EAPrecipientReport** Reports on-prem users EmailAddressPolicy assigned to a recipient.
* **Get-CASMailboxProtocols** Reports ALL on-prem CAS Mailboxes protocols state.
* **Enable-CASMailboxProtocols** Force enable ALL on-prem CAS mailboxes protocols to TRUE.
* **Disable-CASMailboxProtocols** Force disable ALL onp-prem CAS mailboxes protocols to FALSE.
* **Get-OnpremSipUsers** Captures on-prem AD users with an existing SIP address.
* **Get-MailboxReport** Captures a report of on-prem Mailboxes.
* **Get-DistributionGroupReport** Captures a report of on-prem Distribution Groups.
* **Get-DistributionGroupMemberReport** Captures a report of on-prem Distribution Groups Members and Owners.


### Windows 365 Cloud PC
* **Get-Windows365UserLogonActivity** It captures the logon activity of a Windows 365 user from a Cloud PC.

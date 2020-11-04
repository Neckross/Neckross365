# Neckross365
Module was created for Intune PC management and Windows 10 Autopilot (its a work-in-progress).


Huge SHOUT OUT to **Kevin Blumenfeld** https://github.com/kevinblumenfeld.
None of this would it have been possible without him.


Thank you https://gist.github.com/okieselbach (I used some of your code for Autopilot)


## How to install
```
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Install-Module Neckross365 -Force
```

## Install without admin access
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Install-Module Neckross365 -Force -Scope CurrentUser
```

### Windows 10 Autopilot Hashes
* **Get-Windows10Hash** Collects Windows 10 hashes and export to CSV.
* **Get-Windows10HashUploadToIntune** Collects Windows 10 hashes and uploads to Intune.
* **Get-Windows10HashBULKUploadToAzure** Collects Windows 10 hashes and uploads to Azure Blob (needs additional Blob configuration)
* **Get-Windows10HashBULKDownloadFromAzureUploadToIntune** Download Windows 10 hashes from Azure Blob, combine them into single CSV and uploads to Intune.
* **Get-MobileDevicesReport** Generates mobile devices report for Exchange Online.
* **Get-MfaUserReport** Generates MSOL users MFA report.
* **Set-MfaState** Converts an MFA user to user Azure AD Conditional Access MFA.
* **Get-NewBatches** It collects a NewBatches csv file to update existing Batches excel sheet.
* **Get-MailboxBrokenEAP** Captures users missing the Office 365 tenant proxy address.
* **Set-MailboxBrokenEAP** Applies to users the the Office 365 tenant proxy address.
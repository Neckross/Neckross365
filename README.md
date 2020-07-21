
# Neckross365
SHOUT OUT to Kevin Blumenfeld https://github.com/kevinblumenfeld.

None of this would it have been possible without him... the guy its an open-book.


Module was created for Intune PC and Windows 10 management (its a work-in-progress).

All feedback is welcome.

## Prerequisite when TLS1.2 is not enforced
If you receive an error attempting to installing the module. Run this and try again.
```
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
```

## How to install
```
Install-Module Neckross365 -Force
```

## Install without admin access
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Install-Module Neckross365 -Force -Scope CurrentUser
```

### Windows 10 Hashes
* **Get-Windows10Hash** Collects Windows 10 hashes and export to CSV.
* **Get-Windows10HashUploadToIntune** Collects Windows 10 hashes and uploads to Intune.
* **Get-Windows10HashUploadToAzure** Collects Windows 10 hashes and uploads to Azure Blob (needs additional Blob configuration)
* **Get-Windows10HashDownloadFromAzureUploadToIntune** Download Windows 10 hashes from Azure Blob, combine them into single CSV and uploads to Intune.

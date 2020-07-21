REM [REQUIREMENTS]

REM Place the batch file under C:\Scripts (ex. C:\Scripts\Get-Windows10HashUploadToAzure_batchfile.cmd)

REM Define the values below:
REM BlobContainerUrl = Storage Account Blob URL
REM BlobContainerResources = Blob Container name for the resources
REM BlobContainerHashes = Blob Container name for the Windows 10 hashes
REM BlobKey = Blob Storage Account Key
powershell.exe -ExecutionPolicy Bypass -Command ". C:\Scripts\Get-Windows10HashUploadToAzure.ps1 ; Get-Windows10HashUploadToAzure -BlobContainerUrl 'https://autopilothashes.blob.core.windows.net' -BlobContainerResources 'resources' -BlobContainerHashes 'windows10hashes' -BlobKey 'KtpGF+Nk4dRMCxQS3G1vwG0lDqUfJfxC9kUlfzML74WUQ=='"
REM Completed running batch file
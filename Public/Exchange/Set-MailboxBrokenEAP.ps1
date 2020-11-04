function Set-MailboxBrokenEAP {
  <#
  .SYNOPSIS
  Will add the missing Office 365 proxy address from CSV file
  (tenant.mail.onmicrosoft.com)

  .DESCRIPTION
  You need to capture first users missing the O365 proxy address
  Run first function Get-MailboxBrokenEAP

  .EXAMPLE
  Set-MailboxBrokenEAP -O365TenantProxy "newportgroupinc.mail.onmicrosoft.com" -CsvFile "C:\Scripts\GetMailboxBrokenEAP.csv" | Out-GridView -Title "List of users ADDED Office365 Tenant proxyaddress"

  .NOTES
  General notes
  #>

  param (
    [Parameter(Mandatory)]
    $O365TenantProxy,
    [Parameter(Mandatory)]
    $CsvFile
  )

  $csv = Import-Csv -Path $CsvFile
  foreach ($CurCsv in $csv) {
    $targetAddress = "smtp:" + $CurCsv.NEWAlias + "@" + $O365TenantProxy
    try {
      Set-Mailbox -Identity $CurCsv.PrimarySmtpAddress -EmailAddressPolicyEnabled $false -Alias $CurCsv.NEWAlias -EmailAddresses @{add = $targetAddress } -ErrorAction Stop
      [PSCustomObject]@{
        DisplayName        = $CurCsv.DisplayName
        UserPrincipalName  = $CurCsv.UserPrincipalName
        PrimarySmtpAddress = $CurCsv.PrimarySmtpAddress
        Alias              = $CurCsv.Alias
        NEWAlias           = $CurCsv.NEWAlias
        SamAccountName     = $CurCsv.SamAccountName
        Result             = 'SUCCESS'
        Log                = 'SUCCESS'
      }
    }
    catch {
      [PSCustomObject]@{
        DisplayName        = $CurCsv.DisplayName
        UserPrincipalName  = $CurCsv.UserPrincipalName
        PrimarySmtpAddress = $CurCsv.PrimarySmtpAddress
        Alias              = $CurCsv.Alias
        Result             = 'FAILED'
        Log                = "$($_.Exception.Message)"
      }
    }
  }
}
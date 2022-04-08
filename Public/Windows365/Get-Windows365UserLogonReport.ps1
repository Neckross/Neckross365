function Get-Windows365UserLogonReport {

  <#
  .SYNOPSIS
  Capture Windows 365 user logon activity for their Cloud PCs
  Reference: https://github.com/microsoft/Windows365-PSScripts

  .DESCRIPTION
  Capture Windows 365 user logon activity for their Cloud PCs

  .EXAMPLE
  Get-Windows365UserLogonReport -LogonDays 30 -CsvFile C:\Report.csv

  .NOTES
  General notes
  #>

  param (
    [Parameter(Mandatory)]
    $CsvFile,

    [Parameter(Mandatory)]
    $LogonDays
  )

  # Requirements (Modules)
  $module1 = Find-Module -Name Microsoft.Graph -ErrorAction Ignore
  if (-not $module1) {
    Write-Host "Installing module Microsoft.Graph"
    Install-Module Microsoft.Graph -Force
  }

  $module2 = Find-Module -Name AzureADPreview -ErrorAction Ignore
  if (-not $module2) {
    Write-Host "Installing module AzureADPreview"
    Install-Module AzureADPreview -AllowClobber -Force
  }

  # Connect to Microsoft.Graph/AzureADPreview
  AzureADPreview\Connect-AzureAD
  $AAD = Get-AzureADTenantDetail
  Write-Host -ForegroundColor Yellow "Connected to AzureADPreview tenant $($AAD.ObjectId)"
  Connect-MgGraph -Scopes "CloudPC.Read.All"
  Select-MgProfile -Name "beta"
  $Graph = Get-MGContext
  Write-Host -ForegroundColor Yellow "Connected to Microsoft.Graph tenant $($Graph.TenantId)"

  # Script: Capture AzureAD Logins from CloudPCs
  $adjdate = (Get-Date).AddDays( - $($LogonDays))
  $string = "$($adjdate.Year)" + "-" + "$($adjdate.Month)" + "-" + "$($adjdate.Day)"
  $CloudPCs = Get-MgDeviceManagementVirtualEndpointCloudPC
  $WebLogons = Get-AzureADAuditSignInLogs -Filter "appdisplayname eq 'Windows 365 Portal' and createdDateTime gt $string"
  $ClientLogons = Get-AzureADAuditSignInLogs -Filter "appdisplayname eq 'Azure Virtual Desktop Client' and createdDateTime gt $string"

  # Script: Get all users assigned to a cloud pc
  $users = @()
  foreach ($CloudPC in $CloudPCs) {
    $users += $CloudPC.UserPrincipalName
    $UPN = $users
  }

  # Script: Build the output to CSV
  foreach ($user in $users) {
    $output = [PSCustomObject]@{
      "CPCUserPrincipalName" = "$UPN"
      "CPCManagedDeviceName" = ""
      "LastLogon"            = ""
      "TotalLogons"          = ""
      "WebLogons"            = ""
      "ClientLogons"         = ""
      "TotalDays"            = "$LogonDays"
    }

    $countweb = $null
    $countclient = $null
    $LastLogon = $null

    #Finds the name of the cloudPC the user has
    foreach ($CloudPC in $cloudPCs) {
      if ($CloudPC.UserPrincipalName -eq $user) {
        $output.CPCManagedDeviceName = $CloudPC.ManagedDeviceName
      }
    }

    #Counts each web logon
    foreach ($WebLogon in $WebLogons) {
      if ($WebLogon.UserPrincipalName -eq $user) {
        $countweb = $countweb + 1
        if ($Weblogon.CreatedDateTime -gt $LastLogon) { $LastLogon = $WebLogon.CreatedDateTime }
      }
    }
    if ($countweb -eq $null) { $countweb = 0 }

    #Counts each local client logon
    foreach ($ClientLogon in $ClientLogons) {
      if ($ClientLogon.UserPrincipalName -eq $user) {
        $countclient = $countclient + 1
        if ($Clientlogon.CreatedDateTime -gt $LastLogon) { $LastLogon = $LastLogon.CreatedDateTime }
      }
    }
    if ($countclient -eq $null) { $countclient = 0 }

    #adds both logon counts for a total
    $total = $countweb + $countclient
    $output.TotalLogons = $total

    #outputs web client logon count
    $output.WebLogons = $countweb

    #outputs local client logon count
    $output.ClientLogons = $countclient

    #outputs the last logon time
    $output.LastLogon = $LastLogon

    #outputs notification if no logon activity has been recorded
    if ($total -eq 0) { Write-Host "User has not logged in." -ForegroundColor Red }

    #sends data to CSV file
    $output | Export-Csv -Path $CsvFile -NoTypeInformation -Append
    Write-Host -ForegroundColor Yellow "File was exported to $CsvFile"
  }
}
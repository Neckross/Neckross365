function Get-Windows365UserLogonActivity {

  <#
  .SYNOPSIS
  Capture Windows 365 user logon activity for their Cloud PCs

  .DESCRIPTION
  Capture Windows 365 user logon activity for their Cloud PCs

  .EXAMPLE
  Get-Windows365UserLogonActivity -LogonDays 30 | Out-GridView

  .NOTES
  General notes
  #>

  param (
    [Parameter(Mandatory)]
    $LogonDays
  )

  # Requirements (Modules)
  $module1 = Import-Module Microsoft.Graph -PassThru -ErrorAction Ignore
  if (-not $module1) {
    Write-Host "Installing module Microsoft.Graph"
    Install-Module Microsoft.Graph -AllowClobber -Force
  }
  Import-Module Microsoft.Graph -Scope Global

  $module2 = Import-Module AzureADPreview -PassThru -ErrorAction Ignore
  if (-not $module2) {
    Write-Host "Installing module AzureADPreview"
    Install-Module AzureADPreview -AllowClobber -Force
  }
  Import-Module AzureADPreview -Scope Global

  # Connect to Microsoft.Graph/AzureADPreview
  AzureADPreview\Connect-AzureAD
  $AADtenant = Get-AzureADTenantDetail
  Write-Host -ForegroundColor Yellow "Connected to AzureADPreview tenant $($AADtenant.ObjectId)"
  $graph = Connect-MgGraph -Scopes "CloudPC.Read.All"
  Select-MgProfile -Name "beta"
  Write-Host -ForegroundColor Yellow "Connected to Microsoft.Graph tenant $($graph.TenantId)"

  # Script: Capture AzureAD Logins from CloudPCs
  $adjdate = (get-date).AddDays( - $($offset))
  $string = "$($adjdate.Year)" + "-" + "$($adjdate.Month)" + "-" + "$($adjdate.Day)"
  $cloudPCs = Get-MgDeviceManagementVirtualEndpointCloudPC
  $WebLogons = Get-AzureADAuditSignInLogs -Filter "appdisplayname eq 'Windows 365 Portal' and createdDateTime gt $string"
  $ClientLogons = Get-AzureADAuditSignInLogs -Filter "appdisplayname eq 'Azure Virtual Desktop Client' and createdDateTime gt $string"

  # Script: Get all users assigned to a cloud pc
  $users = @()
  foreach ($CloudPC in $CloudPCs) {
    $users += $CloudPC.UserPrincipalName
  }

  # Script: Build the output to CSV
  foreach ($user in $users) {
    $output = [PSCustomObject]@{
      "CPCUserPrincipalName" = ""
      "CPCManagedDeviceName" = ""
      "LastLogon"            = ""
      "TotalLogons"          = ""
      "WebLogons"            = ""
      "ClientLogons"         = ""
      "TotalDays"            = "$offset"
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
    if ($total -eq 0) { write-host "User has not logged in." -ForegroundColor Red }
  }
}
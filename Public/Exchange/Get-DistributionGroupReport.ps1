function Get-DistributionGroupReport {
  <#
  .SYNOPSIS
  Capture Distribution Groups Report

  .DESCRIPTION
  Capture Distribution Groups Report
  It can capture all groups or from a CSV file (PrimarySmtpAddress needed)

  .EXAMPLE
  Get-DistributionGroupReport | Out-GridView

  .EXAMPLE
  Get-DistributionGroupReport -CsvFile C:\Scripts\file.csv | Out-GridView

  .NOTES
  General notes
  #>

  [CmdletBinding(DefaultParameterSetName = 'Placeholder')]
  param
  (
    [Parameter(ParameterSetName = "CsvFile")]
    $CsvFile
  )

  if ($CsvFile) {
    $csv = Import-Csv -Path $CsvFile
    foreach ($CurCsv in $csv) {
      $groups = Get-DistributionGroup -ResultSize Unlimited -Identity $CurCsv.PrimarySmtpAddress
      [PSCustomObject]@{
        Name                      = $groups.Name
        DisplayName               = $groups.DisplayName
        PrimarySmtpAddress        = $groups.PrimarySmtpAddress
        GroupType                 = $groups.GroupType
        Alias                     = $groups.Alias
        SamAccountName            = $groups.SamAccountName
        EmailAddressPolicyEnabled = $groups.EmailAddressPolicyEnabled
        HiddenFromGAL             = $groups.HiddenFromAddressListsEnabled
        RequireSenderAuth         = $groups.RequireSenderAuthenticationEnabled
        ModerationEnabled         = $groups.ModerationEnabled
        Guid                      = $groups.Guid
        O365TenantProxy           = @($groups.EmailAddresses) -like "*mail.onmicrosoft.com" -join "|"
        EmailAddresses            = @($groups.EmailAddresses) -ne '' -join '|'
      }
    }
  }
  else {
    $groups = Get-DistributionGroup -ResultSize Unlimited
    foreach ($CurGroup in $groups) {
      [PSCustomObject]@{
        Name                      = $CurGroup.Name
        DisplayName               = $CurGroup.DisplayName
        PrimarySmtpAddress        = $CurGroup.PrimarySmtpAddress
        GroupType                 = $CurGroup.GroupType
        Alias                     = $CurGroup.Alias
        SamAccountName            = $CurGroup.SamAccountName
        EmailAddressPolicyEnabled = $CurGroup.EmailAddressPolicyEnabled
        HiddenFromGAL             = $CurGroup.HiddenFromAddressListsEnabled
        RequireSenderAuth         = $CurGroup.RequireSenderAuthenticationEnabled
        ModerationEnabled         = $CurGroup.ModerationEnabled
        Guid                      = $CurGroup.Guid
        O365TenantProxy           = @($CurGroup.EmailAddresses) -like "*mail.onmicrosoft.com" -join "|"
        EmailAddresses            = @($CurGroup.EmailAddresses) -ne '' -join '|'
      }
    }
  }
}

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
          OrganizationalUnit        = $CurGroup.OrganizationalUnit
          RequireSenderAuth         = $CurGroup.RequireSenderAuthenticationEnabled
          ModerationEnabled         = $CurGroup.ModerationEnabled
          Guid                      = $CurGroup.Guid
          LegacyExchangeDN          = $CurGroup.LegacyExchangeDN
          O365TenantProxy           = @($CurGroup.EmailAddresses) -like "*mail.onmicrosoft.com" -join "|"
          EmailAddresses            = @($CurGroup.EmailAddresses) -ne '' -join '|'
        }
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
        OrganizationalUnit        = $CurGroup.OrganizationalUnit
        RequireSenderAuth         = $CurGroup.RequireSenderAuthenticationEnabled
        ModerationEnabled         = $CurGroup.ModerationEnabled
        Guid                      = $CurGroup.Guid
        LegacyExchangeDN          = $CurGroup.LegacyExchangeDN
        O365TenantProxy           = @($CurGroup.EmailAddresses) -like "*mail.onmicrosoft.com" -join "|"
        EmailAddresses            = @($CurGroup.EmailAddresses) -ne '' -join '|'
      }
    }
  }
}

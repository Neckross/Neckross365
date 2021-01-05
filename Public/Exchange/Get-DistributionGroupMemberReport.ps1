function Get-DistributionGroupMemberReport {
  <#
  .SYNOPSIS
  Capture Distribution Groups Members Report

  .DESCRIPTION
  Capture Distribution Groups Members Report
  It can capture all group members or from a CSV file (PrimarySmtpAddress needed)

  .EXAMPLE
  Get-DistributionGroupMemberReport | Out-GridView

  .EXAMPLE
  Get-DistributionGroupMemberReport -CsvFile C:\Scripts\file.csv | Out-GridView

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
      $members = Get-DistributionGroupMember -Identity $CurCsv.PrimarySmtpAddress
      foreach ($CurMember in $members) {
        [PSCustomObject]@{
          GroupName   = $groups.DisplayName
          GroupEmail  = $groups.PrimarySmtpAddress
          GroupType   = $groups.GroupType
          MemberName  = @($members.DisplayName) -ne '' -join '|'
          MemberEmail = @($members.PrimarySmtpAddress) -ne '' -join '|'
          MemrberType = @($members.RecipientTypeDetails) -ne '' -join '|'
          GroupOwners = @($groups.ManagedBy) -ne '' -join '|'
        }
      }
    }
  }
  else {
    $groups = Get-DistributionGroup -ResultSize Unlimited
    foreach ($CurGroup in $groups) {
      $members = Get-DistributionGroupMember -ResultSize Unlimited -Identity $CurGroup.PrimarySmtpAddress
      foreach ($CurMember in $members) {
        [PSCustomObject]@{
          GroupName   = $CurGroup.DisplayName
          GroupEmail  = $CurGroup.PrimarySmtpAddress
          GroupType   = $CurGroup.GroupType
          MemberName  = @($members.DisplayName) -ne '' -join '|'
          MemberEmail = @($members.PrimarySmtpAddress) -ne '' -join '|'
          MemrberType = @($members.RecipientTypeDetails) -ne '' -join '|'
          GroupOwners = @($CurGroup.ManagedBy) -ne '' -join '|'
        }
      }
    }
  }
}

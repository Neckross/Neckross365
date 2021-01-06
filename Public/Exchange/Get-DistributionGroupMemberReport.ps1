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
      $RecipientHash = Get-RecipientCNHash
      foreach ($CurGroup in $groups) {
        $members = Get-DistributionGroupMember -ResultSize Unlimited -Identity $CurGroup.Guid.toString()
        $ownerList = [System.Collections.Generic.List[string]]::New()
        if ($CurGroup.ManagedBy) {
          @($CurGroup.ManagedBy).ForEach{ $ownerList.Add($RecipientHash[$_]) }
        }
        $ManagedBy = if ($ownerList) {
          @($ownerList) -ne '' -join '|'
        }
        else { '' }
        foreach ($CurMember in $members) {
          [PSCustomObject]@{
            GroupName   = $CurGroup.DisplayName
            GroupEmail  = $CurGroup.PrimarySmtpAddress
            GroupType   = $CurGroup.GroupType
            MemberName  = $CurMember.DisplayName
            MemberEmail = $CurMember.PrimarySmtpAddress
            MemrberType = $CurMember.RecipientTypeDetails
            GroupOwners = $ManagedBy
          }
        }
      }
    }
  }
  else {
    $groups = Get-DistributionGroup -ResultSize Unlimited
    $RecipientHash = Get-RecipientCNHash
    foreach ($CurGroup in $groups) {
      $members = Get-DistributionGroupMember -ResultSize Unlimited -Identity $CurGroup.Guid.toString()
      $ownerList = [System.Collections.Generic.List[string]]::New()
      if ($CurGroup.ManagedBy) {
        @($CurGroup.ManagedBy).ForEach{ $ownerList.Add($RecipientHash[$_]) }
      }
      $ManagedBy = if ($ownerList) {
        @($ownerList) -ne '' -join '|'
      }
      else { '' }
      foreach ($CurMember in $members) {
        [PSCustomObject]@{
          GroupName   = $CurGroup.DisplayName
          GroupEmail  = $CurGroup.PrimarySmtpAddress
          GroupType   = $CurGroup.GroupType
          MemberName  = $CurMember.DisplayName
          MemberEmail = $CurMember.PrimarySmtpAddress
          MemrberType = $CurMember.RecipientTypeDetails
          GroupOwners = $ManagedBy
        }
      }
    }
  }
}

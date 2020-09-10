function Get-MobileDevicesReport {
  <#
  .SYNOPSIS
  Get Exchange 2013/2016 On-premise EAS mobile devices report

  .DESCRIPTION
  This is for Exchange 2010 (ActiveSync) for EX13/EX16/EXO is (MobileDevice)

  .EXAMPLE
  Get-MobileDevicesReport | Export-Csv -Path C:\Scripts\MobileDevicesReport.csv -nti

  .NOTES
  General notes
  #>

  $Mobile = Get-MobileDevice -ResultSize unlimited
  foreach ($CurMobile in $Mobile) {
    $Stat = Get-MobileDeviceStatistics -Identity "$($CurMobile.Guid)"
    [PSCustomObject]@{
      UserDisplayName       = $CurMobile.UserDisplayName
      FriendlyName          = $CurMobile.FriendlyName
      LastSuccessSync       = $Stat.LastSuccessSync
      ClientType            = $CurMobile.ClientType
      DeviceModel           = $CurMobile.DeviceModel
      DeviceType            = $CurMobile.DeviceType
      ClientVersion         = $CurMobile.ClientVersion
      DeviceId              = $CurMobile.DeviceId
      DeviceMobileOperator  = $CurMobile.DeviceMobileOperator
      DeviceOS              = $CurMobile.DeviceOS
      DeviceTelephoneNumber = $CurMobile.DeviceTelephoneNumber
      Device                = $Stat.DeviceType
      FirstSyncTime         = $CurMobile.FirstSyncTime
      LastSyncAttemptTime   = $Stat.LastSyncAttemptTime
      FoldersSynced         = $Stat.NumberOfFoldersSynced
      Status                = $Stat.Status
      IsRemoteWipeSupported = $Stat.IsRemoteWipeSupported
    }
  }
}
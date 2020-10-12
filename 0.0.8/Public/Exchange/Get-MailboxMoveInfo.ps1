function Get-MailboxMoveInfo {
  <#
  .SYNOPSIS
  Reports on MailboxMoves to include BadItemLimit + LargeItemLimit information

  .DESCRIPTION
  Reports on MailboxMoves to include BadItemLimit + LargeItemLimit information

  .EXAMPLE
  Get-MailboxMoveInfo -SharePointURL 'https://CoreBTS.sharepoint.com/sites/CLIENT' -ExcelFile 'Batches.xlsx'

  .NOTES
  General notes
  #>
  param (
    [Parameter(Mandatory)]
    $SharePointURL,

    [Parameter(Mandatory)]
    $ExcelFile
  )

  $ExcelFull = Import-SharePointExcel -SharePointURL $SharePointURL -ExcelFile $ExcelFile
  $BatchChoice = $ExcelFull | Select-Object -ExpandProperty BatchName -Unique | Sort-Object | Out-GridView -OutputMode Multiple -Title "Choose which BatchName"
  $ExcelList = $ExcelFull | Where-Object { $_.BatchName -in $BatchChoice }

  $ExcelHash = @{}
  foreach ($Excel in $ExcelList) {
    $ExcelHash[$Excel.DisplayName] = @{
      PrimarySmtpAddress = $Excel.PrimarySmtpAddress
      UserPrincipalName  = $Excel.UserPrincipalName
    }
  }

  $MailboxList = Get-MoveRequest -ResultSize Unlimited
  $MoveHash = @{}
  foreach ($Mailbox in $MailboxList) {
    $MoveHash[$Mailbox.DisplayName] = @{
      BatchName   = $Mailbox.BatchName
      BatchStatus = $moves.Status
    }
  }

  foreach ($ExcelItem in $ExcelHash.Keys) {
    if ($MoveHash.ContainsKey($ExcelItem)) {
      $movesStats = Get-MoveRequestStatistics -Identity $ExcelHash[$ExcelItem]['PrimarySmtpAddress']
      [PSCustomObject]@{
        DisplayName           = $ExcelItem
        Result                = 'FOUND'
        UserPrincipalName     = $ExcelHash[$ExcelItem]['UserPrincipalName']
        PrimarySmtpAddress    = $ExcelHash[$ExcelItem]['PrimarySmtpAddress']
        BatchName             = $MoveHash[$ExcelItem]['BatchName']
        BatchStatus           = $MoveHash[$ExcelItem]['BatchStatus']
        BatchPercent          = $movesStats.PercentComplete
        BadItemLimit          = $movesStats.BadItemLimit
        BadItemsEncountered   = $movesStats.BadItemsEncountered
        LargeItemLimit        = $movesStats.LargeItemLimit
        LargeItemsEncountered = $movesStats.LargeItemsEncountered
        TotalMailboxSize      = $movesStats.TotalMailboxSize
        TotalMailboxItemCount = $movesStats.TotalMailboxItemCount
      }
    }
    else {
      [PSCustomObject]@{
        DisplayName           = $ExcelItem
        Result                = 'NOTFOUND'
        UserPrincipalName     = $ExcelHash[$ExcelItem]['UserPrincipalName']
        PrimarySmtpAddress    = $ExcelHash[$ExcelItem]['PrimarySmtpAddress']
        BatchName             = ''
        BatchStatus           = ''
        BatchPercent          = ''
        BadItemLimit          = ''
        BadItemsEncountered   = ''
        LargeItemLimit        = ''
        LargeItemsEncountered = ''
        TotalMailboxSize      = ''
        TotalMailboxItemCount = ''
      }
    }
  }
}
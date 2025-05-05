$resultList = @()

$AllMailbox = Get-Mailbox -ResultSize Unlimited

foreach ($mailbox in $AllMailbox) {
    try {
        Set-Mailbox -Identity $mailbox.Alias -LitigationHoldEnabled $true -LitigationHoldDuration 30 -ErrorAction Stop

        $updated = Get-Mailbox -Identity $mailbox.Alias

        $resultList += [PSCustomObject]@{
            Alias                  = $mailbox.Alias
            Result                 = "Success"
            LitigationHoldEnabled  = $updated.LitigationHoldEnabled
            LitigationHoldDuration = $updated.LitigationHoldDuration
            ErrorMessage           = ""
        }

        Write-Host "[$($mailbox.Alias)] LitigationHold Succeed" -ForegroundColor Green
    }
    catch {
        $resultList += [PSCustomObject]@{
            Alias                  = $mailbox.Alias
            Result                 = "Failed"
            LitigationHoldEnabled  = $null
            LitigationHoldDuration = $null
            ErrorMessage           = $_.Exception.Message
        }

        Write-Host "[$($mailbox.Alias)] LitigationHold faild: $($_.Exception.Message)" -ForegroundColor Red
    }
}

$resultList | Format-Table -AutoSize

$resultList | Export-Csv -Path "LitigationHold_Result_$(Get-Date -Format yyyyMMdd_HHmmss).csv" -NoTypeInformation


# Add EMS
Add-PSSnapin *Exchange*

# Declare variables
$csvPath = "C:\Users\ServerAdmin\Desktop\PSTExport1to100.csv"
$users   = Import-Csv -Path $csvPath -Encoding UTF8

# Import CSV and Create the batch
foreach ($u in $users) {
    $mailbox = $u.Mailaddress.Trim()
    if ([string]::IsNullOrWhiteSpace($mailbox)) { continue }

    $mbxObj = Get-Mailbox -Identity $mailbox -ErrorAction SilentlyContinue
    if (-not $mbxObj) {
        Write-Warning "Mailbox is not exist: $mailbox"
        continue
    }

    New-MailboxExportRequest -Mailbox $mailbox -ContentFilter {(Received -lt $start) -and (Received -gt $end)} -FilePath "\\MAILPRDNEW\ExportPST1\$($mbxObj.UserPrincipalName).pst"
}

# status
foreach ($u in $users) {
    $mailbox = ($u.Mailaddress -as [string]).Trim()
    if ([string]::IsNullOrWhiteSpace($mailbox)) { continue }

    Get-MailboxExportRequest -Mailbox $mailbox | Get-MailboxExportRequestStatistics
}

# Remove Batch
Get-MailboxExportRequest | Remove-MailboxExportRequest -Confirm:$false
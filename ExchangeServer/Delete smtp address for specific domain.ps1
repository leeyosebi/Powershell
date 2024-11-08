
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010

$boxes = get-mailbox "alias"
foreach ($box in $boxes){
    $proxy = $box.EmailAddresses
 
    foreach($email in $proxy) {
        if ($email.SmtpAddress -like "*hyundai-gmx.com") {
            Set-mailbox $box -EmailAddresses @{remove=$email.SmtpAddress}
        }
    }
}

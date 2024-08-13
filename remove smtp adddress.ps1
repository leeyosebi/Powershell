Import-Module ActiveDirectory  

$User = Get-ADUser john.smith -Properties proxyAddresses  
$User.proxyAddresses.Remove("smtp:john.smith.mx360@contoso.com")  
Set-ADUser -instance $User  

Get-ADUser -Properties proxyaddresses -Filter {ProxyAddresses -like '*mx360@contoso.com'} |
    ForEach { # Account may have more than one email address in scope so need to loop through each one
        ForEach ($proxyAddress in $_.proxyAddresses) {
            If ($proxyAddress -like '*mx360@contoso.com') {
                # Write-Host $proxyAddress
                Set-ADUser $_.SamAccountName -Remove @{ProxyAddresses=$proxyAddress}                    
            }
        }      
    }
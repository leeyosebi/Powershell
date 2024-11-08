
## All User M365User clear 
$ouPath = "OU=User,OU=SyncRoot,DC=Cookie,DC=run,DC=place"
$users = Get-ADUser -SearchBase $ouPath -Filter *
# msDS-CloudExtensionAttribute13,14

foreach ($user in $users) {
    Set-ADUser -Identity $user -Replace @{
         "msDS-CloudExtensionAttribute13" = "MEX"
         "msDS-CloudExtensionAttribute14" = "MX"
    }
    Set-ADUser -Identity $user -Clear "msDS-CloudExtensionAttribute15"
}



#### 

$LicenseUsers = Import-Csv -Encoding UTF8 C:\Temp\A.csv 
$TAllUsers = Get-ADUser -SearchBase $ouPath -Filter * -Properties *


foreach ($LicenseUser in $LicenseUsers) {
    $UserEmail = $LicenseUser.Email
    $TargetUserId = $TAllUsers | where {$_.EmailAddress -eq $UserEmail }
 
    $TargetUserId  | Set-ADUser  -Replace @{
         "msDS-CloudExtensionAttribute13" = "MEX"
         "msDS-CloudExtensionAttribute14" = "MX"
         "msDS-CloudExtensionAttribute15" = "M365User"
    }   
}

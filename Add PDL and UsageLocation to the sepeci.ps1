#Add PDL and UsageLocation to the sepecific UPN

$users = Get-MsolUser | where-object{$_.UserPrincipalName -like '*@glovis.com.tr'}

foreach ($user in $users) {
    Set-MsolUser -UserPrincipalName $user.UserPrincipalName -PreferredDatalocation TUR
}

# Set the usage location for the same users
foreach ($user in $users) {
    Set-MsolUser -UserPrincipalName $user.UserPrincipalName -UsageLocation TR
}

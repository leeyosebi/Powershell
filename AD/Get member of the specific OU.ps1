#User
$OUpath = 'ou=Managers,dc=enterprise,dc=com'
$ExportPath = 'c:\data\users_in_ou1.csv'
Get-ADUser -Filter * -SearchBase $OUpath | Select-object DistinguishedName,Name,UserPrincipalName | Export-Csv -NoType $ExportPath

#Device
$OUpath = 'ou=Managers,dc=enterprise,dc=com'
$ExportPath = 'c:\data\users_in_ou1.csv'
Get-ADComputer -Filter * -SearchBase $OUpath | Select-object DistinguishedName,Name,UserPrincipalName | Export-Csv -NoType $ExportPath
Import-Module ActiveDirectory

$AllUsers = Get-ADUser -filter {cn -like "*"} -Properties *
$AllUsers | select displayname,UserPrincipalName,EmailAddress | export-csv -Encoding UTF8 C:\users\temp.o365\desktop\glosistUser.csv 
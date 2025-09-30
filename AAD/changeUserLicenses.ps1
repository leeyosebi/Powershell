Install-Module -name MgGraph -Force
Connect-MgGraph -Scopes User.Read.All

$users = Get-mguser -all
$userlicense = foreach ($user in $users){ Get-MgUserLicenseDetail -UserId $user.id}
$E5users = $userlicense | Where-Object {$_.skupartnumber -eq "Microsoft_365_E5_(no_Teams)"}
$E5users | foreach ($user in $E5users) { Set-MgUserLicense -UserId $user.Id -AddLicenses @($Skuid1) -RemoveLicenses @($Skuid2) }
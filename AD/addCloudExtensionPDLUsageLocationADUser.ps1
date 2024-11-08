# 특정 OU에 속한 모든 사용자를 가져옵니다.
$ouPath = "OU=test,DC=dytpq,DC=com"
$users = Get-ADUser -SearchBase $ouPath -Filter *

# 각 사용자의 msDS-CloudExtensionAttribute13,14 값을 설정합니다.
foreach ($user in $users) {
    Set-ADUser -Identity $user -Replace @{
        "msDS-CloudExtensionAttribute13" = "TUR";
        "msDS-CloudExtensionAttribute14" = "TR"
    }
}

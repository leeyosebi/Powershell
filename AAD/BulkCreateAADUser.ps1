Connect-MsolService

$csvFilePath = "C:\Users\admin\desktop\file.csv"

# CSV 파일 읽기
$userList = Import-Csv $csvFilePath

# 각 사용자에 대해 루프 실행
foreach ($user in $userList) {
    # 사용자 정보 설정
    $userPrincipalName = $user.UserPrincipalName
    $displayName = $user.DisplayName
    $surname = $user.surname
    $givenName = $user.givenName
    $password = $user.Password
    $userType = "Member" 

    # 사용자 생성
    New-MsolUser -UserPrincipalName $userPrincipalName -DisplayName $displayName -LastName $surname -FirstName $givenName -Password $password -UserType $userType


    Write-Host "User $userPrincipalName created."
}

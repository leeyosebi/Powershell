# Tenant 에서 로그인 계정의 UPN 도메인을 tenantname.onmicrosoft.com 으로 변경
Connect-AzureAD
$tenantUsers = Get-AzureADUser -All $true | Where-Object {$_.UserPrincipalName -like "*@customdomain"}
$tenantUsers | foreach {$newUpn = $_.UserPrincipalName.Replace("customdomain","tenantname.onmicrosoft.com"); $_ | Set-AzureADUser -UserPrincipalName $newUpn}

#Tenant 에서 MailUser 계정의 PrimarySmtpAddress 를 tenantname.onmicrosoft.com 으로 변경
Connect-ExchangeOnline
$tenantMailUsers = Get-MailUser -ResultSize Unlimited | Where-Object {$_.PrimarySmtpAddress -like "*@customdomain"}
$tenantMailUsers | foreach {$newSMTP = $_.PrimarySmtpAddress.Replace("customdomain","tenantname.onmicrosoft.com"); $_ | Set-MailUser -PrimarySmtpAddress $newSMTP}

#Tenant 에서 MailUser 계정의 smtp:customdomain 삭제
Connect-ExchangeOnline
# 대상자 확인용 : $tenantMailUsers = Get-MailUser -ResultSize Unlimited | Select -ExpandProperty EmailAddresses | ? {$_ -like "*@customdomain"}
$tenantMailUsers = Get-MailUser -ResultSize Unlimited
foreach ($g in $tenantMailUsers) { 
Get-MailUser -Identity $g.PrimarySmtpAddress | Select -ExpandProperty EmailAddresses | ? {$_ -like "*@customdomain"} | % {Set-MailUser -Identity $g.PrimarySmtpAddress -EmailAddresses @{remove="$_"}}
}

#Tenant 에서 MailBox 계정의 PrimarySmtpAddress 를 tenantname.onmicrosoft.com 으로 변경
Connect-ExchangeOnline
$tenantMailBoxes = Get-MailBox -ResultSize Unlimited | Where-Object {$_.PrimarySmtpAddress -like "*@customdomain"}
$tenantMailBoxes | foreach {$newSMTP = $_.PrimarySmtpAddress.Replace("customdomain","tenantname.onmicrosoft.com"); $_ | Set-MailBox -PrimarySmtpAddress $newSMTP}

#Tenant 에서 MailBox 계정의 smtp:customdomain 삭제
Connect-ExchangeOnline
# 대상자 확인용 : $tenantMailBoxes = Get-MailBox -ResultSize Unlimited | Select -ExpandProperty EmailAddresses | ? {$_ -like "*@customdomain"}
$tenantMailBoxes = Get-MailBox -ResultSize Unlimited
foreach ($m in $tenantMailBoxes) { 
Get-MailBox -Identity $m.PrimarySmtpAddress | Select -ExpandProperty EmailAddresses | ? {$_ -like "*@customdomain"} | % {Set-MailBox -Identity $m.PrimarySmtpAddress -EmailAddresses @{remove="$_"}}
}

#Tenant 에서 M365 그룹의 PrimarySmtpAddress 를 tenantname.onmicrosoft.com 으로 변경
Connect-ExchangeOnline
$tenantM365G = Get-UnifiedGroup -ResultSize Unlimited | Where-Object {$_.PrimarySmtpAddress -like "*@customdomain"}
$tenantM365G | foreach {$newSMTP = $_.PrimarySmtpAddress.Replace("customdomain","tenantname.onmicrosoft.com"); $_ | Set-UnifiedGroup -PrimarySmtpAddress $newSMTP}

#Tenant 에서 M365 그룹의 smtp:customdomain 삭제
Connect-ExchangeOnline
# 대상자 확인용 : $tenantM365G = Get-UnifiedGroup -ResultSize Unlimited | Select -ExpandProperty EmailAddresses | ? {$_ -like "*@customdomain"}
$tenantM365G = Get-UnifiedGroup -ResultSize Unlimited
foreach ($g in $tenantM365G) { 
Get-UnifiedGroup -Identity $g.PrimarySmtpAddress | Select -ExpandProperty EmailAddresses | ? {$_ -like "*@customdomain"} | % {Set-UnifiedGroup -Identity $g.PrimarySmtpAddress -EmailAddresses @{remove="$_"}}
}

#Tenant 에서 DG 또는 MESG(=Mail Enabled Security Group) 그룹의 PrimarySmtpAddress 를 tenantname.onmicrosoft.com 으로 변경
Connect-ExchangeOnline
$tenantDGMESG = Get-DistributionGroup -ResultSize Unlimited | Where-Object {$_.PrimarySmtpAddress -like "*@customdomain"}
$tenantDGMESG | foreach {$newSMTP = $_.PrimarySmtpAddress.Replace("customdomain","tenantname.onmicrosoft.com"); $_ | Set-DistributionGroup -PrimarySmtpAddress $newSMTP}

#Tenant 에서 DG 또는 MESG(=Mail Enabled Security Group) 그룹의 smtp:customdomain 삭제
Connect-ExchangeOnline
# 대상자 확인용 : $tenantDGMESG = Get-DistributionGroup -ResultSize Unlimited | Select -ExpandProperty EmailAddresses | ? {$_ -like "*@customdomain"}
$tenantDGMESG = Get-DistributionGroup -ResultSize Unlimited
foreach ($g in $tenantDGMESG) { 
Get-UnifiedGroup -Identity $g.PrimarySmtpAddress | Select -ExpandProperty EmailAddresses | ? {$_ -like "*@customdomain"} | % {Set-DistributionGroup -Identity $g.PrimarySmtpAddress -EmailAddresses @{remove="$_"}}
}

#Tenant 에서 Custome Domain 을 메일 주소로 가지는 DG 또는 MESG(=Mail Enabled Security Group) 삭제
Connect-ExchangeOnline
$tenantDGMESG = Get-DistributionGroup -ResultSize Unlimited | Select -ExpandProperty emailaddresses | ? {$_ -like "*@customdomain"}
foreach ($g in $tenantDGMESG) {
Remove-DistributionGroup -Identiry $g.PrimarySmtpAddress -BypassSecurityGroupManagerCheck
}
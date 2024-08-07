Connect-ExchangeOnline
Get-UnifiedGroup -Identity 'M365 Help Desk' | Set-UnifiedGroup -UnifiedGroupWelcomeMessageEnabled: $false
Get-UnifiedGroup -Identity 'M365 Help Desk' | Set-UnifiedGroup -HiddenFromExchangeClientsEnabled: $true

Get-UnifiedGroup -Identity 'M365 Help Desk' | select *


Get-UnifiedGroup | Where-Object {$_.displayname -like "*Desk"}

Disconnect-ExchangeOnline

Get-UnifiedGroup | Where-Object {$_.displayname -like "* help desk"}
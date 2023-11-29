Connect-ExchangeOnline
Get-UnifiedGroup -Identity '[GTR] M365 Help Desk' | Set-UnifiedGroup -UnifiedGroupWelcomeMessageEnabled: $false
Get-UnifiedGroup -Identity '[GTR] M365 Help Desk' | Set-UnifiedGroup -HiddenFromExchangeClientsEnabled: $true

Get-UnifiedGroup -Identity '[GTR] M365 Help Desk' | select *


Get-UnifiedGroup | Where-Object {$_.displayname -like "*Desk"}

[GEU/EHQ] M365 Help Desk
[GSK] M365 Help Desk
[GCZ] M365 Help Desk
[GTR] M365 Help Desk

Disconnect-ExchangeOnline

Get-UnifiedGroup | Where-Object {$_.displayname -like "* help desk"}
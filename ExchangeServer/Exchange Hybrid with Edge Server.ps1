<#-------------------------------------------Exchange Hybrid Configuration-------------------------------------------#>

<#------------------------------------------- Phase 1: Exchange Server-------------------------------------------#>

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

    # 0. Preparing Certname
        #cert
        #Get Thumbprint
        $Thumbp = Get-ExchangeCertificate | Where-Object{$_.subject -like "*cakeparty.kro.kr*"}
        $Thumbp.thumbprint

        #Set TLS CertName
        $TLSCert = Get-ExchangeCertificate -Thumbprint $Thumbp.thumbprint
        $TLSCertName = "<I>$($TLSCert.Issuer)<S>$($TLSCert.Subject)"

    # 1. Start Hybrid
        Set-HybridConfiguration -ClientAccessServers $null -ExternalIPAddresses $null -Domains 'jose.run.place' -OnPremisesSmartHost 'mail.jose.run.place' -TLSCertificateName '<I>CN=ZeroSSL RSA Domain Secure Site CA, O=ZeroSSL, C=AT<S>CN=jose.run.place' -SendingTransportServers $null -ReceivingTransportServers $null -EdgeTransportServers JOSEEDGE01 -Features FreeBusy,MoveMailbox,Mailtips,MessageTracking,OwaRedirection,OnlineArchive,SecureMail,CentralizedTransport,Photos
    
    # 2. OrgaisationRelationship
        Set-OrganizationRelationship -TargetOwaURL 'https://outlook.office.com/mail' -Identity 'On-premises to O365 - b5979a4d-3184-4d53-add6-0db08a57fe7d'

    #. 3 Connectors
        New-SendConnector -Name 'Outbound to Office 365 - b5979a4d-3184-4d53-add6-0db08a57fe7d' -AddressSpaces 'smtp:M365x67099404.mail.onmicrosoft.com;1' -DNSRoutingEnabled: $true -ErrorPolicies Default -Fqdn 'jose.run.place' -RequireTLS: $true -IgnoreSTARTTLS: $false -SourceTransportServers JOSEEDGE01 -SmartHosts $null -TLSAuthLevel DomainValidation -DomainSecureEnabled: $false -TLSDomain 'mail.protection.outlook.com' -CloudServicesMailEnabled: $true -TLSCertificateName '<I>CN=ZeroSSL RSA Domain Secure Site CA, O=ZeroSSL, C=AT<S>CN=jose.run.place'
        Set-PartnerApplication -Identity 'Exchange Online' -Enabled: $true


<#------------------------------------------- Phase 2: Exchange Online-------------------------------------------#>

    # 0. OrganisationRelationShip
        Set-OrganizationRelationship -TargetSharingEpr $null -TargetOwaURL 'https://mail.jose.run.place/owa' -Identity 'O365 to On-premises - 28bb35b7-47ef-4ffb-8a58-33cdf00dade3'

    # 1. MigrationEndPoint
        Test-MigrationServerAvailability -ExchangeRemoteMove: $true -RemoteServer 'mail.jose.run.place' -Credentials (Get-Credential -UserName JOSE\joseadmin)
        New-MigrationEndpoint -Name 'Hybrid Migration Endpoint - EWS (Default Web Site)' -ExchangeRemoteMove: $true -RemoteServer 'mail.jose.run.place' -Credentials (Get-Credential -UserName JOSE\joseadmin)
        Set-OnPremisesOrganization -Identity '28bb35b7-47ef-4ffb-8a58-33cdf00dade3' -Comment 'rZTbTttAEIbnUaxe0YvQHByTIBoJTBBUHKQamuvEa2iAxMhJWnj5lm/GDoraBMdVZa135/j/Ozu7v38dSCgLyfgSmcpcjiWViQxljOTJtbzIE5bP8kEi1jM8Euy7SHNi1OsOW0++yBW6PpavciOXzOdoQjlkPpBP76D0sF8gO2xVEE/I+Mh3itfILM6Qlrk07xWWe9YxsSH6qdzidwdKBvqU7LdYs3dxj4hLwUksIkceIs/QKN62GMonJG5c1OCbaWfIaUmtz8w/EN/QfdmTjrSlzty1f8DckBajLc2i2ptwlMUxvDT3NboJ8w1SbFIsD3huzyUAtQMDZVTnC1gpo7axbMPINz5liMoqMp4/7P/vtWnap9VoWUWUn7IMjKdy2YyTd6KeXWZ8c22f4UBPrffmILqismPGS6WeXe1Vbw2W9xeaJzXTDsjlyQ6VTOinofW+WgfII+bI2CTysbgDVXeRd6d6ToteTok/JOLJeileyXXJelLxtrboixFn4Iy9Y1ddcjpOrMbwsXRZjTixDvqa3Zk6ni070z1kZzvPu7saT93bOevZ2w1djQ3lu1UlLtlR2TuwHcL6Op9gzSy6L8+GnxX3N/4v9zOwl6LJ2qfCdeYGmo69G+srWo2R7mpgcQ+c0SOrn3Tq4o/e3sx6+S5E2JfV1fdkn9Hgr12xy3vStfel8faulGGu4xXhE9suEuspV/HU9V1fFGdenrsnrw=='
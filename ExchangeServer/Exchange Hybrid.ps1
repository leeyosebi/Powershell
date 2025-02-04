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
    New-HybridConfiguration
    Set-HybridConfiguration -ClientAccessServers $null -ExternalIPAddresses $null -Domains 'cakeparty.kro.kr' -OnPremisesSmartHost 'mail.cakeparty.kro.kr' -TLSCertificateName $TLSCertName -SendingTransportServers CAKEPARTYEX01 -ReceivingTransportServers CAKEPARTYEX01 -EdgeTransportServers $null -Features FreeBusy,MoveMailbox,Mailtips,MessageTracking,OwaRedirection,OnlineArchive,SecureMail,CentralizedTransport,Photos

    # 2. Remote Domain
    New-RemoteDomain -Name 'Hybrid Domain - M365x66243491.mail.onmicrosoft.com' -DomainName 'M365x66243491.mail.onmicrosoft.com'
    Set-RemoteDomain -TargetDeliveryDomain: $true -Identity 'Hybrid Domain - M365x66243491.mail.onmicrosoft.com'
    New-RemoteDomain -Name 'Hybrid Domain - M365x66243491.onmicrosoft.com' -DomainName 'M365x66243491.onmicrosoft.com'
    Set-RemoteDomain -TrustedMailInboundEnabled: $true -Identity 'Hybrid Domain - M365x66243491.onmicrosoft.com'
    
    # 3. Accepted Domain & Email Addresses Policy 
    New-AcceptedDomain -DomainName 'M365x66243491.mail.onmicrosoft.com' -Name 'M365x66243491.mail.onmicrosoft.com'
    Set-EmailAddressPolicy -Identity 'Default Policy' -ForceUpgrade: $true -EnabledEmailAddressTemplates 'smtp:@cakeparty.kro.local','SMTP:%m@cakeparty.kro.kr','smtp:%m@M365x66243491.mail.onmicrosoft.com'
    Update-EmailAddressPolicy -Identity 'Default Policy' -UpdateSecondaryAddressesOnly: $true

    # 4. OrganisationRelationship
    New-OrganizationRelationship -Name 'On-premises to O365 eeebbbe0-5bab-442c-bdd6-24c37abf9f20' -TargetApplicationUri $null -TargetAutodiscoverEpr $null -Enabled: $true -DomainNames 'M365x66243491.mail.onmicrosoft.com'
    Set-OrganizationRelationship -MailboxMoveEnabled: $true -FreeBusyAccessEnabled: $true -FreeBusyAccessLevel LimitedDetails -ArchiveAccessEnabled: $true -MailTipsAccessEnabled: $true -MailTipsAccessLevel All -DeliveryReportEnabled: $true -PhotosEnabled: $true -TargetOwaURL 'https://outlook.office.com/mail' -Identity 'On-premises to O365 eeebbbe0-5bab-442c-bdd6-24c37abf9f20'
    
    # 5. Add AvailabilityAddressSpace
    Add-AvailabilityAddressSpace -ForestName 'M365x66243491.mail.onmicrosoft.com' -AccessMethod InternalProxy -UseServiceAccount: $true -ProxyUrl 'https://cakepartyex01.jose.run.local/EWS/Exchange.asmx'

    # 6. Connector Set up
    Set-HybridConfiguration -ClientAccessServers $null -ExternalIPAddresses $null
    New-SendConnector -Name 'Outbound to Office 365 - eeebbbe0-5bab-442c-bdd6-24c37abf9f20' -AddressSpaces 'smtp:M365x66243491.mail.onmicrosoft.com;1' -DNSRoutingEnabled: $true -ErrorPolicies Default -Fqdn 'cakeparty.kro.kr' -RequireTLS: $true -IgnoreSTARTTLS: $false -SourceTransportServers CAKEPARTYEX01 -SmartHosts $null -TLSAuthLevel DomainValidation -DomainSecureEnabled: $false -TLSDomain 'mail.protection.outlook.com' -CloudServicesMailEnabled: $true -TLSCertificateName $TLSCertName
    Set-ReceiveConnector -AuthMechanism 'Tls, Integrated, BasicAuth, BasicAuthRequireTLS, ExchangeServer' -Bindings '[::]:25','0.0.0.0:25' -Fqdn 'CAKEPARTYEX01.CAKEPARTY.KRO.LOCAL' -PermissionGroups 'AnonymousUsers, ExchangeServers, ExchangeLegacyServers' -RemoteIPRanges '::-ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff','0.0.0.0-255.255.255.255' -RequireTLS: $false -TLSDomainCapabilities 'mail.protection.outlook.com:AcceptCloudServicesMail' -TLSCertificateName $TLSCertName -TransportRole FrontendTransport -Identity 'CAKEPARTYEX01\Default Frontend CAKEPARTYEX01'
    New-IntraOrganizationConnector -Name 'HybridIOC - eeebbbe0-5bab-442c-bdd6-24c37abf9f20' -DiscoveryEndpoint 'https://autodiscover-s.outlook.com/autodiscover/autodiscover.svc' -TargetAddressDomains 'M365x66243491.mail.onmicrosoft.com' -Enabled: $true
    Set-PartnerApplication -Identity 'Exchange Online' -Enabled: $true
   
    # 7. AuthServer set up
    New-AuthServer -Name 'ACS - eeebbbe0-5bab-442c-bdd6-24c37abf9f20' -AuthMetadataUrl 'https://accounts.accesscontrol.windows.net/637ce511-f6a0-47ed-a892-6efb7b9b688a/metadata/json/1' -DomainName 'CAKEPARTY.KRO.KR','M365x66243491.mail.onmicrosoft.com' #Tenant GUID
    New-AuthServer -Name 'EvoSts - eeebbbe0-5bab-442c-bdd6-24c37abf9f20' -AuthMetadataUrl 'https://login.windows.net/M365x66243491.onmicrosoft.com/federationmetadata/2007-06/federationmetadata.xml' -Type AzureAD


<#------------------------------------------- Phase 2: Exchange Online-------------------------------------------#>
    # 1. OrganisationRelationShip
    New-OrganizationRelationship -Name 'O365 to On-premises - 3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d' -TargetApplicationUri $null -TargetAutodiscoverEpr $null -Enabled: $true -DomainNames 'CAKEPARTY.KRO.KR'
    Set-OrganizationRelationship -FreeBusyAccessEnabled: $true -FreeBusyAccessLevel LimitedDetails -TargetSharingEpr $null -MailTipsAccessEnabled: $true -MailTipsAccessLevel All -DeliveryReportEnabled: $true -PhotosEnabled: $true -TargetOwaURL 'https://mail.cakeparty.kro.kr/owa' -Identity 'O365 to On-premises - ManualHybrid'

    # 2. Connectors
    New-InboundConnector -Name 'Inbound from 3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d' -CloudServicesMailEnabled: $true -ConnectorSource HybridWizard -ConnectorType OnPremises -RequireTLS: $true -SenderDomains '*' -SenderIPAddresses $null -RestrictDomainsToIPAddresses: $false -TLSSenderCertificateName 'cakeparty.kro.kr' -AssociatedAcceptedDomains $null
    New-OutboundConnector -Name 'Outbound to 3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d' -RecipientDomains '*' -SmartHosts 'mail.cakeparty.kro.kr' -ConnectorSource HybridWizard -ConnectorType OnPremises -TLSSettings DomainValidation -TLSDomain 'cakeparty.kro.kr' -CloudServicesMailEnabled: $true -RouteAllMessagesViaOnPremises: $true -UseMxRecord: $false -IsTransportRuleScoped: $false

    # 3. Onpremisesorganization
    New-OnPremisesOrganization -HybridDomains 'CAKEPARTY.KRO.KR' -InboundConnector 'Inbound from 3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d' -OutboundConnector 'Outbound to 3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d' -OrganizationRelationship 'O365 to On-premises - 3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d' -OrganizationName 'First Organization' -Name '3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d' -OrganizationGuid '3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d'
    New-IntraOrganizationConnector -Name 'HybridIOC - 3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d' -DiscoveryEndpoint 'https://mail.cakeparty.kro.kr/autodiscover/autodiscover.svc' -TargetAddressDomains 'CAKEPARTY.KRO.KR' -Enabled: $true
    
    # Migration Endpoint
    Test-MigrationServerAvailability -ExchangeRemoteMove: $true -RemoteServer 'mail.cakeparty.kro.kr' -Credentials (Get-Credential -UserName CAKEPARTY\cakepartysuper)
    New-MigrationEndpoint -Name '[CAKEPARTY]Hybrid Migration Endpoint - EWS (Default Web Site)' -ExchangeRemoteMove: $true -RemoteServer 'mail.cakeparty.kro.kr' -Credentials (Get-Credential -UserName CAKEPARTY\cakepartysuper)
    Set-OnPremisesOrganization -Identity '3f8e7a2d-1b45-4c89-a0d7-6f5b2e1c9a8d' -Comment 'Weird String'
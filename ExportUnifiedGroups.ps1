# CSV file export path
$Csvfile = "C:\scripts\ExportUnifiedGroups.csv"

# Get all Unified Groups
$Groups = Get-UnifiedGroup -ResultSize Unlimited

# Loop through Unified Groups
$Groups | ForEach-Object {

    $GroupDN = $_.DistinguishedName
    $DisplayName = $_.DisplayName
    $PrimarySmtpAddress = $_.PrimarySmtpAddress
    $GroupType = $_.GroupType
    $RecipientType = $_.RecipientType
    $Members = Get-UnifiedGroupLinks -Identity $GroupDN -LinkType Members | Get-Mailbox
    $ManagedBy = $_.ManagedBy
    $Alias = $_.Alias
    $HiddenFromAddressLists = $_.HiddenFromAddressListsEnabled
    $MemberJoinRestriction = $_.MemberJoinRestriction 
    $MemberDepartRestriction = $_.MemberDepartRestriction
    $RequireSenderAuthenticationEnabled = $_.RequireSenderAuthenticationEnabled
    $AcceptMessagesOnlyFrom = $_.AcceptMessagesOnlyFrom
    $GrantSendOnBehalfTo = $_.GrantSendOnBehalfTo
    $Notes = (Get-Group $GroupDN)

    # Create objects
    [PSCustomObject]@{
        DisplayName                        = $DisplayName
        PrimarySmtpAddress                 = $PrimarySmtpAddress
        Alias                              = $Alias
        GroupType                          = $GroupType
        RecipientType                      = $RecipientType
        Members                            = ($Members.DisplayName -join ',')
        MembersPrimarySmtpAddress          = ($Members.PrimarySmtpAddress -join ',')
        ManagedBy                          = ($ManagedBy.DisplayName -join ',')
        HiddenFromAddressLists             = $HiddenFromAddressLists
        MemberJoinRestriction              = $MemberJoinRestriction 
        MemberDepartRestriction            = $MemberDepartRestriction
        RequireSenderAuthenticationEnabled = $RequireSenderAuthenticationEnabled
        AcceptMessagesOnlyFrom             = ($AcceptMessagesOnlyFrom.DisplayName -join ',')
        GrantSendOnBehalfTo                = ($GrantSendOnBehalfTo.DisplayName -join ',')
        Notes                              = $Notes.Notes
    }

# Export report to CSV file
} | Sort-Object DisplayName | Export-CSV -Path $Csvfile -NoTypeInformation -Encoding UTF8

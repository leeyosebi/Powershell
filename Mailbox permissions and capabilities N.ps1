# Mailbox permissions and capabilities NOT supported in hybrid environments

    #Exchange management Shell
    Add-RecipientPermission -Identity <그룹> -Trustee <EXO사서함> -AccessRights SendAs
    #EXO
    Add-ADPermission -Identity <그룹> -User <EXO사서함> -AccessRights ExtendedRight -ExtendedRights "Send As"

    #Using variable
        #Exchange Management Shell
        $TargetDL = Get-DistributionGroup -Identity A@domain.name
        $TargetADUser = $ADUsers | where {$_.UserprincipalName -eq user@domain.name}
        Add-ADPermission -Identity $TargetDL.Identity -User $TargetADUser.UserPrincipalName -AccessRights ExtendedRight -ExtendedRights "Send As"

    #EXO
        $TargetDL = Get-DistributionGroup -Identity A@domain.name
        $TargetAADUser = $AADUsers | where {$_.UserprincipalName -eq user@domain.name}
        Add-RecipientPermission -Identity $TargetDL.Identity -Trustee $TargetAADUser.UserPrincipalName -AccessRights SendAs
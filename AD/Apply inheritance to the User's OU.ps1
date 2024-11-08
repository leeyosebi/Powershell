# Apply inheritance to the User's OU

[array]$users = get-aduser -filter *

ForEach($user in $users)
{
    $dn= [ADSI](“LDAP://” + $user)
    $acl= $dn.psbase.objectSecurity
    if ($acl.get_AreAccessRulesProtected())
    {
        $isProtected = $false # $false to enable inheritance
                              # $true to disable inheritance
        $preserveInheritance = $true # $true to keep inherited access rules
                                     # $false to remove inherited access rules.
                                     # ignored if isProtected=$false
        $acl.SetAccessRuleProtection($isProtected, $preserveInheritance)
        $dn.psbase.commitchanges()
        Write-Host($user.SamAccountName + "|" + `
                   $user.DistinguishedName + `
                   "|inheritance set to enabled")
    }
    else
    {
        write-host($user.SamAccountName + "|" + `
                   $user.DistinguishedName + `
                   "|inheritance already enabled")
    }
}
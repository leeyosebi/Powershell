# MgGraph login
Connect-MgGraph -Scopes "Policy.Read.All", "Policy.ReadWrite.ConditionalAccess", "DeviceManagementConfiguration.ReadWrite.All"

# Identify Group ID:
# Get-MgGroup -Filter "DisplayName eq 'Group Name'"

$GroupId = "Group ID"
$newGroupId = "New Group ID"

# Identify the policies
$policies = Get-MgIdentityConditionalAccessPolicy -All | Where-Object {
    $_.Conditions.Users.IncludeGroups -contains $GroupId -or
    $_.Conditions.Users.ExcludeGroups -contains $GroupId
}

foreach ($p in $policies) {
    # if Group in IncludeGroups + NewGroup in IncludeGroups
    if ($p.Conditions.Users.IncludeGroups -contains $GroupId) {
        $p.Conditions.Users.IncludeGroups += $newGroupId
    }
    # if Group in ExcludeGroups + NewGroup in ExcludeGroups
    if ($p.Conditions.Users.ExcludeGroups -contains $GroupId) {
        $p.Conditions.Users.ExcludeGroups += $newGroupId
    }

    # Update
    Update-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $p.Id -BodyParameter @{
        Conditions = $p.Conditions
    }
}
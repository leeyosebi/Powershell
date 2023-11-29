# Connect to Azure AD
Connect-AzureAD

# Get the group by display name
$GroupName = "M365 Help Desk"
$Group = Get-AzureADGroup -All $true | Where-Object {$_.DisplayName -eq $GroupName}

if ($Group) {
    $GroupID = $Group.ObjectId

    # Get members of the group
    $GroupMembers = Get-AzureADGroupMember -ObjectId $GroupID

    # Iterate through each member and add them to the group
    foreach ($Member in $GroupMembers) {
        Add-AzureADGroupMember -ObjectId $GroupID -RefObjectId $Member.ObjectId
    }

    Write-Host "Members added successfully to the group: $GroupName"
} else {
    Write-Host "Group $GroupName not found."
}

# Disconnect from Azure AD
Disconnect-AzureAD

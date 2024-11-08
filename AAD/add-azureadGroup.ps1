# Connect to Azure AD
Connect-AzureAD

# Get the group by display name
# This group's member will be added to the 'Target Group'
$refGroupName = "regGroupName"
$refGroup = Get-AzureADGroup -All $true | Where-Object {$_.DisplayName -eq $refGroupName}

if ($refGroup) {
    $refGroupID = $refGroup.ObjectId

    # Get members of the group
    $refGroupMembers = Get-AzureADGroupMember -ObjectId $refGroupID

    # Iterate through each member and add them to the group
    foreach ($Member in $refGroupMembers) {
        Add-AzureADGroupMember -ObjectId "Target Group ObjectID" -RefObjectId $Member.ObjectId
    }

    Write-Host "Members added successfully to the group"
} else {
    Write-Host "Group TargetGroup not found."
}

# Disconnect from Azure AD
Disconnect-AzureAD
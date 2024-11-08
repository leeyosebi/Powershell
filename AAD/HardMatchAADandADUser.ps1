connect-msolservice

Get-MsolUser -UserPrincipalName whtpquser01@whtpq.com | fl ImmutableID

Set-MsolUser -UserPrincipalName whtpquser01@whtpq.com -ImmutableId k9+Qr5U+zE2vaj88Lai5ZQ==

$ObjectGUID = "af90df93-3e95-4dcc-af6a-3f3c2da8b965"
$immutableID = [Convert]::ToBase64String([guid]::New($ObjectGUID).ToByteArray())
# Print the ImmutableID
Write-Host "ImmutableID:" $immutableID

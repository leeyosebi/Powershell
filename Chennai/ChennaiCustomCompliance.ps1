<#
#------------------DLP------------------
$dgagent    = Get-Process -Name dgagent*
$dgservice  = Get-Process -Name dgservice*
$DLP        = $dgagent.ProcessName + $dgservice.ProcessName

if ([string]::IsNullOrEmpty($DLP)) {
    $DLPPresent = "no"
} else {
    $DLPPresent = "yes"
}

#------------------EDR------------------
$GsAgent    = Get-Process -Name GsAgent*
$EDR        = $GsAgent.ProcessName

if ([string]::IsNullOrEmpty($EDR)) {
    $EDRPresent = "no"
} else {
    $EDRPresent = "yes"
}
#>

#------------------zScaler1------------------
$ZSATunnel  = Get-Process -Name ZSATunnel*
$SASE1      = $ZSATunnel.ProcessName

if ([string]::IsNullOrEmpty($SASE1)) {
    $SASE1Present = "no"
} else {
    $SASE1Present = "yes"
}

#------------------zScaler2------------------
$ZSAService = Get-Process -Name ZSAService*
$SASE2      = $ZSAService.ProcessName

if ([string]::IsNullOrEmpty($SASE2)) {
    $SASE2Present = "no"
} else {
    $SASE2Present = "yes"
}

#------------------FORCEPOINT ONE ENDPOINT------------------
$ForcePointService = Get-Process -Name Dserui*
$ForcePoint        = $ForcePointService.ProcessName

if ([string]::IsNullOrEmpty($ForcePoint)) {
    $ForcePointPresent = "no"
} else {
    $ForcePointPresent = "yes"
}

#------------------FireEye Endpoint------------------
$FireEyeService = Get-Process -Name xagt*
$FireEye        = $FireEyeService.ProcessName

if ([string]::IsNullOrEmpty($FireEye)) {
    $FireEyepresent = "no"
} else {
    $FireEyepresent = "yes"
}

#==================RESULTS==================
$hash = @{ 
    #DLPPresent           = $DLPPresent
    #EDRPresent           = $EDRPresent
    SASE1Present         = $SASE1Present
    SASE2Present         = $SASE2Present
    ForcePointPresent    = $ForcePointPresent
    FireEyepresent       = $FireEyepresent
}

return $hash | ConvertTo-Json -Compress

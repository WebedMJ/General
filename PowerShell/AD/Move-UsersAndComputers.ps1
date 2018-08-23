# Moves users from AD Group and and SCCM associated computer account to new OU
param (
    $SCCMSite,
    [Parameter(Mandatory = $true)]$ADUserGroup,
    $NewUserOUDN,
    $NewComputerOUDN,
    [Parameter(Mandatory = $true)][pscredential]$ADPSCred,
    [bool]$Confirm = $false,
    $logfolder = $env:TEMP
)
$rundt = Get-Date -Format HHmmssddMMyyyy
switch ($Confirm) {
    $true {
        Write-Host "Confirm set to true, moving users..."
    }
    $false {
        switch (($PSBoundParameters.ContainsValue($Deploy))) {
            $false {
                Write-Host "Confirm not specified, default to report only..."
            }
            default {
                Write-Host "Deploy set to false, running in read only mode..."
            }
        }
    }
}
$script:WhatIfPreference = !$Confirm

try {
    Import-Module 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1' -ErrorAction Stop
} catch {
    Write-Host "Error importing SCCM module"
    exit 1
}

# Gather users...
Set-Location $SCCMSite":"
$adusers = Get-ADGroup -Identity $ADUserGroup | Get-ADGroupMember | Get-ADUser -Properties *
$userreport = @()
$adusers.foreach( {
        $reportline = [pscustomobject]@{
            Username    = $_.SamAccountName
            FullName    = $_.Name
            CurrentPath = $_.DistinguishedName
            NewOUDN     = $NewUserOUDN
        }
        $userreport += $reportline
    })
try {
    $userreportpath = "$logfolder\MovedUserReport-{0}.csv" -f $rundt
    Write-Host "Saving user report to $userreportpath"
    $userreport | Export-Csv $userreportpath -NoTypeInformation -Force
} catch {
    Write-Host "Error creating user report, aborting..."
    exit 1
}

# Gather computers...
$alldevices = Get-CMDevice
$userwksnames = @()
$computerreport = @()
$adusers.foreach( {
        $username = $_.SamAccountName
        $computernames = $alldevices | Where-Object {
            $_.username -eq $username -and $_.DeviceOS -match "Workstation"
        } |
            Select-Object Name
        $userwksnames += $computernames
    })
$adcomputers = $userwksnames.ForEach( {Get-ADComputer $_.name})
$adcomputers.foreach( {
        $reportline = [pscustomobject]@{
            ComputerName = $_.DNSHostName
            CurrentPath  = $_.DistinguishedName
            NewOUDN      = $NewComputerOUDN
        }
        $computerreport += $reportline
    })
try {
    $computerreportpath = "$logfolder\MovedComputerReport-{0}.csv" -f $rundt
    Write-Host "Saving user report to $computerreportpath"
    $computerreport | Export-Csv $computerreportpath -NoTypeInformation -Force
} catch {
    Write-Host "Error creating computer report, aborting..."
    exit 1
}

# Move users
try {
    $adusers.foreach( {
            $un = $PSItem.Name
            Write-Host "Moving $un"
            $PSItem | Move-ADObject -TargetPath $NewUserOUDN -Credential $ADPSCred -PassThru -ErrorAction Stop
        })
} catch {
    $message = $error[0].Exception.Message
    Write-Host $message
}

# Move computers
try {
    $adcomputers.foreach( {
            $cn = $PSItem.Name
            Write-Host "Moving $cn"
            $PSItem | Move-ADObject -TargetPath $NewComputerOUDN -Credential $ADPSCred -ErrorAction Stop
        })
}
catch {
    $message = $error[0].Exception.Message
    Write-Host $message
}
$openlogfolder = "explorer $logfolder"
Invoke-Expression $openlogfolder
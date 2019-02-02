# Moves users from a text file list of users and SCCM associated computer account to new OU
param (
    [Parameter(Mandatory = $true)]$SCCMSite,
    [Parameter(Mandatory = $true)]$ADUserGroup,
    [Parameter(Mandatory = $true)]$NewUserOUDN,
    [Parameter(Mandatory = $true)]$NewComputerOUDN,
    [Parameter(Mandatory = $true)][pscredential]$ADPSCred,
    [bool]$Confirm = $false,
    $logfolder = $env:TEMP
)
$startloc = Get-Location
$rundt = Get-Date -Format HHmmssddMMyyyy
$domain = (Get-ADDomain).NetBIOSName
switch ($Confirm) {
    $true {
        Write-Host "Confirm set to true, moving users..."
    }
    $false {
        switch (($PSBoundParameters.ContainsValue($Confirm))) {
            $false {
                Write-Host "Confirm not specified, default to report only..."
            }
            default {
                Write-Host "Confirm set to false, running in read only mode..."
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
$userwksnames = @()
$computerreport = @()
$adusers.foreach( {
        $username = $_.SamAccountName
        $computernames = Get-CMUserDeviceAffinity -UserName "$domain\$username" | Select-Object ResourceName
        $userwksnames += $computernames
    })
$adcomputers = $userwksnames.ForEach( {
        try {
            Get-ADComputer $_.ResourceName -ErrorAction Stop
        } catch {
            $message = $error[0].Exception.Message
            Write-Host $message
        }
    })
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
    Write-Host "Saving computer report to $computerreportpath"
    $computerreport | Export-Csv $computerreportpath -NoTypeInformation -Force
} catch {
    Write-Host "Error creating computer report, aborting..."
    exit 1
}

# Move users
$adusers.foreach( {
        try {
            $un = $PSItem.Name
            Write-Host "Moving $un"
            $PSItem | Move-ADObject -TargetPath $NewUserOUDN -Credential $ADPSCred -PassThru -ErrorAction Stop
        } catch {
            $message = $error[0].Exception.Message
            $target = $error[0].CategoryInfo.TargetName
            Write-Host "$message on $target"
        }
    })

# Move computers
$adcomputers.foreach( {
        try {
            $cn = $PSItem.Name
            Write-Host "Moving $cn"
            $PSItem | Move-ADObject -TargetPath $NewComputerOUDN -Credential $ADPSCred -ErrorAction Stop
        } catch {
            $message = $error[0].Exception.Message
            $target = $error[0].CategoryInfo.TargetName
            Write-Host "$message on $target"
        }
    })

Set-Location $startloc
$openlogfolder = "explorer $logfolder"
Invoke-Expression $openlogfolder

<###########################################################################

 NAME: VeeamFileRestore.ps1

 COMMENT: This script restore a comma guest file from a Veeam backup and
          injects it into the guest VM.

 IMPORTANT: Must be run from an elevated command prompt on a Veeam Backup server.
            Also needs saved passwords for vSphere User and Guest VM admin user.
 
 VERSION HISTORY:
 1.0 2016-08-24 - Initial release
 1.1 2016-09-07 - Added vSphere integrated restore
 1.2 2016-12-20 - Updated for use with scheduled script and request queue
 1.3 2017-05-24 - Updated volume mount point path handling for Veeam 9.5
 1.4 2017-05-26 - Changed to PowerCLI 6.5 module support
 1.5 2017-09-29 - Added secondary remote Veeam server option, added logging function

 USAGE: .\VeeamFileRestore-auto.ps1 -TargetVM <VMName> -FilesToRestore <File1,File2> -Reason <VeeamJobReason> -BackupDate <ddmmyyyy>

###########################################################################>

param
(
    [Parameter(Position = 0, Mandatory = $true)]$TargetVM,
    [Parameter(Position = 1, Mandatory = $true)][string[]]$FilesToRestore,
    [Parameter(Position = 2, Mandatory = $true)]$Reason,
    [Parameter(Position = 3, Mandatory = $true)]$BackupDate,
    [Parameter(Position = 4, Mandatory = $false)]$RequestFilename,
    [Parameter(Position = 5, Mandatory = $false)]$EmailRecipient = "<SPECIFY DEFAULT EMAIL>",
    [Parameter(Position = 6, Mandatory = $false)]$RemoteVeeamSvr = "<SPECIFY DEFAULT REMOTE VEEAM SERVER>"
)

# Script must be run from this folder...
Set-Location "C:\Scripts\VeeamFileRestores\AutoFileRestoreScript"

if (!(Test-Path ".\Logs")) {
    New-Item Logs -ItemType Directory
}
$now = Get-Date

$logfile = ".\Logs\Restores.log"
if ((Get-Item $logfile).CreationTime -le $now.AddHours(-23)) {
    $oldfile = 'Restores-{0}.log' -f $now.DayOfYear
    Remove-Item -Path $oldfile -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    Rename-Item -Path $logfile -NewName $oldfile -Force
}

Function Write-ToLog {
    param (
        [Parameter(Position = 0, Mandatory = $true)]$LogMessage
    )
    $logtime = (Get-Date -Format (Get-culture).DateTimeFormat.ShortDatePattern) + " " + (Get-Date -Format (Get-culture).DateTimeFormat.LongTimePattern)
    Write-Output "$logtime - $LogMessage" | Out-File -Append -FilePath $logfile
}

$SMTPServerAddress = "<SMTP SERVER>"
$lowercasehostname = ($env:computername).ToLower()
$EmailSender = "$env:computername PowerShell <ps.$lowercasehostname@domain.co.uk>"
$EmailSubject = "Restore for ticket $Reason Completed"
$origfiles = $FilesToRestore.split(',') | ForEach-Object {$_.trim()}
[DateTime]$dt = [datetime]::ParseExact($BackupDate, ”ddMMyyyy”, $null)
$vCenters = "<INSERT COMMA SEPARATED VCENTER SERVERS>"
$vSphereUser = "<INSERT VPSHERE USERNAME>"
$vSpherePasswordfile = "<PATH TO VPSHERE USER PASSWORD TXT FILE>"
$GuestVMUser = "<INSERT GUEST VM ADMIN USERNAME>"
$GuestVMPasswordfile = "<PATH TO GUEST VM ADMIN USER PASSWORD TXT FILE>"

Write-ToLog -LogMessage "Processing request file: $RequestFilename"

if (!$dt) {
    Write-ToLog -LogMessage "ERROR 1001: Invalid date"
    Write-Output "1001"
    exit 1001
}
else {
    $dtlong = $dt.ToLongDateString()
    Write-ToLog -LogMessage "Using date $dtlong"
}

[DateTime]$dt1 = $dt.AddHours(17)
[DateTime]$dt2 = $dt.AddHours(32)

if ((Test-Path $vSpherePasswordfile) -eq "True") {
    $vSpherePW = Get-Content $vSpherePasswordfile | Convertto-Securestring
    $vSphereCred = New-Object -Typename System.Management.Automation.PSCredential($vSphereUser, $vSpherePW)
}
else {
    Write-ToLog -LogMessage "ERROR 1002: vSphere password not detected"
    Write-Output "1002"
    exit 1002
}

if ((Test-Path $GuestVMPasswordfile) -eq "True") {
    $GuestVMPW = Get-Content $GuestVMPasswordfile | Convertto-Securestring
    $GuestVMCred = New-Object -Typename System.Management.Automation.PSCredential($GuestVMUser, $GuestVMPW)
}
else {
    Write-ToLog -LogMessage "ERROR 1003: Guest VM password not detected"
    Write-Output "1003"
    exit 1003
}

if (!(Get-PSSnapin VeeamPSSnapin -ErrorAction SilentlyContinue)) {
    Add-PSSnapin VeeamPSSnapin -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
}

if (!(Import-Module VMware.VimAutomation.Core -ErrorAction SilentlyContinue)) {
    Import-Module VMware.VimAutomation.Core -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
}

# Ignore vCenter server certificate errors - REQUIRES ELEVATION!!
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminrole = [System.Security.Principal.WindowsBuiltInRole]::Administrator 
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
}
else {
    Write-ToLog -LogMessage "ERROR 1004: Not elevated, vSphere and Veeam cmdlets will fail"
    Write-Output "1004"
    exit 1004
}

Function Check-vCenter {
    if (!$vc) {
        Write-ToLog -LogMessage "ERROR 1009 - Failure connecting to the vCenter $vCenter!"
    }
    else {
        Write-ToLog -LogMessage "Connected to $vCenter"
    }
}

Function ConnectTo-vCenter {
    param (
        $vCenter = $(throw "A vCenter must be specified."),
        [System.Management.Automation.PSCredential]$vSphereCred
    )
    if ($vSphereCred) {
        Write-ToLog -LogMessage "Credentials detected, using saved credential..."
        $vc = Connect-VIServer $vCenter -Credential $vSphereCred -Force
        Check-vCenter
    }
    else {
        Write-ToLog -LogMessage "No saved credentials found, trying pass-thru..."
        $vc = Connect-VIServer $vCenter -Force
        Check-vCenter
    }
}

# Check remote Veeam server if specified
if ($RemoteVeeamSvr) {
    Disconnect-VBRServer
    Connect-VBRServer -Server $RemoteVeeamSvr
    $remoterp = Get-VBRBackup | Get-VBRRestorePoint | Where-Object {$_.name -eq $TargetVM} | Where-Object {$_.creationtime -gt $dt1 -and $_.creationtime -lt $dt2}
}

if ($remoterp.count -eq "1") {
    $recoverypoint = $remoterp
}
else {
    # Check local Veeam Server
    Disconnect-VBRServer
    Connect-VBRServer -Server localhost
    $localrp = Get-VBRBackup | Get-VBRRestorePoint | Where-Object {$_.name -eq $TargetVM} | Where-Object {$_.creationtime -gt $dt1 -and $_.creationtime -lt $dt2}
    $recoverypoint = $localrp
}

if ($recoverypoint.count -ne "1") {
    $recoverypointnumber = $recoverypoint.count
    Write-ToLog -LogMessage "ERROR 1005: Either too many jobs or no jobs found"
    Write-ToLog -LogMessage "Number of Recovery Points found: $recoverypointnumber"
    Disconnect-VBRServer
    Write-Output "1005"
    exit 1005
}

$BackupDateTime = ($recoverypoint.creationtime).ToLongDateString() + " " + ($recoverypoint.creationtime).ToLongTimeString()
Write-ToLog -LogMessage "Starting restore job..."
Write-ToLog -LogMessage "Mounting backup from $BackupDateTime, this can take upwards of 30 minutes..."
$result = $recoverypoint | Start-VBRWindowsFileRestore -Reason $Reason
$veeammounpoint = $result.MountPoint
foreach ($vCenter in $vCenters) {
    ConnectTo-vCenter -vCenter $vCenter -vSphereCred $vSphereCred
}

#$flrmountpoint = ($result.MountSession.MountedDevices | Where{$_.DriveLetter -eq (Split-Path -Qualifier $origfile)}).MountPoint # May work on Veeam v9...
foreach ($origfile in $origfiles) {
    [int]$volnums = "0"
    $relativefile = Split-Path $origfile -NoQualifier
    if (Test-Path "C:\VeeamFLR\$veeammounpoint\Volume$volnums$relativefile") {
        Write-ToLog -LogMessage "Checking C:\VeeamFLR\$veeammounpoint\Volume$volnums$relativefile"
        $truepath = Test-Path "C:\VeeamFLR\$veeammounpoint\Volume$volnums$relativefile"
        $file = "C:\VeeamFLR\$veeammounpoint\Volume$volnums$relativefile"
        $BkVol = "\Volume$volnums"
    }
    else {
        do {
            $volnums++
            Write-ToLog -LogMessage "Checking C:\VeeamFLR\$veeammounpoint\Volume$volnums$relativefile"
            $truepath = Test-Path "C:\VeeamFLR\$veeammounpoint\Volume$volnums$relativefile"
            $file = "C:\VeeamFLR\$veeammounpoint\Volume$volnums$relativefile"
            $BkVol = "\Volume$volnums"
        }
        while ($volnums -lt "24" -and $truepath -eq $false)
    }

    if ($truepath -eq $false) {
        Write-ToLog -LogMessage "ERROR 1006: File not found in backup"
        Stop-VBRWindowsFileRestore $result -ErrorAction SilentlyContinue
        Disconnect-VIServer -Server * -Force -Confirm:$false
        Disconnect-VBRServer
        Write-Output "1006"
        exit 1006
    }

    $origdirectory = Split-Path $origfile -Parent
    $correctrestoredirectory = "$origdirectory\"
    $filename = (Get-ChildItem $file).BaseName
    $fileext = (Get-ChildItem $file).extension
    $restoresuffix = "-RestoredFrom-$BackupDate"
    $restorefilepath = $correctrestoredirectory + $filename + $restoresuffix + $fileext

    $vSphereVM = Get-VM -Name $TargetVM
    if (!$vSphereVM) {
        Write-ToLog -LogMessage "ERROR 1007: VM not detected in vSphere"
        Stop-VBRWindowsFileRestore $result -ErrorAction SilentlyContinue
        Disconnect-VIServer -Server * -Force -Confirm:$false
        Disconnect-VBRServer
        Write-Output "1007"
        exit 1007
    }
    else {
        Write-ToLog -LogMessage "Original VM found, copying restored file to $restorefilepath"
        Copy-VMGuestFile -Source $file -Destination $restorefilepath -VM $vSphereVM -LocalToGuest -GuestCredential $GuestVMCred -ToolsWaitSecs 300 -ErrorVariable cptovm
        if (!$cptovm) {
            Write-ToLog -LogMessage "$file restored to guest VM successfully"
        }
        else {
            Write-ToLog -LogMessage "ERROR 1008: Error copying file to VM"
            Stop-VBRWindowsFileRestore $result -ErrorAction SilentlyContinue
            Disconnect-VIServer -Server * -Force -Confirm:$false
            Disconnect-VBRServer
            Write-Output "1008"
            exit 1008
        }
    }

}

Stop-VBRWindowsFileRestore $result -ErrorAction SilentlyContinue
Disconnect-VIServer -Server * -Force -Confirm:$false
Disconnect-VBRServer

Write-ToLog -LogMessage "Sending email notification of restore success to $EmailRecipient"
Send-MailMessage -Body "File $relativefile restored to $TargetVM as $restorefilepath. Please update ticket number $Reason." -From $EmailSender -SmtpServer $SMTPServerAddress -Subject $EmailSubject -To $EmailRecipient

Write-ToLog -LogMessage "Finished processing request file: $RequestFilename"
Write-ToLog -LogMessage "Job finished, no errors detected"
Write-Output "1000"
exit 1000
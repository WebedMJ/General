<##########################################################################

 NAME: ProcessRestoreRequests.ps1

 COMMENT: Checks for new restore requests from the Web UI and passes them to
          the VeeamFileRestore-auto.ps1 script in the same location.

 IMPORTANT: This script and VeeamFileRestore-auto.ps1 must be in:
            C:\Scripts\VeeamFileRestores\AutoFileRestoreScript\
            Designed to be run as a scheduled task
            ...all bad I know, haven't had time to refactor :(

 VERSION HISTORY:
 1.0 2016-12-20 - Initial release
 1.1 2017-09-29 - Added logging function
 1.2 2018-06-26 - Corrected logging inconsistencies

 USAGE: .\ProcessRestoreRequests.ps1

###########################################################################>

$BackupRepository = "<VEEAMREPOSITORYNAME>"
$SMTPServerAddress = "<SMTPSERVER>"
$DefaultEmailRecipient = "<EMAILADDRESS>"
$lowercasehostname = ($env:computername).ToLower()
$EmailSender = "$env:computername PowerShell <ps.$lowercasehostname@domain.co.uk>"
$scriptlocation = "C:\Scripts\VeeamFileRestores\AutoFileRestoreScript"
$logfile = ".\Logs\Requests.log"
Set-location -Path $scriptlocation

if ((get-location).path -ne $scriptlocation) {
    Write-Host "ERROR Script not running from correct directory, aborting..." -ForegroundColor Red
    EVENTCREATE /L Application /T ERROR /SO "mycorp Veeam Restore Script" /ID 999 /D "ProcessRestoreRequests.ps1 script run from incorrect location!"
    exit
}

if (!(Test-Path ".\Logs")) {
    New-Item Logs -ItemType Directory
}

$now = Get-Date
if ((Get-Item $logfile).CreationTime -le $now.AddHours(-23)) {
    $oldfile = 'Requests-{0}.log' -f $now.DayOfYear
    $oldfilepath = ".\Logs\$oldfile"
    Remove-Item -Path $oldfilepath -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    Copy-Item -Path $logfile -Destination $oldfilepath -Force
    Remove-Item -Path $logfile -Force
}

Function Write-ToLog {
    param (
        [Parameter(Position = 0, Mandatory = $true)]$LogMessage
    )
    $logtime = (Get-Date -Format (Get-culture).DateTimeFormat.ShortDatePattern) + " " + (Get-Date -Format (Get-culture).DateTimeFormat.LongTimePattern)
    Write-Output "$logtime - $LogMessage" | Out-File -Append -FilePath $logfile
}

if (!(Get-PSSnapin VeeamPSSnapin -ErrorAction SilentlyContinue)) {
    Add-PSSnapin VeeamPSSnapin -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
}

$now = (get-date).DayOfYear
$LastZ1RepoSyncDay = Get-Content -Path "$scriptlocation\BackupRepositoryLastSyncDay.inf"
if ($now -ne $LastZ1RepoSyncDay) {
    Write-ToLog -LogMessage "First run today, rescanning $BackupRepository repository..."
    Get-VBRBackupRepository -Name $BackupRepository | Sync-VBRBackupRepository
    $now | Out-File -FilePath "$scriptlocation\BackupRepositoryLastSyncDay.inf" -Force -NoNewline
    Write-ToLog -LogMessage "Sleeping for 10 minutes to allow for repository rescan..."
    Start-Sleep -Seconds 600
}

Write-ToLog -LogMessage "Checking for new restore requests..."
if (!(Test-Path ".\RequestQueue")) {
    New-Item RequestQueue -ItemType Directory
}
$restorequeue = (Get-ChildItem .\RequestQueue\RestoreRequest*.req | Sort-Object LastWriteTime)
if (!$restorequeue) {
    Write-ToLog -LogMessage "No new requests found, exiting..."
    exit
}

$requestfile = $restorequeue[0].Name
Write-ToLog -LogMessage "Found $requestfile"
$requestfilepath = $restorequeue[0].versioninfo.filename
$restorerequest = (Import-Csv $requestfilepath -Header VMName, FilePath, SDTicket, BackupDate, Email -Delimiter ";")[0]

if (!$restorerequest.VMName -or !$restorerequest.FilePath - !$restorerequest.SDTicket - !$restorerequest.BackupDate) {
    Write-ToLog -LogMessage "ERROR 1011: Required parameters missing from $requestfile, aborting..."
    Move-Item $requestfilepath -Destination ".\RequestQueue\Failed" -Force
    exit
}

if (!$restorerequest.Email) {
    Write-ToLog -LogMessage "WARNING: No email recipient supplied, using default: $DefaultEmailRecipient"
    $restorerequest.Email = $DefaultEmailRecipient
}

$FilesToRestore = $restorerequest.FilePath
Write-ToLog -LogMessage "Restoring $restorerequest"
$restorejob = Start-Job -ScriptBlock {C:\Scripts\VeeamFileRestores\AutoFileRestoreScript\VeeamFileRestore-auto.ps1 -TargetVM $args[0] -FilesToRestore $args[1] -Reason $args[2] -BackupDate $args[3] -RequestFilename $args[4] -EmailRecipient $args[5]} -ArgumentList $restorerequest.VMName, $restorerequest.FilePath, $restorerequest.SDTicket, $restorerequest.BackupDate, $requestfile, $restorerequest.Email
$restorejob | Wait-Job -Timeout 5400
$restoreresult = $restorejob | Receive-Job
if ($restoreresult[-1] -eq "1000") {
    Write-ToLog -LogMessage "Restore request from $requestfile of $FilesToRestore was successful"
} else {
    Switch ($restoreresult[-1]) {
        1001 {Write-ToLog -LogMessage "ERROR 1001: Invalid date"}
        1002 {Write-ToLog -LogMessage "ERROR 1002: vSphere password not detected"}
        1003 {Write-ToLog -LogMessage "ERROR 1003: Guest VM password not detected"}
        1004 {Write-ToLog -LogMessage "ERROR 1004: Not elevated, vSphere and Veeam cmdlets will fail"}
        1005 {Write-ToLog -LogMessage "ERROR 1005: Either too many jobs or no jobs found"}
        1006 {Write-ToLog -LogMessage "ERROR 1006: File not found in backup"}
        1007 {Write-ToLog -LogMessage "ERROR 1007: VM not detected in vSphere"}
        1008 {Write-ToLog -LogMessage "ERROR 1008: Error copying file to VM"}
        default {Write-ToLog -LogMessage "ERROR: Unknown Error. Check restores.log"}
    }
    if (!(Test-Path ".\RequestQueue\Failed")) {
        New-Item .\RequestQueue\Failed -ItemType Directory
    }
    Write-ToLog -LogMessage "Restore of $FilesToRestore failed, archiving request to failed directory"
    Move-Item $requestfilepath -Destination ".\RequestQueue\Failed" -Force
    $LogEmailRecipient = $restorerequest.Email
    Write-ToLog -LogMessage "Sending email notification of restore failure to $LogEmailRecipient"
    $SDTicketnumber = $restorerequest.SDTicket
    Send-MailMessage -Body "ERROR: Failed to process restore request in $requestfile, see log files for more details. Please update ticket number $SDTicketnumber." -From $EmailSender -SmtpServer $SMTPServerAddress -Subject "ERROR: Restore for ticket $SDTicketnumber failed" -To $restorerequest.Email
    exit
}

Write-ToLog -LogMessage "Archiving request file $requestfile"
if (!(Test-Path ".\RequestQueue\Done")) {
    New-Item .\RequestQueue\Done -ItemType Directory
}
Move-Item $requestfilepath -Destination ".\RequestQueue\Done" -Force
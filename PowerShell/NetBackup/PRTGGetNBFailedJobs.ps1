<#########################################################################################

 File Name: PRTGNBFailedJobs.ps1

 Changelog
 26/08/2016 - v1.0 Initial Version

 The script is run from the PRTG probe machine, all other resources are used in a remote session
 on the NetBackup server.

 The script requires the NetBackupPS.psm1 PowerShell module available on the NETBACKUP SERVER
 from the default location.
 64bit default location: C:\Program Files\WindowsPowerShell\Modules\NetBackupPS\NetBackupPS.psm1
 32bit default location: C:\Program Files (x86)\WindowsPowerShell\Modules\NetBackupPS\NetBackupPS.psm1

 IMPORTANT: The NetBackupPS module requires the NetBackup admin tools in the default directories on
 the NETBACKUP SERVER:
 C:\Program Files\Veritas\NetBackup\bin\admincmd\
 C:\Program Files\Veritas\NetBackup\bin\goodies\

 USAGE: .\PRTGGetNBFailedJobs.ps1 -NBServer server.domain.local

#########################################################################################>

param([string[]]$NBServer)

$PRTGUser = "EPCREGISTER\PRTGUser"
$PRTGUserPWFile = "D:\PRTG Network Monitor\Custom Sensors\EXE\Credentials\PRTGUser.txt"

#Setting up credentials
if ((Test-Path $PRTGUserPWFile) -eq "True") {
    $PRTGUserPW = Get-Content $PRTGUserPWFile | ConvertTo-SecureString
    $PRTGUserCred = New-Object -Typename System.Management.Automation.PSCredential($PRTGUser, $PRTGUserPW)
} else {
    Write-Output "1:Error missing password file"
    exit
}


# Define function to run on remote NetBackup server
Function Get-FailedNetBackupJobs {
    if (!(Get-Module NetBackupPS -ErrorAction SilentlyContinue)) {
        Import-Module NetBackupPS -WarningAction SilentlyContinue -ErrorAction Stop
    }

    $NBJobStatusAll = Get-NBJobStatus -ListFormat Yes

    # Check each job for a success
    [int]$NBFailedJobs = 0
    Foreach ($NBJobStatus in $NBJobStatusAll) {
        if (($NBJobStatus.Contains("EXIT STATUS 0")) -and ($NBJobStatus.Contains("operation was successfully completed"))) {
            #Write-Host "Job Successful" -ForegroundColor Green
            continue
        } else {
            #Write-Host "Job failed!" -ForegroundColor Red
            $NBFailedJobs++
        }

    }
    $NBFailedJobs
}

# Create and check remote PS session to NetBackup server
$NBSession = New-PSSession -Authentication CredSSP –Credential $PRTGUserCred -ComputerName $NBServer
if ($NBSession) {
    [int]$NBFailures = Invoke-Command -Session $NBSession -ScriptBlock ${function:Get-FailedNetBackupJobs}
    $NBSession | Remove-PSSession
} else {
    Write-Output "1:Error connecting to NetBackup Server!"
    exit
}

# Report failed or success status to PRTG
if ($NBFailures -eq "0") {
    Write-Output $NBFailures":All jobs successful"
} else {
    Write-Output $NBFailures":Jobs have failed!"
}

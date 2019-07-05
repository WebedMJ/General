<#########################################################################################

 File Name: NBFailedJobs.ps1

 Changelog
 26/08/2016 - v1.0 Initial Version

 The script requires the NetBackupPS.psm1 PowerShell module available from the default location.
 64bit default location: C:\Program Files\WindowsPowerShell\Modules\NetBackupPS\NetBackupPS.psm1
 32bit default location: C:\Program Files (x86)\WindowsPowerShell\Modules\NetBackupPS\NetBackupPS.psm1

 IMPORTANT: The NetBackupPS module requires the NetBackup admin tools in the default directories:
 C:\Program Files\Veritas\NetBackup\bin\admincmd\
 C:\Program Files\Veritas\NetBackup\bin\goodies\

#########################################################################################>

if (!(Get-Module NetBackupPS -ErrorAction SilentlyContinue)) {
    Import-Module NetBackupPS -WarningAction SilentlyContinue -ErrorAction Stop
}

$NBJobStatusAll = Get-NBJobStatus -ListFormat Yes

# Check each job for a success
[int]$NBFailedJobs = 0
Foreach ($NBJobStatus in $NBJobStatusAll) {
    if (($NBJobStatus.Contains("EXIT STATUS 0")) -and ($NBJobStatus.Contains("operation was successfully completed"))) {
        continue
    } else {
        $NBFailedJobs++
    }
}

# Report failed or success status to PRTG
if ($NBFailedJobs -eq "0") {
    Write-Output $NBFailedJobs":All jobs successful"
} else {
    Write-Output $NBFailedJobs":Jobs have failed!"
}
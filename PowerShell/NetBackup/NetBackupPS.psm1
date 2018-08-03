<#########################################################################################

 File Name: NetBackupPS.psm1

 IMPORTANT: The NetBackupPS module requires the NetBackup admin tools in the default directories:
 C:\Program Files\Veritas\NetBackup\bin\admincmd\
 C:\Program Files\Veritas\NetBackup\bin\goodies\

 To load in 64bit PS from anywhere, place here C:\Program Files\WindowsPowerShell\Modules\NetBackupPS\NetBackupPS.psm1
 To load in 32bit PS from anywhere, place here C:\Program Files (x86)\WindowsPowerShell\Modules\NetBackupPS\NetBackupPS.psm1

 Changelog
 26/08/2016 - V1.0 Initial Version

#########################################################################################>

Function Get-NBPolicy {
    <#
    .SYNOPSIS
    Command to retrieve Netbackup Policy details on local server.
    Run without parameters for a list of policy names.
    .DESCRIPTION
    Makes use of C:\Program Files\Veritas\NetBackup\bin\admincmd\bppllist.exe.
    .EXAMPLE
    Get-NBPolicy -Policy CECR_Live

    This example retrieves the details for all the policy named CECR_Live.
    .PARAMETER Policy
    The name of the policy to retreive further details for.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $False,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $False,
            HelpMessage = 'Policy Name:')]
        [string[]]$Policy
    )
    if (!$Policy -and (Test-Path "C:\Program Files\Veritas\NetBackup\bin\admincmd\bppllist.exe")) {
        & "C:\Program Files\Veritas\NetBackup\bin\admincmd\bppllist.exe"
    } elseif (Test-Path "C:\Program Files\Veritas\NetBackup\bin\admincmd\bppllist.exe") {
        & "C:\Program Files\Veritas\NetBackup\bin\admincmd\bppllist.exe" $Policy -L
    } else {
        Write-Host "`r`nFATAL ERROR: Netbackup admin util bppllist.exe not detected!`r`n" -ForegroundColor Red
    }
}

Function Get-NBJobStatus {
    <#
    .SYNOPSIS
    Command to retrieve the status of Netbackup jobs on local server.
    Run without parameters to check all jobs.
    .DESCRIPTION
    Makes use of C:\Program Files\Veritas\NetBackup\bin\admincmd\bperror.exe.
    .EXAMPLE
    Get-NBJobStatus -ClientName regoemuat1

    This example retrieves the status of jobs run for client "regoemuat1".
    .EXAMPLE
    Get-NBJobStatus -ClientName regoemuat1 -ListFormat Yes

    This example retrieves the status of jobs run for client "regoemuat1" and displays the results as a list.
    .PARAMETER ClientName
    The name of the client to retrieve job status for.
    .PARAMETER ListFormat
    Specifies whether to display the result in list format.  The default is table format.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $False,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $False,
            HelpMessage = 'Client Name:')]
        [string[]]$ClientName,

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $False,
            ValueFromPipelineByPropertyName = $False,
            HelpMessage = 'List Format Yes/No?')]
        [ValidateSet("Yes", "No")]
        [string[]]$ListFormat = "No"
    )
    if ($ListFormat -eq "No") {
        if (!$ClientName -and (Test-Path "C:\Program Files\Veritas\NetBackup\bin\admincmd\bperror.exe")) {
            & "C:\Program Files\Veritas\NetBackup\bin\admincmd\bperror.exe" -backstat -U
        } elseif (Test-Path "C:\Program Files\Veritas\NetBackup\bin\admincmd\bperror.exe") {
            & "C:\Program Files\Veritas\NetBackup\bin\admincmd\bperror.exe" -client $ClientName -backstat -U
        } else {
            Write-Host "`r`nFATAL ERROR: Netbackup admin util bperror.exe not detected!`r`n" -ForegroundColor Red
        }
    } else {
        if (!$ClientName -and (Test-Path "C:\Program Files\Veritas\NetBackup\bin\admincmd\bperror.exe")) {
            & "C:\Program Files\Veritas\NetBackup\bin\admincmd\bperror.exe" -backstat -l
        } elseif (Test-Path "C:\Program Files\Veritas\NetBackup\bin\admincmd\bperror.exe") {
            & "C:\Program Files\Veritas\NetBackup\bin\admincmd\bperror.exe" -client $ClientName -backstat -l
        } else {
            Write-Host "`r`nFATAL ERROR: Netbackup admin util bperror.exe not detected!`r`n" -ForegroundColor Red
        }
    }
}
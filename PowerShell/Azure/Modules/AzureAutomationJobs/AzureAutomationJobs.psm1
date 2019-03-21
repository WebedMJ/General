<#
.SYNOPSIS
    Module for interacting with Azure Automation using the ARM REST API, with specialised functions for
    WorkDay user provisioning.
    Designed to be invoked from an Azure web app or function app with managed identity enabled.
.DESCRIPTION

.LINK
    https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureAutomationJobs
.NOTES
    Requires managed identity enabled on the app service and IAM permissions configured on the automation account.
#>

function New-AzureAutomationRunbookJob {
    <#
    .SYNOPSIS
        Creates a job for a given runbook with optional parameters.
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureAutomationJobs
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RunbookName,
        [Parameter(Mandatory = $false)]
        [ValidateLength(1, 64)]
        [string]$JobNamePrefix,
        [Parameter(Mandatory = $false)]
        [hashtable]$JobParameters = $null,
        [Parameter(Mandatory = $false)]
        [string]$WorkerGroup = "",
        [Parameter(Mandatory = $true)]
        [string]$SubscriptionId,
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$AutomationAccountName
    )
    $apiVersion = '2017-05-15-preview'
    switch ($PSBoundParameters.ContainsValue($JobNamePrefix)) {
        $true { $JobName = '{0}-{1}' -f $JobNamePrefix, ([guid]::NewGuid() -split '-')[0] }
        Default {$JobName = [guid]::NewGuid().Guid}
    }
    $runbook = [PSCustomObject]@{
        Name = $RunbookName
    }
    switch ([bool]$JobParameters) {
        $true {
            $jobproperties = [PSCustomObject]@{
                runbook    = $runbook
                parameters = $JobParameters
                runOn      = $workergroup
            }
        }
        Default {
            $jobproperties = [PSCustomObject]@{
                runbook = $runbook
                runOn   = $workergroup
            }
        }
    }
    $jobdetails = [PSCustomObject]@{
        properties = $jobproperties
    }
    $jobbody = $jobdetails | ConvertTo-Json
    $uripath = 'subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Automation/automationAccounts/{2}/jobs/{3}' -f
    $subscriptionId, $resourceGroupName, $automationAccountName, $JobName
    $uriquery = '?api-version={0}' -f $apiVersion
    $uri = [System.UriBuilder]::new('https', 'management.azure.com', '443', $uripath, $uriquery)
    $startjobsplat = @{
        Headers     = Get-AzureRESTtoken
        Uri         = $uri.Uri
        Method      = 'Put'
        ErrorAction = 'Stop'
        Body        = $jobbody
    }
    $startjobresponse = Invoke-RestMethod @startjobsplat
    return $startjobresponse
}

function Get-AzureAutomationRunbookJobs {
    <#
    .SYNOPSIS
        Gets the list of jobs for the given runbooks, defaults to first 1000.
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureAutomationJobs
    #>
    [CMDLetBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$RunbookName,
        [Parameter(Mandatory = $true)]
        [string]$SubscriptionId,
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$AutomationAccountName,
        # Get all jobs, default is just the first page from the API.
        [Switch]$All
    )
    $apiVersion = '2017-05-15-preview'
    [PSCustomObject]$getjobsresponse = @()
    foreach ($Runbook in $RunbookName) {
        [System.String]$jobsnextlink = ''
        $filter = "properties/runbook/name eq '{0}'" -f $Runbook
        $uripath = 'subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Automation/automationAccounts/{2}/jobs' -f
        $SubscriptionId, $ResourceGroupName, $AutomationAccountName
        $uriquery = '?$filter={0}&api-version={1}' -f $filter, $apiVersion
        $builturi = [System.UriBuilder]::new('https', 'management.azure.com', '443', $uripath, $uriquery)
        [uri]$uri = $builturi.Uri
        do {
            $getjobssplat = @{
                Headers     = Get-AzureRESTtoken
                Uri         = $uri
                Method      = 'Get'
                ErrorAction = 'Stop'
            }
            $getjobsresponse += Invoke-RestMethod @getjobssplat
            if ($All) {
                $jobsnextlink = $getjobsresponse.nextLink
                [uri]$uri = $jobsnextlink
            }
        } while (![string]::IsNullOrEmpty($jobsnextlink))
    }
    return $getjobsresponse
}

function Get-AzureAutomationRunbookJobDetails {
    <#
    .SYNOPSIS
        Gets the details of a given runbook job.
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureAutomationJobs
    #>
    [CMDLetBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$JobName,
        [Parameter(Mandatory = $true)]
        [string]$subscriptionId,
        [Parameter(Mandatory = $true)]
        [string]$resourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$automationAccountName
    )
    $apiVersion = '2017-05-15-preview'
    $uripath = 'subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Automation/automationAccounts/{2}/jobs/{3}' -f
    $subscriptionId, $resourceGroupName, $automationAccountName, $JobName
    $uriquery = '?api-version={0}' -f $apiVersion
    $builturi = [System.UriBuilder]::new('https', 'management.azure.com', '443', $uripath, $uriquery)
    [uri]$uri = $builturi.Uri
    $getjobssplat = @{
        Headers     = Get-AzureRESTtoken
        Uri         = $uri
        Method      = 'Get'
        ErrorAction = 'Stop'
    }
    $getjobsresponse = Invoke-RestMethod @getjobssplat
    return $getjobsresponse
}

function Get-AzureAutomationJobOutput {
    <#
    .SYNOPSIS
        Gets the output of a given job.
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureAutomationJobs
    #>
    [CMDLetBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$JobName,
        [Parameter(Mandatory = $true)]
        [string]$subscriptionId,
        [Parameter(Mandatory = $true)]
        [string]$resourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$automationAccountName
    )
    $apiVersion = '2017-05-15-preview'
    $uripath = 'subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Automation/automationAccounts/{2}/jobs/{3}/output' -f
    $subscriptionId, $resourceGroupName, $automationAccountName, $JobName
    $uriquery = '?api-version={0}' -f $apiVersion
    $builturi = [System.UriBuilder]::new('https', 'management.azure.com', '443', $uripath, $uriquery)
    [uri]$uri = $builturi.Uri
    $getjobssplat = @{
        Headers     = Get-AzureRESTtoken
        Uri         = $uri
        Method      = 'Get'
        ErrorAction = 'Stop'
    }
    $getjobsresponse = Invoke-RestMethod @getjobssplat
    return $getjobsresponse
}
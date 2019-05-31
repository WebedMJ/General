<#
.SYNOPSIS
    Module for interacting with ACI using the ARM REST API.
    Designed to be invoked from an Azure web/function app or Azure Automation.
.DESCRIPTION

.LINK
    https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureACIREST
.NOTES
    Requires managed identity enabled on the app service or an automationrunas account.
#>
function Get-ACIContainerGroups {
    <#
    .SYNOPSIS
        Gets the list of ACI container groups in a subscription and/or resource group.
    .LINK
        https://github.com/WebedMJ/General/tree/master/PowerShell/Azure/Modules/AzureACIREST
    #>
    [CMDLetBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SubscriptionId,
        [Parameter(Mandatory = $false)]
        [string]$ResourceGroupName,
        # Get all jobs, default is just the first page from the API.
        [Parameter(Mandatory = $false)]
        [Switch]$All,
        [Parameter(Mandatory = $false)]
        [Switch]$AzureAutomationRunbook
    )
    $apiVersion = '2018-10-01'
    [PSCustomObject]$response = @()
    [System.String]$jobsnextlink = ''
    switch ($ResourceGroupName) {
        { [bool]$PSItem -eq $true } {
            $uripath = 'subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.ContainerInstance/containerGroups' -f
            $SubscriptionId, $ResourceGroupName
        }
        Default {
            $uripath = 'subscriptions/{0}/providers/Microsoft.ContainerInstance/containerGroups' -f
            $SubscriptionId
        }
    }
    $uriquery = '?&api-version={0}' -f $apiVersion
    $builturi = [System.UriBuilder]::new('https', 'management.azure.com', '443', $uripath, $uriquery)
    [uri]$uri = $builturi.Uri
    do {
        switch ($AzureAutomationRunbook) {
            { [bool]$PSItem -eq $true } {
                $getjobssplat = @{
                    Headers     = Get-AzureRESTtoken -AzureResource 'ARM' -AzureIdentity 'AzureAutomationRunAs'
                    Uri         = $uri
                    Method      = 'Get'
                    ErrorAction = 'Stop'
                }
            }
            Default {
                $getjobssplat = @{
                    Headers     = Get-AzureRESTtoken -AzureResource 'ARM'
                    Uri         = $uri
                    Method      = 'Get'
                    ErrorAction = 'Stop'
                }
            }
        }
        $response += Invoke-RestMethod @getjobssplat
        if ($All) {
            $jobsnextlink = $response.nextLink
            [uri]$uri = $jobsnextlink
        }
    } while (![string]::IsNullOrEmpty($jobsnextlink))
    return $response
}

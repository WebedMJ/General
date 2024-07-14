. "$PSScriptRoot\IntuneFirewallRule.ps1"
. "$PSScriptRoot\..\Private\Send-Telemetry.ps1"
. "$PSScriptRoot\..\Private\Use-HelperFunctions.ps1"
. "$PSScriptRoot\..\Private\Strings.ps1"

$ProfileFirewallRuleLimit = 150
# Sends Intune Firewall objects out to the Intune Powershell SDK
# and returns the response to the API call
Function Send-IntuneFirewallRulesPolicy {
    <#
    .SYNOPSIS
    Send firewall rule objects out to Intune

    .DESCRIPTION
    Sends IntuneFirewallRule objects out to the Intune Powershell SDK and returns the response to the API call

    .EXAMPLE
    Get-NetFirewallRule | ConvertTo-IntuneFirewallRule | Send-IntuneFirewallRulesPolicy
    Send-IntuneFirewallRulesPolicy -firewallObjects $randomObjects
    Get-NetFirewallRule -PolicyStore RSOP | ConvertTo-IntuneFirewallRule -splitConflictingAttributes | Send-IntuneFirewallRulesPolicy -migratedProfileName "someCustomName"
    Get-NetFirewallRule -PolicyStore PersistentStore -PolicyStoreSourceType Local | ConvertTo-IntuneFirewallRule -sendConvertTelemetry | Send-IntuneFirewallRulesPolicy -migratedProfileName "someCustomName" -sendIntuneFirewallTelemetry $true

    .PARAMETER firewallObjects the collection of firewall objects to be sent to be processed
    .PARAMETER migratedProfileName an optional argument that represents the prefix for the name of newly created firewall rule profiles

    .NOTES
    While Send-IntuneFirewallRulesPolicy primarily accepts IntuneFirewallRule objects, any object piped into the cmdlet that can be
    called with the ConvertTo-Json cmdlet and represented as a JSON string can be sent to Intune, with the Graph
    performing the validation on the the JSON payload.

    Any attributes that have null or empty string values are filtered out from being sent to Graph. This is because
    the Graph can insert default values when no set values have been placed in the payload.

    Users should authenticate themselves through the SDK first by running Connect-MgGraph, which will then allow
    them to use this cmdlet.

    .LINK
    https://docs.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-windowsfirewallrule?view=graph-rest-beta
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $firewallObjects,

        [Parameter(Mandatory = $false)]
        [String]
        $migratedProfileName = $Strings.SendIntuneFirewallRulesPolicyProfileNameDefault,

        # If this flag is toggled, then telemetry is automatically sent to Microsoft.
        [switch]
        $sendIntuneFirewallTelemetry
    )

    Begin { $firewallArr = @() }

    # We apply a filter that strips objects of their null attributes so that Graph can
    # apply default values in the absence of set values
    Process {
        $object = $_
        $allProperties = $_.PsObject.Properties.Name
        $nonNullProperties = $allProperties.Where( { $null -ne $object.$_ -and $object.$_ -ne '' })
        $firewallArr += $object | Select-Object $nonNullProperties
    }

    End {
        # Split the incoming firewall objects into separate profiles
        $profiles = @()
        $currentProfile = @()
        ForEach ($firewall in $firewallArr) {
            If ($currentProfile.Count -ge $ProfileFirewallRuleLimit) {
                # Arrays may be "unrolled", so we need to enforce no unrolling
                $profiles += , $currentProfile
                $currentProfile = @()
            }
            $currentProfile += $firewall
        }
        If ($currentProfile.Count -gt 0 ) {
            # Arrays may be "unrolled", so we need to enforce no unrolling
            $profiles += , $currentProfile
        }
        $profileNumber = 0

        $remainingProfiles = $profiles.Count
        ForEach ($prof in $profiles) {
            # remainingProfiles is decremented after displaying operation status
            $remainingProfiles = Show-OperationProgress `
                -remainingObjects $remainingProfiles `
                -totalObjects $profiles.Count `
                -activityMessage $Strings.SendIntuneFirewallRulesPolicyProgressStatus

            # Processing a profile
            $NewIntuneObject = @{
                '@odata.type' = '#microsoft.graph.windows10EndpointProtectionConfiguration'
                displayName   = "$migratedProfileName-$profileNumber"
                firewallRules = $prof
            } | ConvertTo-Json -Depth 100
            # $NewIntuneObject = "{
            #     `"@odata.type`": `"#microsoft.graph.windows10EndpointProtectionConfiguration`",
            #     `"displayName`": `"$migratedProfileName-$profileNumber`",
            #     `"firewallRules`": $profileJson,
            #        }"
            If ($PSCmdlet.ShouldProcess($NewIntuneObject, $Strings.SendIntuneFirewallRulesPolicyShouldSendData)) {
                Try {
                    Invoke-MgGraphRequest -Uri 'https://graph.microsoft.com/beta/devicemanagement/deviceconfigurations/' -Method POST -Body $NewIntuneObject
                    # Profile numbers will only increment if they are actually sent to Intune
                    $profileNumber++
                } Catch {
                    # Intune Graph errors are telemetry points that can detect payload mistakes
                    $errorMessage = $_.ToString()
                    Write-Host $errorMessage
                    Throw $Strings.SendIntuneFirewallRulesPolicyException
                }
            }
        }
    }
}
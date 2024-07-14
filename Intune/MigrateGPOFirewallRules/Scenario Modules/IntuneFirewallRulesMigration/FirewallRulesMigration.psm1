# Reads values from the module manifest file
$manifestData=Import-PowerShellDataFile -Path $PSScriptRoot\Intune-prototype-WindowsMDMFirewallRulesMigrationTool.psd1

# Ensure required modules are imported
ForEach ($module in $manifestData["RequiredModules"]) {
    If (!(Get-Module $module)) {
        # Setting to stop will cause a terminating error if the module is not installed on the system
        Import-Module $module -ErrorAction Stop
    }
}

# Port all functions and classes into this module
$Public = @( Get-ChildItem -Path $PSScriptRoot\IntuneFirewallRulesMigration\Public\*.ps1 -ErrorAction SilentlyContinue -Recurse )

# Load each public function into the module
ForEach ($import in @($Public)) {
    Try {
        . $import.fullname
    } Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Exports the cmdlets provided in the module manifest file, other members are not exported
# from the module
ForEach ($cmdlet in $manifestData["CmdletsToExport"]) {
    Export-ModuleMember -Function $cmdlet
}
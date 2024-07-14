# Intune Windows Firewall Rule Migration

This project aims to assist organizations in migrating their existing, in-house firewall rule solutions to Intune.
The project is a suite of PowerShell Cmdlets that can be used to migrate firewall rules. The Cmdlets are extensible so that
organizations may create their own PowerShell scripts for custom firewall policy implementations and
reuse parts of the project to assist in migrating to Intune.

## Project specific notes

This project is primarily developed in PowerShell. This has the benefits of being flexible for organizations relying on many other Cmdlets and also serving as a
reference point to see how they can implement their own export Cmdlets to automate custom firewall rule migration.

Cmdlet development is done as [Script Cmdlets](https://devblogs.microsoft.com/powershell/fun-with-script-Cmdlets/) instead of traditional
Binary Cmdlets developed in C#.

### Project Structure

The project follows a slightly modified project structure pattern that is common in a few PowerShell repositories found online. An example
can be found [here](http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/). Source code is all under the `/src` directory.

## Getting Started

### Operating System

The project has been developed and tested on Windows 10 1903 and with PowerShell Version 5.1.18362.145.

### Dependencies

The project relies on the [Intune PowerShell SDK](https://github.com/Microsoft/Intune-PowerShell-SDK) for submitting Graph API calls, and will require users to [install the SDK](https://github.com/Microsoft/Intune-PowerShell-SDK#getting-started).

### Importing the module

To import the module for each PowerShell session, you need to run `Import-Module`. You can import this project into your current PowerShell session by importing the module psm file:

```PowerShell
Import-Module %ProjectRoot%\src\FirewallRulesMigration.psm1
```

where `%ProjectRoot%` represents the root directory for the project (where this README is stored).

### Unit testing

This project uses [Pester](https://github.com/pester/Pester), a PowerShell unit-testing and mocking framework shipped natively with Windows 10.
While Pester is shipped with Windows 10, it is [best to update the package](https://github.com/pester/Pester#installation), as there are a
few syntax changes found between Pester versions.

To run unit tests for the entire project, you can simply run `Invoke-Pester .` in the `src\Tests` directory.

### Examples

For simple migration purposes for net firewall rules on the host, use this:

```PowerShell
Export-NetFirewallRule
```

Exporting from [Group Policy Object](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/Policy/group-policy-objects) Firewall Rules:

```PowerShell
Export-NetFirewallRule -PolicyStoreSource GroupPolicy
```

Exporting all of [Windows Defender Firewall with Advanced Security](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-firewall/windows-firewall-with-advanced-security) rules:

```PowerShell
Export-NetFirewallRule -PolicyStoreSource All
```

By default, the `Export-NetFirewallRule` will also export all Windows Defender Firewall rules, so the following command also works:

```PowerShell
Export-NetFirewallRule
```

Exporting firewall rules and then importing them into Intune should follow a conventional PowerShell pipeline workflow:

```PowerShell
Export-NetFirewallRule | Send-IntuneFirewallRulesPolicy
```

When the tool encounters unsupported scenarios, an interactive prompt may appear detailing it.
The two most common scenarios are:

- A firewall rule has two of the three or more of `PackageFamilyName`, `ServiceName`, and `FilePath` attributes filled out. Since Windows MDM does not support multiple
of these attributes at once, users will be prompted regarding whether they want to split this firewall rule into multiple firewall rules.
- A firewall rule has an attribute that is known to be incompatible with Intune beforehand. The tool will raise an exception and ask the user if they would like to
send telemetry data to Intune and automatically progress.

Both of these options are supported as switch flags in all export firewall rule Cmdlets:

```PowerShell
Export-NetFirewallRule -PolicyStoreSource GroupPolicy -splitConflictingAttributes -sendExportTelemetry
```

```PowerShell
Export-NetFirewallRule -splitConflictingAttributes -sendExportTelemetry
```

If you would like to customize the prefix provided when migrating firewall rules to [new Intune profiles](https://docs.microsoft.com/en-us/intune/device-profile-create),
you can use the `migratedProfileName` flag:

```PowerShell
Send-IntuneFirewallRulesPolicy -migratedProfileName "foo"
```

#### Advanced Uses

Internally, the export cmdlet `Export-NetFirewallRule` is making a call to `NetSecurity` module Cmdlets and using another cmdlet `ConvertTo-IntuneFirewallRule` to
transform the rules into suitable firewall rule objects. We can take advantage of this to tailor our export data.

The majority of operations will involve the [NetSecurity](https://docs.microsoft.com/en-us/powershell/module/netsecurity/?view=win10-ps) module. Most of the time,
you will use `Get-NetFirewallRule` to query specific firewall rules to process.
Look [here](https://docs.microsoft.com/en-us/powershell/module/netsecurity/Get-NetFirewallRule?view=win10-ps) for more details regarding the command.

If you would like to parse all firewall rules found in [WDFAS](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-firewall/windows-firewall-with-advanced-security), you can leave out the policy store:

```PowerShell
Get-NetFirewallRule | ConvertTo-IntuneFirewallRule | Send-IntuneFirewallRulesPolicy
```

If instead you want to specify just GPO firewall rules to be parsed, you can do the following:

```PowerShell
Get-NetFirewallRule -PolicyStore RSOP | ConvertTo-IntuneFirewallRule | Send-IntuneFirewallRulesPolicy
```

You can combine these with other standard PowerShell Cmdlets for filtering as well:

```PowerShell
Get-NetFirewallRule -PolicyStore RSOP | ConvertTo-IntuneFirewallRule | Where-Object {$_.serviceName -ne "SomeUnwantedService"} | Send-IntuneFirewallRulesPolicy
```

```PowerShell
Get-NetFirewallRule | Where-Object {$_.displayName -match "foo*"} | ConvertTo-IntuneFirewallRule | Send-IntuneFirewallRulesPolicy
```

Or perhaps you would like to see what is being sent to Intune before it's actually ran:

```PowerShell
Get-NetFirewallRule -PolicyStore RSOP | ConvertTo-IntuneFirewallRule | Send-IntuneFirewallRulesPolicy -WhatIf
```

### Telemetry

Telemetry is not enabled by default. When the project encounters a firewall rule that is currently incompatible with Intune,
an error message will be shown to you. You have the option of sending this error message to the Intune team at Microsoft to help
us refine the product.

If you would like to automatically send telemetry to Microsoft, you can pass the `-sendExportTelemetry` flag to any of the export Cmdlets.

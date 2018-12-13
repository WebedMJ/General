$MFAReport = Get-MsolUser -all | Select-Object DisplayName, UserPrincipalName, @{
    Name = "Enabled";
    Expression = {
        !$_.BlockCredential
    }
}, isLicensed, @{
    Name       = "MFA Status";
    Expression = {
        if ( $_.StrongAuthenticationRequirements.State -ne $null) {
            $_.StrongAuthenticationRequirements.State
        } else {
            "Disabled"
        }}}, @{
        Name       = "License";
        Expression = {$_.Licenses.AccountSkuId}
        }
Get-MsolUser -all | Select-Object DisplayName, UserPrincipalName, @{
    Name       = "MFA Status";
    Expression = {
        if ( $_.StrongAuthenticationRequirements.State -ne $null) {
            $_.StrongAuthenticationRequirements.State
        } else {
            "Disabled"
        }}
}
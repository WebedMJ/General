[int]$expirydays = "365"
# Assumes session is logged in to Azure...
$certs = Get-AzureKeyVaultCertificate -VaultName "MyVault" | Select-Object Name, EXPIRES | Where-Object expires -lt (Get-Date).AddDays($expirydays)
$webhook = '<URL>'

# See O365 groups card reference: https://docs.microsoft.com/en-us/outlook/actionable-messages/card-reference
# Generating facts object for card section
$facts = foreach ($cert in $certs) {
    [pscustomobject]@{
        Name  = $cert.Name
        Value = $cert.Expires.ToShortDateString()
    }
}

# Generating card object
$card = [pscustomobject]@{
    '@type'    = 'MessageCard'
    '@context' = 'http://schema.org/extensions'
    Summary    = 'Certificate Expiry Card'
    title      = 'Expiring Certificates'
    sections   = @([pscustomobject]@{
            text  = "These certificates expire within the next $expirydays days:"
            facts = $facts
        })
}

$cardjson = $card | ConvertTo-Json -Depth 4
Invoke-WebRequest -Uri $webhook -ContentType "application/json" -Method POST -Body $cardjson

<#
Good Example of payload...
{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "Summary": "Certificate Expiry Card",
    "title": "Expiring Certificates",
    "sections": [
        {
            "text": "These certificates expire within the next 365 days:",
            "facts": [
                {
                    "Name": "cert",
                    "Value": "\/Date(1549454400000)\/"
                },
                {
                    "Name": "tessl",
                    "Value": "\/Date(1549454400000)\/"
                }
            ]
        }
    ]
}
#>
# Parameter help description
param (
    [Parameter(Position = 0)]
    [string]$fqdn = 'defaultservername',
    [Parameter(Position = 1)]
    [PSCredential]$credential = $credentialobjectalreadyinsession
)
$sessionOptionsTimeout = 180000
$so = New-PSSessionOption -OperationTimeout $sessionOptionsTimeout -IdleTimeout $sessionOptionsTimeout -OpenTimeout $sessionOptionsTimeout;
$connectionUri = "http://$fqdn/powershell?serializationLevel=Full"
$session = New-PSSession -ConnectionURI "$connectionUri" -ConfigurationName Microsoft.Exchange -SessionOption $so -Authentication Kerberos -Credential $credential -erroraction silentlycontinue -AllowRedirection
Import-PSSession $session
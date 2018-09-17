# INCOMPLETE, WORK IN PROGRESS
# https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key
# http://blog.einbu.no/2009/08/authenticating-against-azure-table-storage/
<#
GET

application/xml
Mon, 24 Aug 2009 22:08:56 GMT
/myaccount/mytable
============
StringToSign = VERB + "\n" +
               Content-MD5 + "\n" +
               Content-Type + "\n" +
               Date + "\n" +
               CanonicalizedResource;
#>
# Authorization: SharedKey myaccount:bo***********************I=

$Key = "<storagekey>"
$Verb = "GET"
$account = "<storageaccountname>"
$table = "<tablename>"
$authtype = "SharedKey" # or SharedKeyLite ???
$dateTime = [DateTime]::UtcNow.ToString("r")

Add-Type -AssemblyName System.Web

# generate authorization key
$hmacSha256 = New-Object System.Security.Cryptography.HMACSHA256
$hmacSha256.Key = [System.Convert]::FromBase64String($key)

# create authorization header
# None of these work yet....
# $tablesigstring = "$($verb.ToLowerInvariant())`n`n`n$($dateTime.ToLowerInvariant())`n/$($account.ToLowerInvariant())/$($table.ToLowerInvariant())"
$tablesigstring = $dateTime.ToLowerInvariant() + "\n/" + $account.ToLowerInvariant() + "/Tables" # + $table.ToLowerInvariant()
# $tablesigstring = "$($dateTime.ToLowerInvariant())`n/$($account.ToLowerInvariant())/$($table.ToLowerInvariant())"

$tablehashsigstring = $hmacSha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($tablesigstring))
$tablesignature = [System.Convert]::ToBase64String($tablehashsigstring);
$authstring = '{0} {1}:{2}' -f $authtype,$account,$tablesignature
# $authHeader = [System.Web.HttpUtility]::UrlEncode($authstring) # maybe use instead for authstring in header below?

# Query table example...
$tableEndpoint = "https://<storageaccountname>.table.core.windows.net/<Table>"
$header = @{
    Authorization=$authstring
    "x-ms-date"=$dateTime
}
$response = Invoke-RestMethod -Uri $tableEndpoint -Method Get -Headers $header

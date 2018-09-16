<#
	Source: https://gallery.technet.microsoft.com/scriptcenter/How-to-query-Azure-Cosmos-0a9aa517

	The sample scripts are not supported under any Microsoft standard support
	program or service. The sample scripts are provided AS IS without warranty
	of any kind. Microsoft further disclaims all implied warranties including,
	without limitation, any implied warranties of merchantability or of fitness for
	a particular purpose. The entire risk arising out of the use or performance of
	the sample scripts and documentation remains with you. In no event shall
	Microsoft, its authors, or anyone Else involved in the creation, production, or
	delivery of the scripts be liable for any damages whatsoever (including,
	without limitation, damages for loss of business profits, business interruption,
	loss of business information, or other pecuniary loss) arising out of the use
	of or inability to use the sample scripts or documentation, even If Microsoft
	has been advised of the possibility of such damages
#>

# add necessary assembly
#
Add-Type -AssemblyName System.Web

# generate authorization key
Function Generate-MasterKeyAuthorizationSignature
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory=$true)][String]$verb,
		[Parameter(Mandatory=$true)][String]$resourceLink,
		[Parameter(Mandatory=$true)][String]$resourceType,
		[Parameter(Mandatory=$true)][String]$dateTime,
		[Parameter(Mandatory=$true)][String]$key,
		[Parameter(Mandatory=$true)][String]$keyType,
		[Parameter(Mandatory=$true)][String]$tokenVersion
	)

	$hmacSha256 = New-Object System.Security.Cryptography.HMACSHA256
	$hmacSha256.Key = [System.Convert]::FromBase64String($key)

	$payLoad = "$($verb.ToLowerInvariant())`n$($resourceType.ToLowerInvariant())`n$resourceLink`n$($dateTime.ToLowerInvariant())`n`n"
	$hashPayLoad = $hmacSha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($payLoad))
	$signature = [System.Convert]::ToBase64String($hashPayLoad);

	[System.Web.HttpUtility]::UrlEncode("type=$keyType&ver=$tokenVersion&sig=$signature")
}

# query
Function Query-CosmosDb
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory=$true)][String]$EndPoint,
		[Parameter(Mandatory=$true)][String]$DataBaseId,
		[Parameter(Mandatory=$true)][String]$CollectionId,
		[Parameter(Mandatory=$true)][String]$MasterKey,
		[Parameter(Mandatory=$true)][String]$Query
	)

	$Verb = "POST"
	$ResourceType = "docs";
	$ResourceLink = "dbs/$DatabaseId/colls/$CollectionId"

	$dateTime = [DateTime]::UtcNow.ToString("r")
	$authHeader = Generate-MasterKeyAuthorizationSignature -verb $Verb -resourceLink $ResourceLink -resourceType $ResourceType -key $MasterKey -keyType "master" -tokenVersion "1.0" -dateTime $dateTime
	$queryJson = @{query=$Query} | ConvertTo-Json
	$header = @{authorization=$authHeader;"x-ms-documentdb-isquery"="True";"x-ms-version"="2017-02-22";"x-ms-date"=$dateTime}
	$contentType= "application/query+json"
	$queryUri = "$EndPoint$ResourceLink/docs"

	$result = Invoke-RestMethod -Method $Verb -ContentType $contentType -Uri $queryUri -Headers $header -Body $queryJson

	$result | ConvertTo-Json -Depth 10
}

# fill the target cosmos database endpoint uri, database id, collection id and masterkey
$CosmosDBEndPoint = "https://test.documents.azure.com:443/"
$DatabaseId = "StudentsDB"
$CollectionId = "NameCol"
$MasterKey = "Yd************************************************************************************=="

# query string
$Query = "SELECT * FROM Root"

# execute
Query-CosmosDb -EndPoint $CosmosDBEndPoint -DataBaseId $DataBaseId -CollectionId $CollectionId -MasterKey $MasterKey -Query $Query

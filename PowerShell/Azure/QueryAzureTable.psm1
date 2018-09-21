# Module for interacting with Azure Table storage
# Source: https://gcits.com/knowledge-base/use-azure-table-storage-via-powershell-rest-api/
<#
$entity = @{
    RowKey       = "ThisIsARowKey"
    PartitionKey = "HeresAPartitionKey"
    Address      = "123 Sample Street"
    Age          = "24"
}

Getting all table entities
Get-AzureTableEntities -TableName Testing

Creating a new table entity
Invoke-AzureTableUpsertEntity -TableName "Testing" -RowKey $body.RowKey -PartitionKey $body.PartitionKey -entity $body

Merging with an existing table entity
Merge-AzureTableEntity -TableName "Testing" -RowKey $body.RowKey -PartitionKey $body.PartitionKey -entity $body

Deleting an existing table entity
Remove-AzureTableEntity -TableName "Testing" -RowKey $body.RowKey -PartitionKey $body.PartitionKey
#>
# Requires these external vars:
# $storageAccount = "accountname"
# $accesskey = "***key***=="
# $tableName = "tablename"

function Get-AzureTableAuthorization {
    param (
        [Parameter(Mandatory = $true)][String]$storageAccount,
        [Parameter(Mandatory = $true)][String]$accesskey,
        [Parameter(Mandatory = $true)][String]$resource,
        [Parameter(Mandatory = $false)][string]$contenttype = 'application/json'
    )
    $version = "2017-04-17"
    $keytype = "SharedKeyLite"
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
    $hmacsha.key = [Convert]::FromBase64String($accesskey)
    $GMTTime = (Get-Date).ToUniversalTime().toString('R')
    $stringToSign = "{0}{1}/{2}/{3}" -f $GMTTime, "`n", $storageAccount, $resource
    $signature = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($stringToSign))
    $signature = [Convert]::ToBase64String($signature)
    $headers = @{
        "x-ms-version" = $version
        'x-ms-date'    = $GMTTime
        Authorization  = '{0} {1}:{2}' -f $keytype, $storageAccount, $signature
        Accept         = '{0};odata=fullmetadata' -f $contenttype
    }
    return $headers
}

function Get-AzureTableEntities {
    param (
        [Parameter(Mandatory = $true)][String]$TableName
    )
    $resource = $tableName
    $table_url = "https://$storageAccount.table.core.windows.net/$resource"
    $headers = Get-AzureTableAuthorization -storageAccount $storageAccount -accesskey $accesskey -resource $resource
    $item = Invoke-RestMethod -Method GET -Uri $table_url -Headers $headers -ContentType application/json
    return $item.value
}

function Invoke-AzureTableUpsertEntity {
    param (
        [Parameter(Mandatory = $true)][String]$TableName,
        [Parameter(Mandatory = $true)][String]$PartitionKey,
        [Parameter(Mandatory = $true)][String]$RowKey,
        [Parameter(Mandatory = $true)][hashtable]$entity
    )
    $resource = "$TableName(PartitionKey='$PartitionKey',RowKey='$Rowkey')"
    $table_url = "https://$storageAccount.table.core.windows.net/$resource"
    $body = $entity | ConvertTo-Json
    $contenttype = 'application/json'
    $headers = Get-AzureTableAuthorization -storageAccount $storageAccount -accesskey $accesskey -resource $resource
    Invoke-RestMethod -Method PUT -Uri $table_url -Headers $headers -Body $body -ContentType $contenttype
}

<#
function MergeTableEntity($TableName, $PartitionKey, $RowKey, $entity) {
    $version = "2017-04-17"
    $resource = "$tableName(PartitionKey='$PartitionKey',RowKey='$Rowkey')"
    $table_url = "https://$storageAccount.table.core.windows.net/$resource"
    $GMTTime = (Get-Date).ToUniversalTime().toString('R')
    $stringToSign = "$GMTTime`n/$storageAccount/$resource"
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
    $hmacsha.key = [Convert]::FromBase64String($accesskey)
    $signature = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($stringToSign))
    $signature = [Convert]::ToBase64String($signature)
    $body = $entity | ConvertTo-Json
    $headers = @{
        'x-ms-date'      = $GMTTime
        Authorization    = "SharedKeyLite " + $storageAccount + ":" + $signature
        "x-ms-version"   = $version
        Accept           = "application/json;odata=minimalmetadata"
        'If-Match'       = "*"
        'Content-Length' = $body.length
    }
    $item = Invoke-RestMethod -Method MERGE -Uri $table_url -Headers $headers -ContentType application/json -Body $body

}

function DeleteTableEntity($TableName, $PartitionKey, $RowKey) {
    $version = "2017-04-17"
    $resource = "$tableName(PartitionKey='$PartitionKey',RowKey='$Rowkey')"
    $table_url = "https://$storageAccount.table.core.windows.net/$resource"
    $GMTTime = (Get-Date).ToUniversalTime().toString('R')
    $stringToSign = "$GMTTime`n/$storageAccount/$resource"
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
    $hmacsha.key = [Convert]::FromBase64String($accesskey)
    $signature = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($stringToSign))
    $signature = [Convert]::ToBase64String($signature)
    $headers = @{
        'x-ms-date'    = $GMTTime
        Authorization  = "SharedKeyLite " + $storageAccount + ":" + $signature
        "x-ms-version" = $version
        Accept         = "application/json;odata=minimalmetadata"
        'If-Match'     = "*"
    }
    $item = Invoke-RestMethod -Method DELETE -Uri $table_url -Headers $headers -ContentType application/http

}
#>
# WIP, not working...
function Merge-AzureTableEntity {
    param (
        [Parameter(Mandatory = $true)][String]$TableName,
        [Parameter(Mandatory = $true)][String]$PartitionKey,
        [Parameter(Mandatory = $true)][String]$RowKey,
        [Parameter(Mandatory = $true)][hashtable]$entity
    )
    $resource = "$TableName(PartitionKey='$PartitionKey',RowKey='$Rowkey')"
    $table_url = "https://$storageAccount.table.core.windows.net/$resource"
    $body = $entity | ConvertTo-Json
    $contenttype = 'application/json'
    $headers = Get-AzureTableAuthorization -storageAccount $storageAccount -accesskey $accesskey -resource $resource
    Invoke-RestMethod -Method MERGE -Uri $table_url -Headers $headers -ContentType $contenttype -Body $body
}

# WIP, not working...
function Remove-AzureTableEntity {
    param (
        [Parameter(Mandatory = $true)][String]$TableName,
        [Parameter(Mandatory = $true)][String]$PartitionKey,
        [Parameter(Mandatory = $true)][String]$RowKey
    )
    $resource = "$TableName(PartitionKey='$PartitionKey',RowKey='$Rowkey')"
    $table_url = "https://$storageAccount.table.core.windows.net/$resource"
    $contenttype = 'application/http'
    $headers = Get-AzureTableAuthorization -storageAccount $storageAccount -accesskey $accesskey -resource $resource -contenttype $contenttype
    Invoke-RestMethod -Method DELETE -Uri $table_url -Headers $headers -ContentType $contenttype
}
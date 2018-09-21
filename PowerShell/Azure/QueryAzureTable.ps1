# $storageAccount = "accountname"
# $accesskey = "***key***=="
# $tableName = "tablename"

# Source: https://gcits.com/knowledge-base/use-azure-table-storage-via-powershell-rest-api/

function Get-AzureTableAuthorization {
    param (
        [Parameter(Mandatory = $true)][String]$storageAccount,
        [Parameter(Mandatory = $true)][String]$accesskey,
        [Parameter(Mandatory = $true)][String]$resource
    )
    $version = "2017-04-17"
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
    $hmacsha.key = [Convert]::FromBase64String($accesskey)
    $GMTTime = (Get-Date).ToUniversalTime().toString('R')
    $stringToSign = "{0}{1}/{2}/{3}" -f $GMTTime, "`n", $storageAccount, $resource
    $signature = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($stringToSign))
    $signature = [Convert]::ToBase64String($signature)
    $headers = @{
        "x-ms-version" = $version
        'x-ms-date'    = $GMTTime
        Authorization  = 'SharedKeyLite {0}:{1}' -f $storageAccount, $signature
        Accept         = "application/json;odata=fullmetadata"
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
        [Parameter(Mandatory = $true)][String]$entity
    )
    $resource = "$tableName(PartitionKey='$PartitionKey',RowKey='$Rowkey')"
    $table_url = "https://$storageAccount.table.core.windows.net/$resource"
    $body = $entity | ConvertTo-Json
    $headers = Get-AzureTableAuthorization -storageAccount $storageAccount -accesskey $accesskey -resource $resource
    Invoke-RestMethod -Method PUT -Uri $table_url -Headers $headers -Body $body -ContentType application/json
}

function Merge-AzureTableEntity {
    param (
        [Parameter(Mandatory = $true)][String]$TableName,
        [Parameter(Mandatory = $true)][String]$PartitionKey,
        [Parameter(Mandatory = $true)][String]$RowKey,
        [Parameter(Mandatory = $true)][String]$entity
    )
    $resource = "$tableName(PartitionKey='$PartitionKey',RowKey='$Rowkey')"
    $table_url = "https://$storageAccount.table.core.windows.net/$resource"
    $body = $entity | ConvertTo-Json
    $headers = Get-AzureTableAuthorization -storageAccount $storageAccount -accesskey $accesskey -resource $resource
    Invoke-RestMethod -Method MERGE -Uri $table_url -Headers $headers -ContentType application/json -Body $body

}

function Remove-AzureTableEntity {
    param (
        [Parameter(Mandatory = $true)][String]$TableName,
        [Parameter(Mandatory = $true)][String]$PartitionKey,
        [Parameter(Mandatory = $true)][String]$RowKey
    )
    $resource = "$tableName(PartitionKey='$PartitionKey',RowKey='$Rowkey')"
    $table_url = "https://$storageAccount.table.core.windows.net/$resource"
    $headers = Get-AzureTableAuthorization -storageAccount $storageAccount -accesskey $accesskey -resource $resource
    Invoke-RestMethod -Method DELETE -Uri $table_url -Headers $headers -ContentType application/http
}


$body = @{
    RowKey       = "ThisIsARowKey"
    PartitionKey = "HeresAPartitionKey"
    Address      = "123 Sample Street"
    Age          = "24"
}

Write-Host "Getting all table entities"
Get-AzureTableEntities -TableName Testing

Write-Host "Creating a new table entity"
Invoke-AzureTableUpsertEntity -TableName "Testing" -RowKey $body.RowKey -PartitionKey $body.PartitionKey -entity $body

Write-Host "Merging with an existing table entity"
Merge-AzureTableEntity -TableName "Testing" -RowKey $body.RowKey -PartitionKey $body.PartitionKey -entity $body

Write-Host "Deleting an existing table entity"
Remove-AzureTableEntity -TableName "Testing" -RowKey $body.RowKey -PartitionKey $body.PartitionKey
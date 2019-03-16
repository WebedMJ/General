# Module for interacting with Azure Table storage
# Super helpful source: https://gcits.com/knowledge-base/use-azure-table-storage-via-powershell-rest-api/
# Make sure PowerShell session is using TLS 1.2!

function Get-AzureTableAuthorization {
    param (
        [Parameter(Mandatory = $true)][String]$StorageAccount,
        [Parameter(Mandatory = $true)][String]$AccessKey,
        [Parameter(Mandatory = $true)][String]$Resource,
        [Parameter(Mandatory = $false)][string]$ContentType = 'application/json'
    )
    $version = '2017-04-17'
    $keytype = 'SharedKeyLite'
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256
    $hmacsha.key = [Convert]::FromBase64String($AccessKey)
    $GMTTime = (Get-Date).ToUniversalTime().toString('R')
    $StringToSign = '{0}{1}/{2}/{3}' -f $GMTTime, "`n", $StorageAccount, $Resource
    $signature = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($StringToSign))
    $signature = [Convert]::ToBase64String($signature)
    $headers = @{
        'x-ms-version' = $version
        'x-ms-date'    = $GMTTime
        Authorization  = '{0} {1}:{2}' -f $keytype, $StorageAccount, $signature
        Accept         = '{0};odata=fullmetadata' -f $ContentType
    }
    return $headers
}

function Get-AzureTableEntities {
    param (
        [Parameter(Mandatory = $true)][String]$TableName,
        [Parameter(Mandatory = $true)][String]$StorageAccount,
        [Parameter(Mandatory = $true)][String]$AccessKey
    )
    $resource = $TableName
    $table_url = [System.UriBuilder]::new('https', "$StorageAccount.table.core.windows.net", '443', $resource, '')
    $headers = Get-AzureTableAuthorization -StorageAccount $StorageAccount -AccessKey $AccessKey -Resource $resource
    try {
        $response = Invoke-RestMethod -Method GET -Uri $table_url.Uri.AbsoluteUri -Headers $headers -ContentType application/json
    } catch {
        return $Error[0]
        exit 1
    }
    return $response.value
}

function Add-AzureTableEntity {
    param (
        [Parameter(Mandatory = $true)][String]$TableName,
        [Parameter(Mandatory = $true)][String]$PartitionKey,
        [Parameter(Mandatory = $true)][String]$RowKey,
        [Parameter(Mandatory = $true)][hashtable]$Entity,
        [Parameter(Mandatory = $true)][String]$StorageAccount,
        [Parameter(Mandatory = $true)][String]$AccessKey
    )
    $resource = "{0}(PartitionKey='{1}',RowKey='{2}')" -f $TableName, $PartitionKey, $Rowkey
    $table_url = [System.UriBuilder]::new('https', "$StorageAccount.table.core.windows.net", '443', $resource, '')
    $body = $Entity | ConvertTo-Json
    $ContentType = 'application/json'
    $headers = Get-AzureTableAuthorization -StorageAccount $StorageAccount -Accesskey $AccessKey -Resource $resource
    try {
        $response = Invoke-RestMethod -Method PUT -Uri $table_url.Uri.AbsoluteUri -Headers $headers -Body $body -ContentType $ContentType
    } catch {
        return $Error[0]
        exit 1
    }
}

function Merge-AzureTableEntity {
    param (
        [Parameter(Mandatory = $true)][String]$TableName,
        [Parameter(Mandatory = $true)][String]$PartitionKey,
        [Parameter(Mandatory = $true)][String]$RowKey,
        [Parameter(Mandatory = $true)][hashtable]$Entity,
        [Parameter(Mandatory = $true)][String]$StorageAccount,
        [Parameter(Mandatory = $true)][String]$AccessKey
    )
    $resource = "{0}(PartitionKey='{1}',RowKey='{2}')" -f $TableName, $PartitionKey, $Rowkey
    $table_url = [System.UriBuilder]::new('https', "$StorageAccount.table.core.windows.net", '443', $resource, '')
    $body = $Entity | ConvertTo-Json
    $ContentType = 'application/json'
    $headers = Get-AzureTableAuthorization -StorageAccount $StorageAccount -AccessKey $AccessKey -Resource $resource
    try {
        $response = Invoke-RestMethod -Method MERGE -Uri $table_url.Uri.AbsoluteUri -Headers $headers -ContentType $ContentType -Body $body
    } catch {
        return $Error[0]
        exit 1
    }
}

function Remove-AzureTableEntity {
    param (
        [Parameter(Mandatory = $true)][String]$TableName,
        [Parameter(Mandatory = $true)][String]$PartitionKey,
        [Parameter(Mandatory = $true)][String]$RowKey,
        [Parameter(Mandatory = $true)][String]$StorageAccount,
        [Parameter(Mandatory = $true)][String]$AccessKey
    )
    $resource = "{0}(PartitionKey='{1}',RowKey='{2}')" -f $TableName, $PartitionKey, $Rowkey
    $table_url = [System.UriBuilder]::new('https', "$StorageAccount.table.core.windows.net", '443', $resource, '')
    $ContentType = 'application/http'
    $AuthHeaders = Get-AzureTableAuthorization -StorageAccount $StorageAccount -AccessKey $AccessKey -Resource $resource
    $headers = @{
        'x-ms-date'    = $AuthHeaders.'x-ms-date'
        Authorization  = $AuthHeaders.Authorization
        'x-ms-version' = $AuthHeaders.'x-ms-version'
        Accept         = $AuthHeaders.Accept
        'If-Match'     = '*'
    }
    try {
        $response = Invoke-RestMethod -Method DELETE -Uri $table_url.Uri.AbsoluteUri -Headers $headers -ContentType $ContentType
    } catch {
        return $Error[0]
        exit 1
    }
}
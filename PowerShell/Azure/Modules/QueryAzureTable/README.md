# QueryAzureTable module

## Functions

### Get-AzureTableAuthorization

Called by other functions.

Usage:
```pwsh
$headers = Get-AzureTableAuthorization -StorageAccount $StorageAccount -Accesskey $AccessKey -Resource $resource
```

Resource should be the canonicalized resource string, see https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key

### Get-AzureTableEntities

Retrieve row enities from a given table.

Usage:
```pwsh
Get-AzureTableEntities -TableName 'Table01' -StorageAccount $StorageAccount -AccessKey $AccessKey
```

### Add-AzureTableEntity

Insert or replace a row entity.

Usage:
```pwsh
Add-AzureTableEntity -TableName $table -PartitionKey $entity1.PartitionKey -RowKey $entity1.RowKey -Entity $entity1 -StorageAccount $StorageAccount -AccessKey $AccessKey
```

Entity should be a hashtable representing the row data to insert or update, it should contain the partition key and a row key.

```pwsh
$entity1 = @{
PartitionKey = 'Partition001'
RowKey = '00001'
Name = 'Morgan'
Species = 'Cat'
}
```

### Merge-AzureTableEntity

Update existing row entity.

Usage:
```pwsh
Merge-AzureTableEntity -TableName $tableName -PartitionKey $entity1.PartitionKey -RowKey $entity1.RowKey -Entity $entity1 -StorageAccount $StorageAccount -AccessKey $AccessKey
```

### Remove-AzureTableEntity

Delete a row entity.

Usage:
```pwsh
Remove-AzureTableEntity -TableName $tableName -PartitionKey $entity1.PartitionKey -RowKey $entity1.RowKey -StorageAccount $StorageAccount -AccessKey $AccessKey
```

# Storage File Data Privileged Contributor
$rgName = 'myresourcegroup'
$saName = 'mystorageaccount'
$fileshareName = 'mysharename'
$dir = 'dir1'
$ctxkey = (Get-AzStorageAccount -ResourceGroupName $rgName -Name $saName).Context
$ctx = New-AzStorageContext -StorageAccountName $saName -EnableFileBackupRequestIntent

New-AzStorageShare -Name $fileshareName -Context $ctxkey

New-AzStorageDirectory -ShareName $fileshareName -Path "dir1" -Context $ctx
Set-AzStorageFileContent -ShareName $fileshareName -Path "test2.ps1" -Source "C:\Files\azfiles_rest\azfiles-rest.ps1" -Context $ctx

$apiVersion = '2023-08-03'

# list directories
# Timestamps%82ETag%82Attributes%82
[uri]$uri = 'https://{0}.file.core.windows.net/{1}?restype=directory&comp=list&include=PermissionKey' -f $saName, $fileshareName
$token = (Get-AzAccessToken -ResourceUrl "https://storage.azure.com/").Token
$headers = @{
    Authorization              = 'Bearer {0}' -f $Token
    # 'x-ms-date' = ''
    'x-ms-version'             = $apiVersion
    'x-ms-file-request-intent' = 'backup'
}
[xml]$directories = (Invoke-RestMethod -Uri $uri -Headers $headers -Method Get).Trim('ï»¿')
$directories.EnumerationResults.Entries.Directory

# get directory
[uri]$uri = 'https://{0}.file.core.windows.net/{1}/{2}?restype=directory' -f $saName, $fileshareName, $dir
$token = (Get-AzAccessToken -ResourceUrl "https://storage.azure.com/").Token
$headers = @{
    Authorization              = 'Bearer {0}' -f $Token
    # 'x-ms-date' = ''
    'x-ms-version'             = $apiVersion
    'x-ms-file-request-intent' = 'backup'
}
[xml]$directoryProperties = (Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ResponseHeadersVariable rhead).Trim('ï»¿')

# get file permissions key
[uri]$uri = "https://$saName.file.core.windows.net/$fileshareName/?restype=share&comp=filepermission"
$token = (Get-AzAccessToken -ResourceUrl "https://storage.azure.com/").Token
$headers = @{
    Authorization              = 'Bearer {0}' -f $Token
    # 'x-ms-date' = ''
    'x-ms-version'             = $apiVersion
    'x-ms-file-request-intent' = 'backup'
    'x-ms-file-permission-key' = '1066500202293093125*7356593000343172236'
    # 'x-ms-file-permission-key' = '11712767476353370677*7356593000343172236'
}
$permission = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

# $sddl = $permission.permission
# $sddl = 'O:SYG:SYD:(A;OICI;FA;;;BA)(A;OICI;FA;;;SY)(A;;0x1200a9;;;BU)(A;OICIIO;GXGR;;;BU)(A;OICI;0x1301bf;;;AU)(A;;FA;;;SY)(A;OICIIO;GA;;;CO)'
$standard = 'O:SYG:SYD:(A;;FA;;;SY)(A;OICIID;FA;;;BA)(A;OICIID;FA;;;SY)(A;ID;0x1200a9;;;BU)(A;OICIIOID;GXGR;;;BU)(A;OICIID;0x1301bf;;;AU)(A;OICIIOID;GA;;;CO)'
$noUsers = 'O:SYG:SYD:PAI(A;OICIIO;FA;;;CO)(A;OICI;0x1301bf;;;AU)(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)'

# Set directory properties (PUT)
# [uri]$uri = 'https://{0}.file.core.windows.net/{1}/{2}?restype=directory&comp=properties' -f $saName, $fileshareName, $dir # sub directory
[uri]$uri = 'https://{0}.file.core.windows.net/{1}?restype=directory&comp=properties' -f $saName, $fileshareName # root of share
$token = (Get-AzAccessToken -ResourceUrl "https://storage.azure.com/").Token
$headers = @{
    Authorization              = 'Bearer {0}' -f $Token
    # 'x-ms-date' = ''
    'x-ms-version'             = $apiVersion
    'x-ms-file-request-intent' = 'backup'
    'x-ms-file-permission'     = $standard
}
$directoryUpdate = Invoke-RestMethod -Uri $uri -Headers $headers -Method Put -ResponseHeadersVariable rhead

# Create permission at share level - Just creates permission object for share, doesn't apply
[uri]$uri = 'https://{0}.file.core.windows.net/{1}?restype=share&comp=filepermission' -f $saName, $fileshareName
$token = (Get-AzAccessToken -ResourceUrl "https://storage.azure.com/").Token
$headers = @{
    Authorization              = 'Bearer {0}' -f $Token
    # 'x-ms-date' = ''
    'x-ms-version'             = $apiVersion
    'x-ms-file-request-intent' = 'backup'
}
$body = @{
    Permission = $standard
} | ConvertTo-Json
$shareUpdate = Invoke-RestMethod -Uri $uri -Headers $headers -Body $body -Method Put -ResponseHeadersVariable rhead
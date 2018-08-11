[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Get user details from POST $req
$requestjson = Get-Content $req -Raw
try {
    $requestjson | Out-File -Encoding utf8 -FilePath $outuseritem
}
catch {
    Out-File -Encoding ascii -FilePath $res -InputObject "ERROR: Failed to queue user message"
    Exit 1
}
$requestBody = $requestjson  | ConvertFrom-Json
$name = $name = $requestBody.DisplayName
Out-File -Encoding ascii -FilePath $res -inputObject "Queued $name"
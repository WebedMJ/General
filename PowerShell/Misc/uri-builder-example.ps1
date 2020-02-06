$uriScheme = 'https'
$uriHost = 'webedmj.rocks'
$uriPort = 443
$uriPath = ('stuff', 'morestuff' -join '/')
$uriQuery = "?filter=something eq true" # MUST start with ?
$uri = [System.UriBuilder]::new($uriScheme, $uriHost, $uriPort, $uriPath, $uriQuery)

# Pass to REST API
Invoke-RestMethod $uri.Uri

## -- Or --

$builder = [System.UriBuilder]::new()
$builder.Scheme = 'https'
$builder.Host = "webedmj.rocks"
$builder.Port = 443
$builder.Path = ('stuff', 'morestuff' -join '/')
$builder.Query = "filter=something eq true" # MUST NOT start with ?

# Pass to REST API
Invoke-RestMethod $builder.Uri
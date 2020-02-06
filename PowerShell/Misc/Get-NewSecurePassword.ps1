# Function to generate passwords using the API at https://passwordwolf.com
# Source: https://github.com/WebedMJ/General/blob/master/PowerShell/Misc/Get-NewSecurePassword.ps1
function Get-NewSecurePassword {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateRange(12, 255)]
        [int]$length = 24,
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 100)]
        [int]$count = 1
    )

    begin {
        $uriScheme = 'https'
        $uriHost = 'passwordwolf.com'
        $uriPort = 443
        $uriPath = 'api/'
        $uriQuery = '?length={0}&repeat={1}' -f $length, $count
        $api = [System.UriBuilder]::new($uriScheme, $uriHost, $uriPort, $uriPath, $uriQuery)
        $uri = $api.Uri
    }

    process {
        try {
            $result = Invoke-RestMethod -Uri $uri
        } catch {
            Throw 'Error getting passwords from passwordwolf.com!'
        }

    }

    end {
        return $result
    }
}
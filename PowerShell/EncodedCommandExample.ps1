$string = {Set-WebConfigurationProperty -Filter /system.webserver/security/authentication/anonymousAuthentication -PSPath 'IIS:\' -Location 'Default Web Site' -Name Enabled -Value False}.ToString()
$encodedcommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($string))
$encodedcommand | clip

# powershell.exe -noprofile -encodedcommand $encodedcommand
# or...
# powershell.exe -noprofile -encodedcommand UwBlAHQALQBXAGUAYgBDAG8AbgBmAGkAZwB1AHIAYQB0AGkAbwBuAFAAcgBvAHAAZQByAHQAeQAgAC0ARgBpAGwAdABlAHIAIAAvAHMAeQBzAHQAZQBtAC4AdwBlAGIAcwBlAHIAdgBlAHIALwBzAGUAYwB1AHIAaQB0AHkALwBhAHUAdABoAGUAbgB0AGkAYwBhAHQAaQBvAG4ALwBhAG4AbwBuAHkAbQBvAHUAcwBBAHUAdABoAGUAbgB0AGkAYwBhAHQAaQBvAG4AIAAtAFAAUwBQAGEAdABoACAAJwBJAEkAUwA6AFwAJwAgAC0ATABvAGMAYQB0AGkAbwBuACAAJwBEAGUAZgBhAHUAbAB0ACAAVwBlAGIAIABTAGkAdABlACcAIAAtAE4AYQBtAGUAIABFAG4AYQBiAGwAZQBkACAALQBWAGEAbAB1AGUAIABGAGEAbABzAGUA

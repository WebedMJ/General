# From @blindpete

$script = [scriptblock]{$status = & "$env:windir\system32\dsregcmd.exe" /status 
$info = $status -replace ':', ' ' | 
    Select-Object -Index 5, 6, 7, 13, 14, 15, 16, 17, 18, 19, 25, 26, 27, 28, 29, 30, 31 | 
    ForEach-Object -Process {
    $_.Trim() 
}  | 
    ConvertFrom-String -PropertyNames 'State', 'Status'
 
$hash = [ordered]@{}
 
for ($i = 0; $i -lt $info.count; $i++) {
    $hash.add($info[$i].State, $info[$i].status)
}
[pscustomobject]$hash
}

# Invoke-Command -Session $session -ScriptBlock $script
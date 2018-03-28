# Base code snippet to iterate through folder structure, optionally looking for certain folder names
# Requires 7zip
Set-Alias sz ".\7-Zip\7z.exe"
$dirs = Get-ChildItem D: -Name wp2 -Directory -Recurse
$dirs | ForEach-Object ( {
        $folder = $PSItem
        $folderpath = "D:\$folder"
        $finalpath = $folderpath -replace 'wp2',''
        $zips = Get-ChildItem -Path $finalpath -Filter *.zip -File -Recurse | Select-Object FullName
        $zips = $zips.FullName
        $checkresults = @()
        $zips | ForEach-Object( {
                sz t -stm2 $PSItem | Out-Null
                $checkresults = [PSCustomObject][Ordered]@{
                    File  = $PSItem
                    Check = $LASTEXITCODE
                }
                $servername = $env:COMPUTERNAME
                if (($checkresults.Check -ne "0") -and ($checkresults.Check -ne "7")) {
                        $checkresults | Export-Csv .\$servername.csv -NoTypeInformation -Append
                }
            })
    })
# Original source: https://github.com/tomarbuthnot/Microsoft-Teams-PowerShell
# Uses the Teams module: https://docs.microsoft.com/en-us/powershell/module/teams/?view=teams-ps

# Define a new object to gather output
$OutputCollection = @()

Write-Verbose "Getting Team Names and Details"
$teams = Get-Team

Write-Output "Teams Count is $($teams.count)"

$teams | ForEach-Object {

    Write-Output "Getting details for Team $($_.DisplayName)"

    # Calculate Description word count

    $DescriptionWordCount = $null
    $DescriptionWordCount = ($_.Description | Out-String | Measure-Object -Word).words

    # Get channel details

    $Channels = $null
    $Channels = Get-TeamChannel -GroupId $_.GroupID
    $ChannelCount = $Channels.count

    # Get Owners, members and guests

    $TeamUsers = Get-TeamUser -GroupId $_.GroupID

    $TeamOwnerCount = ($TeamUsers | Where-Object { $_.Role -like "owner" }).count
    $TeamMemberCount = ($TeamUsers | Where-Object { $_.Role -like "member" }).count
    $TeamGuestCount = ($TeamUsers | Where-Object { $_.Role -like "guest" }).count

    # Put all details into an object

    $output = New-Object -TypeName PSobject

    $output | Add-Member NoteProperty "DisplayName" -value $_.DisplayName
    $output | Add-Member NoteProperty "Description" -value $_.Description
    $output | Add-Member NoteProperty "DescriptionWordCount" -value $DescriptionWordCount
    $output | Add-Member NoteProperty "Visibility" -value $_.Visibility
    $output | Add-Member NoteProperty "Archived" -value $_.Archived
    $output | Add-Member NoteProperty "ChannelCount" -Value $ChannelCount
    $output | Add-Member NoteProperty "OwnerCount" -Value $TeamOwnerCount
    $output | Add-Member NoteProperty "MemberCount" -Value $TeamMemberCount
    $output | Add-Member NoteProperty "GuestCount" -Value $TeamGuestCount
    $output | Add-Member NoteProperty "GroupId" -value $_.GroupId

    $OutputCollection += $output
}

# Output collection
$OutputCollection | Export-Csv -Path .\teams_export.csv -NoTypeInformation
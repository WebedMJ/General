## Script created Jan 2016
# This script is to check for paused VMs and attempt to resume them
# Using Write-Host for interactive use...

# Specify event log source for alerts
$alerteventlog = "Application"
$alertsource = "VM Script Check"
# Create event log source if it doesn't exist
if ([System.Diagnostics.EventLog]::SourceExists($alertsource) -eq $false) {
    write-host "Creating event source $alertsource for the $alerteventlog event log"
    [System.Diagnostics.EventLog]::CreateEventSource($alertsource, $alerteventlog)
    write-host -foregroundcolor green "Event source $alertsource created"
}
else {
    write-host -foregroundcolor Cyan "Event source $alertsource already exists. No need to create this source for the $alerteventlog event log"
}
##
# Check if Hyper-V is installed...
$HVFeature = Get-WindowsFeature Hyper-v
if ($HVFeature.InstallState -eq "Installed") {
    Write-Host -ForegroundColor Green "Hyper-V Role detected, continuing..."
}
else {
    Write-Host -ForegroundColor Yellow "Hyper-V Role NOT detected, aborting script"
    Exit 0
}
# Resume any paused VMs if possible
$PausedVMs = Get-VM | Where-Object {$_.state -like "*Paused*"}
if ($PausedVMs) {
    Write-Host -ForegroundColor Yellow "VMs are paused, attempting to resume...!"
    $PausedVMs | Resume-VM
} 
else {
    Write-Host -ForegroundColor Green "All VMs are running."
    Write-EventLog -LogName $alerteventlog -Source $alertsource -EventId 1000 -EntryType Information -Category 0 -Message "All VMs are running."
    Exit 0
}
# Wait for a while before checking again...
Write-Host "Waiting for a while before checking again..."
Start-Sleep -Seconds 60
# Check for any VMs still in paused state, clear checkpoints and try to resume again
$PausedVMs = Get-VM | Where-Object {$_.state -like "*Paused*"}
if ($PausedVMs) {
    Write-Host -ForegroundColor Yellow "VMs are still paused, attempting clear checkpoints and resume...!"
    $PausedVMs | Remove-VMSnapshot
    Start-Sleep -Seconds 60
    $PausedVMs | Resume-VM
} 
else {
    Write-Host -ForegroundColor Green "Some VMs were paused but have been successfully resumed. Check Hyper-V log for more information."
    Write-EventLog -LogName $alerteventlog -Source $alertsource -EventId 1001 -EntryType Information -Category 0 -Message "Some VMs were paused but have been successfully resumed. Check Hyper-V log for more information."
    Exit 0
}
# Wait for a while before checking again...
$MergingVMs = get-vm | Where-Object {$_.Status -eq "Merging Disks"}
$n = 0
$totaln = 60
if ($MergingVMs) {
    do {
        $n++
        Write-Host "Waiting 1 minute for disk merge to complete... ($n/$totaln)"
        Start-Sleep -Seconds 60
        $MergingVMs = get-vm | Where-Object {$_.Status -eq "Merging Disks"}
    }
    while ($MergingVMs -and $n -lt 60)
}
else {
    Write-Host "VMs not merging"
}
# Check for any VMs still in paused state, turn off VM, clear checkpoints and try to start again
$PausedVMs = Get-VM | Where-Object {$_.state -like "*Paused*"}
if ($PausedVMs) {
    Write-Host -ForegroundColor Yellow "VMs are still paused, turning off and attempting to clear checkpoints before starting again..."
    $PausedVMs | Stop-VM -TurnOff
    Start-Sleep -Seconds 30
    $PausedVMs | Remove-VMSnapshot -ErrorAction Stop
    Start-Sleep -Seconds 30
    $MergingVMs = get-vm | Where-Object {$_.Status -eq "Merging Disks"}
    $n = 0
    $totaln = 60
    if ($MergingVMs) {
        do {
            $n++
            Write-Host "Waiting 1 minute for disk merge to complete... ($n/$totaln)"
            Start-Sleep -Seconds 60
            $MergingVMs = get-vm | Where-Object {$_.Status -eq "Merging Disks"}
        }
        while ($MergingVMs -and $n -lt 60)
    }
    
    $PausedVMs | Start-VM
}
else {
    Write-Host -ForegroundColor Green "Some VMs were paused but have been successfully resumed. Check Hyper-V log for more information."
    Write-EventLog -LogName $alerteventlog -Source $alertsource -EventId 1001 -EntryType Information -Category 0 -Message "Some VMs were paused but have been successfully resumed. Check Hyper-V log for more information."
    Exit 0
}
# Check for any VMs still in a paused state and alert
$PausedVMs = Get-VM | Where-Object {$_.state -like "*Paused*"}
if ($PausedVMs) {
    Write-Host -ForegroundColor Yellow "VMs are paused!"
    Write-EventLog -LogName $alerteventlog -Source $alertsource -EventId 1010 -EntryType Error -Category 0 -Message "One or more VMs are paused!"
    Exit 1010
} 
else {
    Write-Host -ForegroundColor Green "Some VMs were paused but have been successfully resumed. Check Hyper-V log for more information."
    Write-EventLog -LogName $alerteventlog -Source $alertsource -EventId 1001 -EntryType Information -Category 0 -Message "Some VMs were paused but have been successfully resumed. Check Hyper-V log for more information."
    Exit 0
}
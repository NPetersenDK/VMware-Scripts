<#

.Author
Nikolaj Petersen

.DESCRIPTION
Power saving meassures for VM Homelab
This dosent take clusters into consideration but rather Tags on vCenter, use with caution and only tag one host per cluster maybe.
Can be done to multiple hosts in a cluster, but has to be re-written, especially if you use VSAN.

Task 1:
    Create tags:
        $TagCat = New-TagCategory -Name "StandbyMechanism"
        New-Tag -Name StandbyHost -Description StandbyHost -Category $TagCat
    Add the tags to the hosts you want to standby in vCenter.

Task 2:
    Run script manually to see everything works

Task 3: 
    Put it into cron/vRA/vRO/TaskScheduler to make this automatically happen at night fx.

#>

$State = "Standby"

$StandbyTagCat = Get-TagCategory -Name "StandbyMechanism"
$StandbyHostTag = Get-Tag "StandbyHost" -Category $StandbyTagCat

[int]$WaitTimeSec = 10

$GetVMHostfromTag = Get-VMHost -Tag $StandbyHostTag

if ($State -eq "Standby") {
    foreach ($VMHost in $GetVMHostfromTag) {
        Write-Host $VMHost.Name
        $VMHost | Set-VMHost -State Maintenance -VsanDataMigrationMode NoDataMigration
    
        Write-Host "Job finished or timed out.. waiting $($WaitTimeSec) seconds"
        Start-Sleep -Seconds $($WaitTimeSec)
        $VMHost = Get-VMHost $VMHost.Name
    
        if ($VMHost.ConnectionState -eq "Maintenance") {
            Write-Host "Host is in maintenance mode - suspending it!"
            $VMHost | Suspend-VMHost -Confirm:$false
    
            Write-Host "Job finished or timed out.. waiting $($WaitTimeSec) seconds"
            Start-Sleep -Seconds $($WaitTimeSec)
    
            $VMHost = Get-VMHost $VMHost.Name

            if ($VMHost.PowerState -eq "Standby") {
                Write-Host "Success"
            }

            else {
                Write-Host "Power state on host: $($VMHost.Name) is not Standby, but: $($VMHost.PowerState)"
            }
        }
    
        else {
            Write-Host "Failed!"
        }
    }
}

elseif ($State -eq "PowerOn") {

    foreach ($VMHost in $GetVMHostfromTag) {
        Write-Host $VMHost.Name
        $VMHost | Start-VMHost
        
        Write-Host "Job finished or timed out.. waiting $($WaitTimeSec) seconds"
        Start-Sleep -Seconds $($WaitTimeSec)

        $VMHost = Get-VMHost $VMHost.Name

        if ($VMHost.ConnectionState -eq "Maintenance") {
            Write-Host "Host is in Maintenance mode - exiting"
            $VMHost | Set-VMHost -State Connected

            Write-Host "Job finished or timed out.. waiting $($WaitTimeSec) seconds"
            Start-Sleep -Seconds $($WaitTimeSec)


            $VMHost = Get-VMHost $VMHost.Name
            if ($VMHost.ConnectionState -eq "Connected") {
                Write-Host "Host is out of maintenance mode"
            }
            else {
                Write-Host "State is not yet Connected - check manually."
            }
        }
    }
}

else {
    Write-Host "Set a state.."
}
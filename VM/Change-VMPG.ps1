<#
.Author
    Nikolaj Petersen 
     ____  _____ _____ _____ ____  ____  _____ _   _
    |  _ \| ____|_   _| ____|  _ \/ ___|| ____| \ | |
    | |_) |  _|   | | |  _| | |_) \___ \|  _| |  \| |
    |  __/| |___  | | | |___|  _ < ___) | |___| |\  |
    |_|   |_____| |_| |_____|_| \_|____/|_____|_| \_|
    Nikolaj Petersen / NPetersenDK
    gist.github.com/NPetersenDK
    https://nipetersen.dk

.Description
    Changing old servers on a specific PortGroup to a new one
#>

$Date = Get-Date -UFormat "%d-%m-%Y-%H%M%S"
$LogFile = "$PSScriptRoot\Change-VMPG-$Date.txt"
function Logging($data){
    "$((Get-Date).ToLocalTime()): $data" | Out-File -FilePath $LogFile -Encoding utf8 -Append
    Write-Host $data
}

#$vcsa = "YourVCSA.dns.tld"
#Connect-VIServer $vcsa -Credential (Get-Credential)

#Variables:
#The PG that have VM's you want to change
$OldPortGroup = "OLDPG"
#The PG you want them to migrate to
$NewPortGroup = "NEWPG"

#Getting the PG and VM ID's
$GetOldPGVMs = Get-View -ViewType Network -Property Name,VM -Filter @{Name=$OldPortGroup}
$servers = Get-View -Id $GetOldPGVMs.Vm -Property Name 

#Getting the new PG
$GetNewPG = Get-VDPortgroup -Name $NewPortGroup

Logging "START: Moving all VM's from PortGroup $OldPortGroup to $NewPortGroup"

foreach ($server in $servers) {
    $vm = Get-VM $server.Name
    $VMName = $VM.Name
    Logging "INFO: Working on VM $vm"
    
    #Getting the network adapter for the VM
    $adapters = Get-NetworkAdapter -VM $vm

    #Foreach adapter on VM (a VM can be on multiple and different PG's - this makees sure we change the right ones.
    foreach ($adapter in $adapters) {
        # If adapter is on OldPortGroup
        if ($adapter.NetworkName -eq $OldPortGroup) {
            $CurrentNetwork = $adapter.NetworkName

            Logging "INFO: Adapter is on $CurrentNetwork - disconnecting, setting to $NewPortGroup and connecting."

                Set-NetworkAdapter -NetworkAdapter $adapter -Connected $false -Confirm:$false
                Set-NetworkAdapter -NetworkAdapter $adapter -Portgroup $GetNewPG -Confirm:$false
                Set-NetworkAdapter -NetworkAdapter $adapter -Connected $true -Confirm:$false
        }
        # Adapter not on  $OldPortGroup
        else {
            $CurrentNetwork = $adapter.NetworkName
            Logging "ALERT: Adapter is not on PortGroup - not setting! $CurrentNetwork - $VMName"
        }
    }
    Logging " -- "
}

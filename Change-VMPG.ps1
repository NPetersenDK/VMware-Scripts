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


#$vcsa = "YourVCSA.dns.tld"
#Connect-VIServer $vcsa -Credential (Get-Credential)

#Variables:
#The PG that have VM's you want to change
$OldPortGroup = "Old-PGNAME"
#The PG you want them to migrate to
$NewPortGroup = "New-PGNAME"

#Getting the PG and VM ID's
$GetOldPGVMs = Get-View -ViewType Network -Property Name,VM -Filter @{Name=$OldPortGroup}
$servers = Get-View -Id $GetOldPGVMs.Vm -Property Name 

#Getting the new PG
$GetNewPG = Get-VDPortgroup -Name $NewPortGroup

foreach ($server in $servers) {
    $vm = Get-VM $server.Name
    Write-Host $vm
    
    #Getting the network adapter for the VM
    $adapters = Get-NetworkAdapter -VM $vm

    #Foreach adapter on VM (a VM can be on multiple and different PG's - this makees sure we change the right ones.
    foreach ($adapter in $adapters) {
        # If adapter is on OldPortGroup
        if ($adapter.NetworkName -eq $OldPortGroup) {
            Write-Host "Adapter is on $PortGroup - changing to $NewPortGroup"
            #Setting the networkadapter to the new PG
            #Set-NetworkAdapter -NetworkAdapter $adapter -Portgroup $GetNewPG
        }
        # Adapter not on  $OldPortGroup
        else {
            Write-Host "Adapter is not on PortGroup - not setting!" $adapter.NetworkName "-" $vm.Name -ForegroundColor Red
        }
    }
}

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

$OldPortGroup = "Old-PGNAME"
$NewPortGroup = "New-PGNAME"

$GetOldPGVMs = Get-View -ViewType Network -Property Name,VM -Filter @{Name=$OldPortGroup}
$servers = Get-View -Id $GetOldPGVMs.Vm -Property Name 

$GetNewPG = Get-VDPortgroup -Name $NewPortGroup

foreach ($server in $servers) {
    $vm = Get-VM $server.Name
    Write-Host $vm

    $adapters = Get-NetworkAdapter -VM $vm

    foreach ($adapter in $adapters) {
        if ($adapter.NetworkName -eq $PortGroup) {
            Write-Host "Adapter is on $PortGroup - changing to $NewPortGroup"
            #Set-NetworkAdapter -NetworkAdapter $adapter -Portgroup $GetNewPG
        }
        else {
            Write-Host "Adapter is not on PortGroup - not setting!" $adapter.NetworkName "-" $vm.Name -ForegroundColor Red
        }
    }
}

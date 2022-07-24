<#

.Author:
Nikolaj Petersen

.Description:
You need to have setup the iSCSI HBA adapter before hand. 
This sets up the IP in the $ISCSITargets on the iSCSI HBA Adapters 
on the hosts in cluster you type in $VMCluster



.Support:
None :)

#>

$iSCSITargets = "1.1.1.1","2.2.2.2","3.3.3.3"
$iSCSIPort = "3260"
$VMCluster = "ClusterName"


$Cluster = Get-Cluster $VMCluster | Get-VMHost
foreach ($vmhost in $Cluster) {
	Write-Host $vmhost.name
    $gethba = $vmhost | Get-VMHostHba -Type IScsi


    foreach ($iscsi in $iSCSITargets) {
        Write-Host "Setting HBA target $iscsi on" $vmhost.Name
        $gethba | New-IScsiHbaTarget -Address $iscsi -Port $iSCSIPort
    }
}

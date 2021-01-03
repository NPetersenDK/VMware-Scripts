<#
.Author
    Nikolaj Petersen
    n@nipetersen.dk

.Description
  This script was created due to an error in NSX where the cluster will go into 100% CPU mode.
  The fix for that was to disable the agent by hand on all hosts, which takes some time manually.
  This script might be usable for other things aswell, therefore this script is generic.

What it does:
    1) Firstly we connect to the VCSA asking for credentials
    2) Asking for the SSH Creds
    3) Getting the hosts in the cluster of variable $esxhosts
    4) SSH'ing into them and executing command of "Invoke-SSHCommand"
       
#>

## Parameters
$vcsa = "VCSA.domain.tld"
$Cluster = "ClusterName"
$Command = "ChangeMe"

Connect-VIServer $vcsa -Credential (Get-Credential -Message "Credentials for VCSA")

$sshcred = (Get-Credential -Message "SSH Credentials for ESX hosts in cluster")
$esxhosts = Get-Cluster $Cluster | Get-VMHost 

foreach ($esxhost in $esxhosts) {
    Write-Host $esxhost.Name

    Start-VMHostService -HostService ($esxhost | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"})
    $sshsession = New-SSHSession -ComputerName $esxhost -Credential $sshcred
    Invoke-SSHCommand -Index $sshsession.Sessionid -Command "$($Command)"
    Remove-SSHSession -Index $sshsession.Sessionid

}

## Nulling SSH Creds
$sshcred = $null

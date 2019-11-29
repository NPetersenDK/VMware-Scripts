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
#>

$vcsa = "VCSAServer"
Connect-VIServer $vcsa -Credential (Get-Credential)

$sshcred = (Get-Credential)
$esxhosts = Get-Cluster Clustername | Get-VMHost

foreach ($esxhost in $esxhosts) {
    Write-Host $esxhost.Name

    Start-VMHostService -HostService ($esxhost | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"})

    $sshsession = New-SSHSession -ComputerName $esxhost -Credential $sshcred
    Invoke-SSHCommand -Index $sshsession.Sessionid -Command "esxcli system snmp set --communities publickey"
    Invoke-SSHCommand -Index $sshsession.Sessionid -Command "esxcli system snmp set --enable true"
    Remove-SSHSession -Index $sshsession.Sessionid

    Start-VMHostService -HostService ($esxhost | Get-VMHostService | Where { $_.Key -eq "snmpd"})
    Stop-VMHostService -HostService ($esxhost | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"})

}

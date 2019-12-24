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
Easy connect to your usual suspects of NSX and vCenter. :-)

.Support
None.

#>

function Connect-ProdVCSA {
    $vcsa = "vcenter.dns.tld"
    
    $cred = (Get-Credential) 
    Connect-VIServer $vcsa -Credential $cred
    Connect-NsxServer -vCenterServer $vcsa -Credential $cred

    $cred = $null
}

function Connect-VdiVCSA {
    $vcsa = "vdivcsa.dns.tld"
    
    $cred = (Get-Credential) 
    Connect-VIServer $vcsa -Credential $cred
    Connect-NsxServer -vCenterServer $vcsa -Credential $cred

    $cred = $null
}

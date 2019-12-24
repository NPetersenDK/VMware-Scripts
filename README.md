# VMware-Scripts
PowerShell/other scripts for use in and around VMware hosts and a lot of different VMware Services. This is mostly by using VMware PowerCLI :)

```
 ____  _____ _____ _____ ____  ____  _____ _   _
|  _ \| ____|_   _| ____|  _ \/ ___|| ____| \ | |
| |_) |  _|   | | |  _| | |_) \___ \|  _| |  \| |
|  __/| |___  | | | |___|  _ < ___) | |___| |\  |
|_|   |_____| |_| |_____|_| \_|____/|_____|_| \_|

    Nikolaj Petersen / NPetersenDK
    gist.github.com/NPetersenDK
    https://nipetersen.dk
```
# Description of my scripts
A list and a little description of the scripts in this repository 

### SnmpEnabler
Enables SNMP on all ESX servers in your cluster, by changing one variable you can one cluster at a time enable SNMP

### Change-VMPG
I needed a way to change/migrate all VM's on a Port Group in VMware, so i made a little script that lists all VM's on a Distributed Port Group and changing it to another one. It also checks if there is more than one network card on that VM, and only changes the PG/Interface if it's on the one you want to migrate away from.

### function-ConnectVCSA
I really easy script, but a nice one to have enabled in your PowerShell profile, so the only thing you have to do is type "Connect-ProdVCSA" (or another name you can change) and it will connect to the VCSA after you type in your password. 

Easy script, but a joy of life script :)

# Disclaimer
The scripts and programs are released without any support and if stuff breaks I'm not responsible. Although you're more than happy to contact me, and I might help.

As per usual test the scripts before executing them, normally i comment out things where I change stuff, so you have a chance to actually test it before running. Please double check though :)

# License
Released under the MIT LICENSE - check the LICENSE file

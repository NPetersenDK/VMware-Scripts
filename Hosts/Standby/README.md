# Standby ESX host
Setting a host in standby fully automatically

## Purpose:
The built-in DPM (Distributed Power Management) in vCenter cannot do anything on a vSAN, and with good reason.
But in a Homelab, their might be a good reason to put a host into standby, so you don't use too much power.

I use it for the 1 out of 2 nodes in a vSAN, thats why the "-VsanDataMigrationMode" is set to NoDataMigration in my lab.
That you might have to change to your behaviour.

## Limitations and future versions

### Limitations:
- If it fails, it stops - no error handling right now.

### Future versions:
- Make the Start-Sleep to a while loop instead and maybe jobs, these actions can take time
- Make better error handling
- Check vSAN health before starting, especially needed if you have 3 or more nodes.

## How?
1: Create a TagCategory
```
TagCat = New-TagCategory -Name "StandbyMechanism"
```
2: Create the Tag.
```
New-Tag -Name StandbyHost -Description StandbyHost -Category $TagCat
```

## Contact
If you want to contact me about this project, you can do so by sending me an e-mail at github@nipetersen.dk. Support is very limited, but I might help if I have the time to do so.

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
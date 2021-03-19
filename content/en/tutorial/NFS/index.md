##Introduction


##Installation

##Setup a Basic NFS Server
To begin, install the required packages using the following command:

```
$ sudo apt install nfs-kernel-server
```
Create a filesystem to export to:

```
$ sudo mkdir -p /export/users

```

Mount the real directory to the export filesystem. In this case, we will use /home/pi:

```
$ sudo mount --bind /home/pi /export/users
```

To preserve this between reboots, edit your filesystem's fstab file. This can be found in the pi directory:

```
$ sudo nano /etc/fstab
```
Add the following line to the end of the file, separated by tabs:

```
/home/users    /export/users   none    bind  0  0
```




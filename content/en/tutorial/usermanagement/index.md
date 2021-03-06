---
date: 2021-02-07
title: "User Management"
linkTitle: "User Management"
description: "How to manage users on the pi cluster"
author: Anthony Orlowski ([antorlowski@gmail.com](mailto:antorlowski@gmail.com)), Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com))
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" >}}
{{< /imgproc >}}


{{% pageinfo %}}

This tutorial will introduce you to simple user management commands for a Pi cluster generated with cloudmeah `cms burn`. It allows adding, deleting new users as wall as adding new keys too the manager and workers. It does only use ssh as mechanism for authentication as to keep the number of used services small.

**Learning Objectives**

* Learn how to manage users with cloudmesh 
* Learn ow to add and delete users
* Learn how to add keys
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

### Setup ~/.ssh/config to use PROXYJUMP

This tutorial assumes you have local network access to the target machines. 
If this is not the case, such as in a bridge setup, you can run the 
following command to setup your `~/.ssh/config` file to use the bridge to access 
the target machines. 

In this example `red.local` is the bridge and `red0[1-2]` are workers
accessible via the bridge device, and the workers already have your laptop's 
ssh key in authorized_keys. 

```
you@yourlaptop:~/$ cms host config proxy pi@red.local red0[1-2]
host config proxy pi@red.local red0[1-2]
Adding to ~/.ssh/config

##### CLOUDMESH PROXY CONFIG #####

Host red
     HostName pi@red.local
     User pi

Host red01
     HostName red01
     User pi
     ProxyJump pi@red.local

Host red02
     HostName red02
     User pi
     ProxyJump pi@red.local

##### CLOUDMESH PROXY CONFIG #####

```

Let's test

```
you@yourlaptop:~/$ ssh red
pi@red:~/$ exit
you@yourlaptop:~/$ ssh red01
pi@red001:~/$ exit
you@yourlaptop:~/$ ssh red02
pi@red002:~/$ exit
```

### Add User

On red only.

```
pi@red:~ $ sudo add user bob
```

On multiple cluster machines. 

```
you@yourlaptop:~/$ cms host adduser localhost,red,red0[1-2] wendy
host adduser localhost,red,red0[1-2] wendy

Adding user to localhost
Adding user `wendy' ...
Adding new group `wendy' (1011) ...
Adding new user `wendy' (1010) with group `wendy' ...
Creating home directory `/home/wendy' ...
Copying files from `/etc/skel' ...

+--------+---------+--------------------------------------------------+
| host   | success | stdout                                           |
+--------+---------+--------------------------------------------------+
| red    | True    | Adding user `wendy' ...                          |
|        |         | Adding new group `wendy' (1001) ...              |
|        |         | Adding new user `wendy' (1001) with group        |
|        |         | `wendy' ...                                      |
|        |         | Creating home directory `/home/wendy' ...        |
|        |         | Copying files from `/etc/skel' ...               |
| red01  | True    | Adding user `wendy' ...                          |
|        |         | Adding new group `wendy' (1001) ...              |
|        |         | Adding new user `wendy' (1001) with group        |
|        |         | `wendy' ...                                      |
|        |         | Creating home directory `/home/wendy' ...        |
|        |         | Copying files from `/etc/skel' ...               |
| red02  | True    | Adding user `wendy' ...                          |
|        |         | Adding new group `wendy' (1001) ...              |
|        |         | Adding new user `wendy' (1001) with group        |
|        |         | `wendy' ...                                      |
|        |         | Creating home directory `/home/wendy' ...        |
|        |         | Copying files from `/etc/skel' ...               |
+--------+---------+--------------------------------------------------+

```

### Change User Password

On red only.

```
pi@red:~ $ sudo passwd bob
```

On multiple cluster machines.

```
you@yourlaptop:~/$ cms host passwd localhost,red,red0[1-2] wendy
host passwd localhost,red,red0[1-2] wendy

Setting password on localhost, please provide user password
Enter new UNIX password: 
Retype new UNIX password: 
passwd: password updated successfully
0

Setting password on remote hosts, please enter user password

Please enter the user password:
c+--------+---------+--------+
| host   | success | stdout |
+--------+---------+--------+
| red    | True    |        |
| red01  | True    |        |
| red02  | True    |        |
+--------+---------+--------+
```

However, it seems like this may not work on the local machine (red).

### Add User to Sudoers

On red only.

```
pi@red:~ $ sudo adduser bob sudo
```

On multiple cluster machines.

```
you@yourlaptop:~/$ cms host addsudo localhost,red,red00[1-2] wendy
host addsudo localhost,red,red00[1-2] wendy

Adding user to sudo group on localhost
Adding user `wendy' to group `sudo' ...
Adding user wendy to group sudo
Done.

+--------+---------+-----------------------------------------+
| host   | success | stdout                                  |
+--------+---------+-----------------------------------------+
| red    | True    | Adding user `wendy' to group `sudo' ... |
|        |         | Adding user wendy to group sudo         |
|        |         | Done.                                   |
| red01  | True    | Adding user `wendy' to group `sudo' ... |
|        |         | Adding user wendy to group sudo         |
|        |         | Done.                                   |
| red02  | True    | Adding user `wendy' to group `sudo' ... |
|        |         | Adding user wendy to group sudo         |
|        |         | Done.                                   |
+--------+---------+-----------------------------------------+
```

### Test User

```
you@yourlaptop:~ $ ssh red01

pi@red01:~$ su wendy
Password: 
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

wendy@red01:/home/ubuntu$ sudo echo hello
[sudo] password for wendy: 
hello
```

### Add A Key to A User's Authorized Keys

```
you@yourlaptop:~ $ cms host key gather red keys.txt
host key gather red keys.txt

you@yourlaptop:~ $ cms host key scatter red,red0[1-2] keys.txt --user=wendy 
host key scatter red,red0[1-2] keys.txt --user=wendy
INFO: SCP to ./temp_authorzied_keys_temp
+--------+---------+--------+
| host   | success | stdout |
+--------+---------+--------+
| red    | True    |        |
| red01  | True    |        |
| red02  | True    |        |
+--------+---------+--------+
INFO: Mkdir /home/wendy/.ssh if not exist
+--------+---------+--------+
| host   | success | stdout |
+--------+---------+--------+
| red    | True    |        |
| red01  | True    |        |
| red02  | True    |        |
+--------+---------+--------+
INFO: Chown /home/wendy/.ssh to wendy
+--------+---------+--------+
| host   | success | stdout |
+--------+---------+--------+
| red    | True    |        |
| red01  | True    |        |
| red02  | True    |        |
+--------+---------+--------+
INFO: Chmod /home/wendy/.ssh to 700
+--------+---------+--------+
| host   | success | stdout |
+--------+---------+--------+
| red    | True    |        |
| red01  | True    |        |
| red02  | True    |        |
+--------+---------+--------+
INFO: Mv temp_authorized_keys_temp to /home/wendy/.ssh/authorized_keys
+--------+---------+--------+
| host   | success | stdout |
+--------+---------+--------+
| red    | True    |        |
| red01  | True    |        |
| red02  | True    |        |
+--------+---------+--------+
INFO: Chown /home/wendy/.ssh/authorized_keys to wendy
+--------+---------+--------+
| host   | success | stdout |
+--------+---------+--------+
| red    | True    |        |
| red01  | True    |        |
| red02  | True    |        |
+--------+---------+--------+

```

Let uss test logging in as wendy.

```
you@yourlaptop:~ $ ssh wendy@red.local
Linux red 5.10.17-v7l+ #1403 SMP Mon Feb 22 11:33:35 GMT 2021 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
wendy@red:~ $ 

```

### Delete  User

On red only.

-r removes the user's home folder too.

```
pi@red:~ $ sudo userdel -r bob
```

On multiple cluster machines.

```
you@yourlaptop:~/$ cms host deluser localhost,red,red0[1-2] wendy
host deluser localhost,red,red0[1-2] wendy

Deleting user on localhost
userdel: wendy mail spool (/var/mail/wendy) not found

+--------+---------+--------+
| host   | success | stdout |
+--------+---------+--------+
| red    | True    |        |
| red01  | True    |        |
| red02  | True    |        |
+--------+---------+--------+
```

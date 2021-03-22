---
date: 2021-02-07
title: "Example Tutorial"
linkTitle: "User Management"
description: "How to manage users on the pi cluster"
author: Anthony Orlowski ([antorlowski@gmail.com](mailto:antorlowski@gmail.com))
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{< imgproc image Fill "600x300" >}}
The Web Page.
{{< /imgproc >}}


{{% pageinfo %}}

Abstract

**Learning Objectives**

* Learn how to ...
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

### Add User

On red only.

```
pi@red:~ $ sudo add user bob
```

On multiple cluster machines. 

Disabled and gecos are required to prevent 
interactive questions.

```
pi@red:~$ cms host ssh red,red00[1-2] \"sudo adduser wendy --disabled-password --gecos ',' \"
host ssh red,red00[1-2] "sudo adduser wendy --disabled-password --gecos , "
+--------+---------+--------------------------------------------------+
| host   | success | stdout                                           |
+--------+---------+--------------------------------------------------+
| red    | True    | Adding user `wendy' ...                          |
|        |         | Adding new group `wendy' (1001) ...              |
|        |         | Adding new user `wendy' (1001) with group        |
|        |         | `wendy' ...                                      |
|        |         | Creating home directory `/home/wendy' ...        |
|        |         | Copying files from `/etc/skel' ...               |
| red001 | True    | Adding user `wendy' ...                          |
|        |         | Adding new group `wendy' (1001) ...              |
|        |         | Adding new user `wendy' (1001) with group        |
|        |         | `wendy' ...                                      |
|        |         | Creating home directory `/home/wendy' ...        |
|        |         | Copying files from `/etc/skel' ...               |
| red002 | True    | Adding user `wendy' ...                          |
|        |         | Adding new group `wendy' (1002) ...              |
|        |         | Adding new user `wendy' (1002) with group        |
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
pi@red:~$ cms host ssh red,red00[1-2] \' echo -e '"password123\npassword123"' \| sudo passwd wendy \'
host ssh red,red00[1-2] ' echo -e "password123\npassword123" | sudo passwd wendy '
+--------+---------+--------------------------------------------------+
| host   | success | stdout                                           |
+--------+---------+--------------------------------------------------+
| red    | True    | New password: Retype new password: Sorry,        |
|        |         | passwords do not match.                          |
|        |         | passwd: Authentication token manipulation error  |
|        |         | passwd: password unchanged                       |
| red001 | True    |                                                  |
| red002 | True    |                                                  |
+--------+---------+--------------------------------------------------+
```

However, it seems like this may not work on the local machine (red).

### Add User to Sudoers

On red only.

```
pi@red:~ $ sudo adduser bob sudo
```

On multiple cluster machines.

```
pi@red:~$ cms host ssh red,red00[1-2] \'sudo adduser wendy sudo \'
host ssh red,red00[1-2] 'sudo adduser wendy sudo '
+--------+---------+-----------------------------------------+
| host   | success | stdout                                  |
+--------+---------+-----------------------------------------+
| red    | True    | Adding user `wendy' to group `sudo' ... |
|        |         | Adding user wendy to group sudo         |
|        |         | Done.                                   |
| red001 | True    | Adding user `wendy' to group `sudo' ... |
|        |         | Adding user wendy to group sudo         |
|        |         | Done.                                   |
| red002 | True    | Adding user `wendy' to group `sudo' ... |
|        |         | Adding user wendy to group sudo         |
|        |         | Done.                                   |
+--------+---------+-----------------------------------------+

```

### Test User

```
pi@red:~ $ ssh red001

pi@red001:~$ su wendy
Password: 
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

wendy@red001:/home/ubuntu$ sudo echo hello
[sudo] password for wendy: 
hello
```

### Delete  User

On red only.

-r removes the user's home folder too.

```
pi@red:~ $ sudo userdel -r bob
```

On multiple cluster machines.

```
pi@red:~$ cms host ssh red,red00[1-2] \'sudo userdel -r wendy \'
host ssh red,red00[1-2] 'sudo userdel -r wendy '
+--------+---------+--------------------------------------------------+
| host   | success | stdout                                           |
+--------+---------+--------------------------------------------------+
| red    | True    | userdel: wendy mail spool (/var/mail/wendy) not  |
|        |         | found                                            |
| red001 | True    |                                                  |
| red002 | True    |                                                  |
+--------+---------+--------------------------------------------------+
```

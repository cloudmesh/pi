---
date: 2021-04-08
title: "Employ K3S on a Pi Cluster"
linkTitle: "Employ K3S on a Pi Cluster"
description: "Easily install your own K3S cluster on Raspberry Pis"
author: Anthony Orlowski, Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: True
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{< imgproc image Fill "600x300" >}}
{{< /imgproc >}}


{{% pageinfo %}}

Install, verify, and uninstall K3s on a cluster of Raspberry Pis running 
Raspberry OS or Ubuntu.

**Learning Objectives**

* Learn how to ...
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## Introduction

K3S provides a lightweight, single binary distribution of Kubernetes with 
very close feature parity to K8s that is perfect for single board computers 
like the Raspberry Pi. In this tutorial we will install, verify, and 
unistall K3s on a cluster of Pis that was created using the Cloudmesh burn 
software.

### Prequisites

This tutorial assumes a cluster burned using one of the following methods:

[Burn a Raspberry OS Cluster](https://cloudmesh.github.io/pi/tutorial/raspberry-burn/)

[Burn an Ubuntu Cluster](https://cloudmesh.github.io/pi/tutorial/ubuntu-burn/)

[Use our GUI to Burn a Cluster](https://cloudmesh.github.io/pi/tutorial/gui-burn/)

The tutorial supports both Raspberry OS and Ubuntu with no required user 
input change.

### Enable Containers

This command adds `'cgroup_enable=cpuset cgroup_memory=1 
cgroup_enable=memory'` to the end of the arguments in `cmdline.txt` if 
they are not already present, and reboots the machines. This is required to 
enable containers in the kernel.

```
you@your-laptop:~$ cms pi k3 add_c_groups red,red0[1-3]
pi k3 add_c_groups red,red0[1-3]
INFO: Enabling cgroups for ['red', 'red01', 'red02', 'red03']
+-------+---------+--------+
| host  | success | stdout |
+-------+---------+--------+
| red   | True    |        |
| red01 | True    |        |
| red02 | True    |        |
| red03 | True    |        |
+-------+---------+--------+
INFO: Executing `sudo reboot` for ['red01', 'red02', 'red03']
INFO: Executing `sudo reboot` for red
```

### Install K3s on the Entire Cluster

This command wil install a K3S cluster with the manager (red) acting as the K3s
server, and the workers and the manager will be installed as agents of that 
server.

```
you@yourlaptop:~$ cms pi k3 install cluster red,red0[1-3]
pi k3 install cluster red,red0[1-3]
INFO: Installing K3s as stand-alone server on ['red']
+------+---------+--------------------------------------------------+
| host | success | stdout                                           |
+------+---------+--------------------------------------------------+
| red  | True    | [INFO]  Finding release for channel stable       |
|      |         | [INFO]  Using v1.20.5+k3s1 as release            |
|      |         | [INFO]  Downloading hash https://github.com/k3s- |
|      |         | io/k3s/releases/download/v1.20.5+k3s1/sha256sum- |
|      |         | arm.txt                                          |
|      |         | [INFO]  Downloading binary https://github.com/k3 |
|      |         | s-io/k3s/releases/download/v1.20.5+k3s1/k3s-armh |
|      |         | f                                                |
|      |         | [INFO]  Verifying binary download                |
|      |         | [INFO]  Installing k3s to /usr/local/bin/k3s     |
|      |         | [INFO]  Creating /usr/local/bin/kubectl symlink  |
|      |         | to k3s                                           |
|      |         | [INFO]  Creating /usr/local/bin/crictl symlink   |
|      |         | to k3s                                           |
|      |         | [INFO]  Creating /usr/local/bin/ctr symlink to   |
|      |         | k3s                                              |
|      |         | [INFO]  Creating killall script                  |
|      |         | /usr/local/bin/k3s-killall.sh                    |
|      |         | [INFO]  Creating uninstall script                |
|      |         | /usr/local/bin/k3s-uninstall.sh                  |
|      |         | [INFO]  env: Creating environment file           |
|      |         | /etc/systemd/system/k3s.service.env              |
|      |         | [INFO]  systemd: Creating service file           |
|      |         | /etc/systemd/system/k3s.service                  |
|      |         | [INFO]  systemd: Enabling k3s unit               |
|      |         | [INFO]  systemd: Starting k3s                    |
+------+---------+--------------------------------------------------+
INFO: Installing K3s on red as agent of red
INFO: Fetching the server token
+------+---------+--------------------------------------------------+
| host | success | stdout                                           |
+------+---------+--------------------------------------------------+
| red  | True    | [INFO]  Finding release for channel stable       |
|      |         | [INFO]  Using v1.20.5+k3s1 as release            |
|      |         | [INFO]  Downloading hash https://github.com/k3s- |
|      |         | io/k3s/releases/download/v1.20.5+k3s1/sha256sum- |
|      |         | arm.txt                                          |
|      |         | [INFO]  Skipping binary downloaded, installed    |
|      |         | k3s matches hash                                 |
|      |         | [INFO]  Skipping /usr/local/bin/kubectl symlink  |
|      |         | to k3s, already exists                           |
|      |         | [INFO]  Skipping /usr/local/bin/crictl symlink   |
|      |         | to k3s, already exists                           |
|      |         | [INFO]  Skipping /usr/local/bin/ctr symlink to   |
|      |         | k3s, already exists                              |
|      |         | [INFO]  Creating killall script                  |
|      |         | /usr/local/bin/k3s-killall.sh                    |
|      |         | [INFO]  Creating uninstall script                |
|      |         | /usr/local/bin/k3s-agent-uninstall.sh            |
|      |         | [INFO]  env: Creating environment file           |
|      |         | /etc/systemd/system/k3s-agent.service.env        |
|      |         | [INFO]  systemd: Creating service file           |
|      |         | /etc/systemd/system/k3s-agent.service            |
|      |         | [INFO]  systemd: Enabling k3s-agent unit         |
|      |         | [INFO]  systemd: Starting k3s-agent              |
+------+---------+--------------------------------------------------+
INFO: Installing K3s on ['red01', 'red02', 'red03'] as agent of red
INFO: Fetching the server token
+-------+---------+--------------------------------------------------+
| host  | success | stdout                                           |
+-------+---------+--------------------------------------------------+
| red01 | True    | [INFO]  Finding release for channel stable       |
|       |         | [INFO]  Using v1.20.5+k3s1 as release            |
|       |         | [INFO]  Downloading hash https://github.com/k3s- |
|       |         | io/k3s/releases/download/v1.20.5+k3s1/sha256sum- |
|       |         | arm.txt                                          |
|       |         | [INFO]  Downloading binary https://github.com/k3 |
|       |         | s-io/k3s/releases/download/v1.20.5+k3s1/k3s-armh |
|       |         | f                                                |
|       |         | [INFO]  Verifying binary download                |
|       |         | [INFO]  Installing k3s to /usr/local/bin/k3s     |
|       |         | [INFO]  Creating /usr/local/bin/kubectl symlink  |
|       |         | to k3s                                           |
|       |         | [INFO]  Creating /usr/local/bin/crictl symlink   |
|       |         | to k3s                                           |
|       |         | [INFO]  Creating /usr/local/bin/ctr symlink to   |
|       |         | k3s                                              |
|       |         | [INFO]  Creating killall script                  |
|       |         | /usr/local/bin/k3s-killall.sh                    |
|       |         | [INFO]  Creating uninstall script                |
|       |         | /usr/local/bin/k3s-agent-uninstall.sh            |
|       |         | [INFO]  env: Creating environment file           |
|       |         | /etc/systemd/system/k3s-agent.service.env        |
|       |         | [INFO]  systemd: Creating service file           |
|       |         | /etc/systemd/system/k3s-agent.service            |
|       |         | [INFO]  systemd: Enabling k3s-agent unit         |
|       |         | [INFO]  systemd: Starting k3s-agent              |
... Some output removed for brevity
```

### Verify the K3S Cluster Install

Let us check that server reports the appropriate nodes as members.

```
you@your-laptop:~$ cms host ssh red \" sudo kubectl get nodes \"
host ssh red " sudo kubectl get nodes "
+------+---------+--------------------------------------------------+
| host | success | stdout                                           |
+------+---------+--------------------------------------------------+
| red  | True    | NAME    STATUS   ROLES                  AGE      |
|      |         | VERSION                                          |
|      |         | red01   Ready    <none>                 15m      |
|      |         | v1.20.5+k3s1                                     |
|      |         | red02   Ready    <none>                 15m      |
|      |         | v1.20.5+k3s1                                     |
|      |         | red03   Ready    <none>                 15m      |
|      |         | v1.20.5+k3s1                                     |
|      |         | red     Ready    control-plane,master   16m      |
|      |         | v1.20.5+k3s1                                     |
+------+---------+--------------------------------------------------+
```

### Adding a new machine to the cluster

We will add a new machine red04 to be an agent of the red hosted cluster.

```
you@your-laptop:~$ cms pi k3 install agent red04 red
pi k3 install agent red04 red
INFO: Installing K3s on red04 as agent of red
INFO: Fetching the server token
+-------+---------+--------------------------------------------------+
| host  | success | stdout                                           |
+-------+---------+--------------------------------------------------+
| red04 | True    | [INFO]  Finding release for channel stable       |
|       |         | [INFO]  Using v1.20.5+k3s1 as release            |
|       |         | [INFO]  Downloading hash https://github.com/k3s- |
|       |         | io/k3s/releases/download/v1.20.5+k3s1/sha256sum- |
|       |         | arm.txt                                          |
|       |         | [INFO]  Downloading binary https://github.com/k3 |
|       |         | s-io/k3s/releases/download/v1.20.5+k3s1/k3s-armh |
|       |         | f                                                |
|       |         | [INFO]  Verifying binary download                |
|       |         | [INFO]  Installing k3s to /usr/local/bin/k3s     |
|       |         | [INFO]  Creating /usr/local/bin/kubectl symlink  |
|       |         | to k3s                                           |
|       |         | [INFO]  Creating /usr/local/bin/crictl symlink   |
|       |         | to k3s                                           |
|       |         | [INFO]  Creating /usr/local/bin/ctr symlink to   |
|       |         | k3s                                              |
|       |         | [INFO]  Creating killall script                  |
|       |         | /usr/local/bin/k3s-killall.sh                    |
|       |         | [INFO]  Creating uninstall script                |
|       |         | /usr/local/bin/k3s-agent-uninstall.sh            |
|       |         | [INFO]  env: Creating environment file           |
|       |         | /etc/systemd/system/k3s-agent.service.env        |
|       |         | [INFO]  systemd: Creating service file           |
|       |         | /etc/systemd/system/k3s-agent.service            |
|       |         | [INFO]  systemd: Enabling k3s-agent unit         |
|       |         | [INFO]  systemd: Starting k3s-agent              |
+-------+---------+--------------------------------------------------+
```

### Uninstall the K3S Cluster

We can also easily uninstall the K3S cluster.

```
you@your-laptop:~$ cms pi k3 uninstall cluster red,red0[1-3]
pi k3 uninstall cluster red,red0[1-3]
INFO: Uninstalling agent install of K3s on ['red', 'red01', 'red02', 'red03', red04']
+-------+---------+--------------------------------------------------+
| host  | success | stdout                                           |
+-------+---------+--------------------------------------------------+
| red   | True    | /usr/bin/systemctl                               |
|       |         | Additional k3s services installed, skipping      |
|       |         | uninstall of k3s                                 |
| red01 | True    | /usr/bin/systemctl                               |
| red02 | True    | /usr/bin/systemctl                               |
| red03 | True    | /usr/bin/systemctl                               |
| red04 | True    | /usr/bin/systemctl                               |
+-------+---------+--------------------------------------------------+
INFO: Uninstalling server install of K3s on red
+------+---------+--------------------+
| host | success | stdout             |
+------+---------+--------------------+
| red  | True    | /usr/bin/systemctl |
+------+---------+--------------------+
```

### Add a New Standalone K3S Server

Now we will create a new standalone K3s server on red05.

```
anthony@anthony-ubuntu:~$ cms pi k3 install server red05
pi k3 install server red05
INFO: Installing K3s as stand-alone server on ['red05']
+-------+---------+--------------------------------------------------+
| host  | success | stdout                                           |
+-------+---------+--------------------------------------------------+
| red05 | True    | [INFO]  Finding release for channel stable       |
|       |         | [INFO]  Using v1.20.5+k3s1 as release            |
|       |         | [INFO]  Downloading hash https://github.com/k3s- |
|       |         | io/k3s/releases/download/v1.20.5+k3s1/sha256sum- |
|       |         | arm.txt                                          |
|       |         | [INFO]  Downloading binary https://github.com/k3 |
|       |         | s-io/k3s/releases/download/v1.20.5+k3s1/k3s-armh |
|       |         | f                                                |
|       |         | [INFO]  Verifying binary download                |
|       |         | [INFO]  Installing k3s to /usr/local/bin/k3s     |
|       |         | [INFO]  Creating /usr/local/bin/kubectl symlink  |
|       |         | to k3s                                           |
|       |         | [INFO]  Creating /usr/local/bin/crictl symlink   |
|       |         | to k3s                                           |
|       |         | [INFO]  Creating /usr/local/bin/ctr symlink to   |
|       |         | k3s                                              |
|       |         | [INFO]  Creating killall script                  |
|       |         | /usr/local/bin/k3s-killall.sh                    |
|       |         | [INFO]  Creating uninstall script                |
|       |         | /usr/local/bin/k3s-uninstall.sh                  |
|       |         | [INFO]  env: Creating environment file           |
|       |         | /etc/systemd/system/k3s.service.env              |
|       |         | [INFO]  systemd: Creating service file           |
|       |         | /etc/systemd/system/k3s.service                  |
|       |         | [INFO]  systemd: Enabling k3s unit               |
|       |         | [INFO]  systemd: Starting k3s                    |
+-------+---------+--------------------------------------------------+
```

To subsequently add this server as an agent to itself, you will need to run

```
cms pi k3 install agent red05 red05
```

### Uninstall a specific K3S server

```
cms pi k3 uninstall server red05
```

### Uninstall a Specific K3S Agent

```
cms pi k3 uninstall agent red06
```

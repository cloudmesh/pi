---
date: 2021-05-07
title: "Employ K3S on a Pi Cluster"
linkTitle: "Employ K3S on a Pi Cluster"
description: "Easily install your own K3S cluster on Raspberry Pis"
author: Anthony Orlowski, Richard Otten, Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io), Richard Otten
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{< imgproc image Fill "600x300" >}}
{{< /imgproc >}}


{{% pageinfo %}}

Install, manage, operate, and uninstall K3s on a cluster of Raspberry Pis 
running Raspberry OS or Ubuntu.

**Learning Objectives**

* Learn how to easily install, manage, operate, and unisntall a K3S cluster 
  using `cms`.
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## 1. Introduction

K3S provides a lightweight, single binary distribution of Kubernetes with 
very close feature parity to K8s that is perfect for single board computers 
like the Raspberry Pi. In this tutorial we will install, verify, and 
unistall K3s on a cluster of Pis that was created using the Cloudmesh burn 
software.

## 2. Prequisites

This tutorial assumes a cluster burned using one of the following methods:

[Burn a Raspberry OS Cluster](https://cloudmesh.github.io/pi/tutorial/raspberry-burn/)

[Burn an Ubuntu Cluster](https://cloudmesh.github.io/pi/tutorial/ubuntu-burn/)

[Use our GUI to Burn a Cluster](https://cloudmesh.github.io/pi/tutorial/gui-burn/)

The tutorial supports both Raspberry OS and Ubuntu with no required user 
input change.

## 3. CMS k3 Commands
```
        pi k3 enable containers NAMES
        pi k3 install server NAMES
        pi k3 install agent NAMES SERVER
        pi k3 install cluster NAMES
        pi k3 uninstall server NAMES
        pi k3 uninstall agent NAMES
        pi k3 uninstall cluster NAMES
        pi k3 kill NAMES
        pi k3 start server NAMES
        pi k3 start agent NAMES
        pi k3 start cluster NAMES
        pi k3 stop server NAMES
        pi k3 stop agent NAMES
        pi k3 stop cluster NAMES
        pi k3 remove node NAMES SERVER
        pi k3 cluster info SERVER
        pi k3 dashboard create SERVER
        pi k3 dashboard connect SERVER
        pi k3 dashboard disconnect [SERVER]
        pi k3 dashboard info
        pi k3 dashboard
```

## 4. Enable Containers

This command adds `'cgroup_enable=cpuset cgroup_memory=1 
cgroup_enable=memory'` to the end of the arguments in `cmdline.txt` if 
they are not already present, and reboots the machines. This is required to 
enable containers in the kernel.

```
you@your-laptop:~$ cms pi k3 enable containers red,red0[1-3]
pi k3 enable containers red,red0[1-3]
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

## 5. Install K3s on the Entire Cluster

This command wil install a K3S cluster with the manager (red) acting as the K3s
server, and the workers and the manager will be installed as agents of that 
server. This also installs and configures a Web UI Dashboard.

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

## 6. Verify the K3S Cluster Install

Wait a moment for k3s to set up initial containers.

Let us check that server reports the appropriate nodes as members.

We can run remote commands with the `cms host ssh` command as well as using 
K3S specific commands.

For example to get cluster information we can run

```
you@your-laptop:~$ cms pi k3 cluster info red
pi k3 cluster info red
INFO: Getting cluster info for red
INFO: sudo kubectl get nodes -o wide
NAME    STATUS   ROLES                  AGE   VERSION        INTERNAL-IP   EXTERNAL-IP    OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
red03   Ready    <none>                 28s   v1.20.5+k3s1   10.1.1.4      <none>         Raspbian GNU/Linux 10 (buster)   5.10.17-v7l+     containerd://1.4.4-k3s1
red02   Ready    <none>                 30s   v1.20.5+k3s1   10.1.1.3      <none>         Raspbian GNU/Linux 10 (buster)   5.10.17-v7l+     containerd://1.4.4-k3s1
red01   Ready    <none>                 27s   v1.20.5+k3s1   10.1.1.2      <none>         Raspbian GNU/Linux 10 (buster)   5.10.17-v7l+     containerd://1.4.4-k3s1
red     Ready    control-plane,master   84s   v1.20.5+k3s1   10.1.1.1      192.168.1.22   Raspbian GNU/Linux 10 (buster)   5.10.17-v7l+     containerd://1.4.4-k3s1
INFO: Server node token
K106f1caa41b133e69a69b1e3ac1da3a451393029e382be846eb0bcb7dfc7eab2db::server:2d604411ff6ab2a7c162bc4e82292690
INFO: Containers running on nodes
NODE: red03
CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID
a24076569fa00       7d23a14d38d24       5 seconds ago       Running             lb-port-443         0                   70adcf7269a03
3332e6b1f602d       7d23a14d38d24       6 seconds ago       Running             lb-port-80          0                   70adcf7269a03
2f1273e3eca91       d24dd28770a36       15 seconds ago      Running             metrics-server      0                   0ca2190dba121

NODE: red02
CONTAINER           IMAGE               CREATED             STATE               NAME                     ATTEMPT             POD ID
be2ca6f1b77a5       7d23a14d38d24       5 seconds ago       Running             lb-port-443              0                   fc85e830e60bd
98ae1280e7a59       7d23a14d38d24       6 seconds ago       Running             lb-port-80               0                   fc85e830e60bd
ebcc2edeb3926       1e695755cc09d       13 seconds ago      Running             local-path-provisioner   0                   140da1f145714

NODE: red01
CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID
bb4a9295bc345       7d23a14d38d24       1 second ago        Running             lb-port-443         0                   9fc4bec3faae0
6ba339136ae1a       944e5aba28f45       1 second ago        Running             traefik             0                   87ce8f8685767
491c2d8832f8d       7d23a14d38d24       1 second ago        Running             lb-port-80          0                   9fc4bec3faae0
d12b76e2c51e7       a0ce6ab869a69       12 seconds ago      Running             coredns             0                   a1777698c457c

NODE: red
CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID
afa997d47eb33       7d23a14d38d24       4 seconds ago       Running             lb-port-443         0                   524fcbbd2b879
d0921db7d2229       7d23a14d38d24       5 seconds ago       Running             lb-port-80          0                   524fcbbd2b879
```

Or we can run the commands directly with `cms host ssh` as demonstrated 
below. This is useful for commands that may not be built into cms, or that 
the user knows better than the cms shell commands. 

>NOTE: `cms host ssh` 
>commands go are interpreted first by bash and then by python, complex 
>commands may not work without complex escape sequences.

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

## 7. Creating the Dashboard.

It is straightforward to create a dashboard for our newly created cluster.

If using Raspberry OS on the pis, run:

```
you@your-laptop:~$ cms pi k3 dashboard create red
```

If using Ubuntu Server on the pis, run:

```
you@your-laptop:~$ cms pi k3 dashboard create red --ubuntu
```

Both commands will automatically start the dashboard. However, on Ubuntu Server, `cms pi k3 dashboard start red` needs to be run when the pi is rebooted.


## 8. Accessing the Dashboard

We can easily access the Web UI Dashboard for easy management of our cluster.

First, let us connect to the new dashboard created above.

```
you@your-laptop:~$ cms pi k3 dashboard connect red
```

We should get a green "Connection created" message. We can now check on the status of our dashboard and obtain our token to log in. 

```
you@your-laptop:~$ cms pi k3 dashboard info
pi k3 dashboard info
INFO: Finding running dashboards...
+---------------------+-------------+------------+------------------+-------+
| Server Access Point | Remote Port | Local Port | Dashboard Status | PID   |
+---------------------+-------------+------------+------------------+-------+
| red                 | 8001        | 8001       | Active           | 99240 |
+---------------------+-------------+------------+------------------+-------+
INFO: Dashboard Link:
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
INFO: Fetching authentication token...
# A long token will go here
```

> Note. If `Dasboard Status` says "Up but not ready", the k3s dashboard is still likely in the process of coming online. Wait a few moments and try the info command again.

Take note of the authentication token given. To open the dashboard, you may click on the link provided by the info command or use the following command to automaticallly open in browser.

```
you@your-laptop:~$ cms pi k3 dashboard
pi k3 dashboard
Opening dashboard...
```

When ready, you can then disconnect from your dashboard with the following:

```
you@your-laptop:~$ cms pi k3 dashboard disconnect
```

## 9. Adding a new machine to the cluster

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

## 10. Uninstall the K3S Cluster

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

## 11. Add a New Standalone K3S Server

Now we will create a new standalone K3s server on red05.

```
you@your-laptop:~$ cms pi k3 install server red05
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
you@your-laptop:~$ cms pi k3 install agent red05 red05
```

## 12. Uninstall a specific K3S server

```
you@your-laptop:~$ cms pi k3 uninstall server red05
```

## 13. Uninstall a Specific K3S Agent

```
you@your-laptop:~$ cms pi k3 uninstall agent red06
```

## 14. Kill all K3S Services and Containers on Hosts 

This command runs the K3s provided `k3s-kill-all.sh` script that "cleans up containers, K3s directories, and networking components while also removing the iptables chain with all the associated rules. The cluster data will not be deleted."


```
you@your-laptop:~$ cms pi k3 kill red,red0[1-3]
pi k3 kill red,red0[1-3]
INFO: Stopping k3s services and containers on ['red01', 'red02', 'red03']
+-------+---------+--------+
| host  | success | stdout |
+-------+---------+--------+
| red01 | True    |        |
| red02 | True    |        |
| red03 | True    |        |
+-------+---------+--------+
INFO: Stopping k3s services and containers on red
+------+---------+--------+
| host | success | stdout |
+------+---------+--------+
| red  | True    |        |
+------+---------+--------+
```

## 15. Start the K3S Cluster Services

This command starts systemd the services `k3s` for the server and `k3s-agent` 
for 
the agents.

```
you@your-laptop:~$ cms pi k3 start cluster red,red0[1-3]
pi k3 start cluster red,red0[1-3]
INFO: Starting server on red
+------+---------+--------+
| host | success | stdout |
+------+---------+--------+
| red  | True    |        |
+------+---------+--------+
INFO: Starting agent on ['red', 'red01', 'red02', 'red03']
+-------+---------+--------+
| host  | success | stdout |
+-------+---------+--------+
| red   | True    |        |
| red01 | True    |        |
| red02 | True    |        |
| red03 | True    |        |
+-------+---------+--------+
```

## 16. Stop the K3S Cluster Services

This command stops the systemd services `k3s` for the server and `k3s-agent` 
for 
the agents.

```
you@your-laptop:~$ cms pi k3 stop cluster red,red0[1-3]
pi k3 stop cluster red,red0[1-3]
INFO: Stopping server on red
+------+---------+--------+
| host | success | stdout |
+------+---------+--------+
| red  | True    |        |
+------+---------+--------+
INFO: Stopping agent on ['red', 'red01', 'red02', 'red03']
+-------+---------+--------+
| host  | success | stdout |
+-------+---------+--------+
| red   | True    |        |
| red01 | True    |        |
| red02 | True    |        |
| red03 | True    |        |
+-------+---------+--------+
```

## 17. Remove a Node from the Cluster

Let us remove red01 from the K3s cluster server red.

```
you@your-laptop:~$ cms pi k3 remove node red01 red
pi k3 remove node red01 red
INFO: Removing agents red01 from server red
INFO: Draining agent red01
+------+---------+---------------------+
| host | success | stdout              |
+------+---------+---------------------+
| red  | True    | node/red01 cordoned |
|      |         | node/red01 drained  |
+------+---------+---------------------+
INFO: Deleting agents red01
+------+---------+----------------------+
| host | success | stdout               |
+------+---------+----------------------+
| red  | True    | node "red01" deleted |
+------+---------+----------------------+
```


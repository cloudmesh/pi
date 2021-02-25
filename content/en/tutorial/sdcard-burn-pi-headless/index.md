---
date: 2021-02-23
title: "Easy Raspberry PI Cluster Setup with Cloudmesh from MacOS"
linkTitle: "Burn many PI SD Cards from MacOS"
description: >
  Set up many SD Cards directly from MacS that are preconfigured to create PI clusters.
author: Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com), [laszewski.github.io](https://laszewski.github.io)), 
  Richard Otten, 
  Anthony Orlowski
  Adam ...
categories:
- tutorial
tags:
- Raspberry Pi
- Cluster  
- SD Cards
- Burn
- Tutorial
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc macpi Fill "600x300" >}}
{{< /imgproc >}}

<!--
## Upload an image

![Many Pi's](many-pis.jpg)
-->


{{% pageinfo %}}

In this tutorial, we explain how to easily set up a cluster of Pis on a Mac
while burning preconfigured SD Cards. We assume you use an SD Card reader/writer that
is plugged into your manager PI that we configure initially with Pi Imager.

**Learning Objectives**

* Learn how to use cloudmesh burn to create many SD Cards for a cluster
* Test the cluster after burning
* Focus on the setup for a Mac
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## 1. Introduction

Over time we have seen many efforts to create Clusters using Pi's as a
platform. There are many reasons for this. You have full control over the PIs,
you use an inexpensive platform, and you use a highly usable platform
and provides an enormous benefit to get educated about cluster computing in
general.

There are different methods of how to set up a cluster. This includes setups
that are known under the terms *headless*, *network booting*, and *booting from
SD Cards*. Each of the methods has its advantages and disadvantages. However,
the last method is most familiar to the users in the Pi community that come
from single Pis. While reviewing the many efforts that describe a cluster set up
most of them contain many complex steps that require a significant amount of
time as they are executed individually on these Pis. Even starting is
non-trivial as a network needs to be set up to access them. 

Despite the much improved Pi imager and the availability of Pi bakery, the
process is still involved. So we started asking:

> Is it possible to develop a tool that is specifically targeted to burn 
> SDCards for the PIs in a cluster one at a time, so we can just  plug 
> the cards in, and with minimal effort start the cluster that simply works?

You are in luck, we have spent some time to develop such a tool and present it at 
as part of [PiPlanet](https://piplanet.org)[^piplanet] 
. No more
spending hours upon hours to replicate the steps, learn complex DevOps
tutorials, but instead get a cluster set up easily with just a few commands.

For this, we developed `cms burn` which is a program that you can execute
either on a "manager" Pi (or in a Linux or macOS computers) to burn cards for
your cluster. 

We have set up on GitHub a comprehensive package that can be installed easily
we hope that it is useful to you. All of this is discussed in detail at the
[cloudmesh-pi-burn README](https://github.com/cloudmesh/cloudmesh-pi-burn/blob/main/README.md)[^README].
There you can also find detailed instructions on how to use a Mac or Linux
computer to burn directly from them. To showcase to you how easy it is to use
we demonstrate here the setup of a cluster with five nodes.

## 2. Requirements

* 5 Raspberry Pis
* 5 SD Cards
* Network Switch (unmanaged or managed)
* 5 Ethernet Cables
* Wifi Access
* Monitor, Mouse, Keyboard (for desktop access on Pi)
* 1 SD Card Burner(s) (we recommend one that supports USB 3.0 speeds)
* XCode and brew installed on the Mac
* Software from Paragon that allows write access to ext4 from MacOS ($40)

For a list of possible part choices, please see:

* [Parts Choices](/pi/docs/hardware/parts/)[^parts]

## 3. The Goal

We will be creating the following setup using **5 Raspberry Pis** (you need a
minimum of 2, but our method works also for larger numbers of PIs).
Consequentially, you will also need 5 SD cards for each of the 5 Pis.
You will also want a network switch (managed or unmanaged) with 5 ethernet
cables (one for each Pi).

Figure 1 shows our network configuration. From the five Raspberry Pis, one is
dedicated as a manager and four as workers. We use WiFi between the manager
PI to allow for you to set it up anywhere in your house or dorm (other
configurations are discussed in the 
[README](https://github.com/cloudmesh/cloudmesh-pi-burn/blob/main/README.md)).

We use an unmanaged network switch, where the manager and workers can
communicate locally with each other, and the manager provides
internet access to the workers via a bridge that we configure for you.

![](https://github.com/cloudmesh/cloudmesh-pi-burn/raw/main/images/network-bridge.png)

Figure 1: Pi Cluster setup with bridge network

## 4. Set up the Cloudmesh burn program on your Mac

On your Mac do the following. First set up a Python `venv`:

```bash
user@mac $ python3 -m venv ~/ENV3
user@mac $ source ~/ENV3/bin/activate
````

Next, install the cloudmesh cluster generation tools and start the burn process

```bash
(ENV3) user@mac $ pip install cloudmesh-pi-cluster
(ENV3) user@mac $ cms help
(ENV3) user@mac $ cms burn info 
(ENV3) user@mac $ cms burn cluster --device=/dev/disk2 --hostname=red,red01,red02 --ssid=myssid -y -g
````

Fill out the passwords and plug in the cards as requested. 

## 5. Start your Cluster and Configure it

After the burn is completed, plug them in your PIs and switch them on. On you
Mac execute the ssh command to log into your manager we called red. Worker nodes
have a number in them.



```bash
(ENV3) user@mac $ ssh pi@red.local  
```

This will take a while as the file system on the SD Cards need to be installed and 
configurations such as country, ssh, and wifi need to be activated.

Once you are in the manager install cloudmesh cluster software also in it (we
could have done this automatically, but decided to leave that part of the
process up to you in case you to give you maximum flexibility).

```bash
pi@red:~ $ curl -Ls http://cloudmesh.github.io/get/pi | sh -
```

.. after lots of log messages, you will see ...

```
#################################################
# Install Completed                             #
#################################################
Time to update and upgarde: 339 s
Time to install the venv:   22 s
Time to install cloudmesh:  185 s
Time for total install:     546 s
Time to install: 546 s
#################################################
Please activate with
    source ~/ENV3/bin/activate
    
```

Now just reboot with 

```bash
pi@red:~ $ sudo reboot
```

## 6. Use your Cluster

On your Mac  say again 

```
user@mac $ ssh pi@red.local
```

Once you are logged in in your manager named red.local on the network execute a
command to see if things work. Use our temperature monitor to get the
temperature from all PIs. This will allow you to see if they are all working.

```bash
(ENV3) pi@red:~ $ cms pi temp red01,red02

pi temp red01,red02
+--------+--------+-------+----------------------------+
| host   |    cpu |   gpu | date                       |
|--------+--------+-------+----------------------------|
| red01  | 45.277 |  45.2 | 2021-02-23 22:13:11.788430 |
| red02  | 42.842 |  42.8 | 2021-02-23 22:13:11.941566 |
+--------+--------+-------+----------------------------+
```

## 8. Accessing the workers from the Mac

To makes it even more convenient, we want to access the workers directly form the 
Mac. For this reason we have designed a tunnel command that makes teh setu real easy.
You call it on teh manager node as follows

```bash
(ENV3) pi@red:~ $ cms host setup red00[1-2] user@mac.local 
```

THis will print out a file that that you need to opy theinto  to your
`~/.ssh/config` file on your Mac. We will soon have a command that will add
them for you without using an editor.

```
# ----------------------------------------------------------------------
# copy to ~/.ssh/config on remote host (i.e laptop)
# ----------------------------------------------------------------------

Host red
     HostName red.local
     User pi

Host red001
     HostName red.local
     User pi
     Port 8001

Host red002
     HostName red.local
     User pi
     Port 8002
```

Now you are all set to access the workers on your Mac. Try it out with 
the temperature program

```bash
(ENV3) user@mac:~ $ cms pi temp red,red00[1-2]              

+--------+--------+-------+----------------------------+
| host   |    cpu |   gpu | date                       |
|--------+--------+-------+----------------------------|
| red    | 50.147 |  50.1 | 2021-02-18 21:10:05.942494 |
| red001 | 51.608 |  51.6 | 2021-02-18 21:10:06.153189 |
| red002 | 45.764 |  45.7 | 2021-02-18 21:10:06.163067 |
+--------+--------+-------+----------------------------+
```

## 7. More Information

As we use ssh keys to authenticate between manager and workers, you can 
directly log into the workers from the manager.

More details are provided on our web pages at

* [README](https://github.com/cloudmesh/cloudmesh-pi-burn/blob/main/README.md)
* [piplanet.org](https://piplanet.org)

Other cloudmesh components are discussed in the [cloudmesh manual](<https://cloudmesh.github.io/cloudmesh-manual/>)[^cloudmesh-manual].


## Acknowledgement

We would like to thank the following community members for testing the recent
versions:
Venkata Sai Dhakshesh Kolli,
Rama Asuri,
Adam Ratzman.
Previous versions of the software obtained code contributions from 
Sub Raizada,
Jonathan Branam,
Fugang Wnag,
Anand Sriramulu, 
Akshay Kowshik.

## References

[^cloudmesh-manual]: Cloudmesh Manual, <https://cloudmesh.github.io/cloudmesh-manual/>
[^piplanet]: PiPlanet Web Site, <https://piplanet.org>
[^parts]: Parts for building clusters, <https://cloudmesh.github.io/pi/docs/hardware/parts/>
[^README]: Cloudmesh pi burn README, <https://github.com/cloudmesh/cloudmesh-pi-burn/blob/main/README.md>







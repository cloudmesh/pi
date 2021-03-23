---
date: 2021-03-23
title: "Burning a set of pre-configured Raspberry OS cards for Raspberry Pis with Wifi Access"
linkTitle: "Burning an Raspberry OS Cluster"
description: "A comprehensive tutorial of burning an Raspberry OS cluster with internet access through a single point"
author: Richard Otten, Anthony Orlowski,  Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: False
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" />}}

{{% pageinfo %}}

In this tutorial, we explain how to easily set up a cluster of Pis with pre-configured RaspberryOS cards.

**Learning Objectives**

* Learn how to use cloudmesh-burn to create a RaspberryOS cluster
* Test the cluster after burning

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

## 1. Introduction

With the release of [Pi Imager 1.6](https://www.raspberrypi.org/blog/raspberry-pi-imager-update-to-v1-6/), it
has become clear how to properly configure a Raspberry Pi (running Raspberry OS. Ubuntu [here](https://cloudmesh.github.io/pi/tutorial/ubuntu-burn/)) on boot. One may manipulate the `cmdline.txt` on the boot partition to run any arbitrary script on boot.

Here, we allow users to circumnavigate the reasearch involved in order to properly configure a Raspberry OS Pi on boot.

In this tutorial, we will demonstrate the usage of `cms`: a set of useful commands for cluster configurations among other things. Some features demonstrated here include the following:

* Set hostname
* Enable SSH
* WiFi Configuration
* Locale Settings
* Skip First-run Wizard
* Change Password for pi user
* Add authorized keys for pi user
* Configure a static IP on the ethernet (eth0) interface along with routing preferences
* Configure a WiFi "bridge" for a Pi to act as a router to a cluster of Pis

In this tutorial, we will demonstrate the usage of `cms` by creating a cluster of 4 pis (1 manager, 3 workers) where we
connect the manager to the internet (Wifi) and configure the workers to access the internet through the manager via
ethernet connection. This might be useful for those with restricted internet access where devices must be registered
by MAC Address or through browser login.

## 2. Pre-requisites

* Computer/Laptop with MacOS or Linux. (Windows not supported yet)
* `python3 --version` > 3.8
* WiFi SSID and Password
* 4 Raspberry Pis and 4 SD Cards with power cables (For the purposes of this tutorial)
* 4 Ethernet Cables (For the purposes of this tutorial)
* An (un)managed ethernet switch (For the purposes of this tutorial)

## 3. Installing cloudmesh and Setup

It is always wise to create virtual environments when you do not envision needing a python package consistently. Let us
create one for this tutorial.

On your Linux/Mac, open a new terminal.

```bash
you@yourlaptop $ python3 -m venv ~/CLOUDMESH
```

The above will create a new python virtual environment. Activate it with the following.

```bash
you@yourlaptop $ source ~/CLOUDMESH/bin/activate
```

Verify your `python` and `pip` are correct

```bash
you@yourlaptop $ which python
~/CLOUDMESH/bin/python

you@yourlaptop $ which pip
~/CLOUDMESH/bin/pip
```

Update `pip`.

```bash
you@yourlaptop $ pip install --upgrade pip
```

Install `cloudmesh-installer`

```bash
you@yourlaptop $ pip install cloudmesh-installer
```

Create a new directory `~/cm` and `cd` into it

```bash
you@yourlaptop $ mkdir ~/cm
you@yourlaptop $ cd ~/cm
```

Install the correct cloudmesh-repos with the following. In the future, we
will make this a PyPI package.

```bash
you@yourlaptop $ cloudmesh-installer get pi
```

Finally, ensure you have an RSA key pair in `~/.ssh`. You can create one as follows. Use the default location in `~/.ssh/id_rsa`

```bash
you@yourlaptop $ ssh-keygen
```

We will use this default key to access our cluster after burning

## 4. Writing our cluster configuration

Cloudmesh has a simple system for managing cluster configs. This system is a "cloudmesh inventory".

We can first add a manager with cluster subnet IP `10.1.1.1`. We also add the `bridge` service which is
recognized by `cms` as the Wifi bridge service connecting devices on eth0 to the internet.

We also set the timezone and locale here. You may want to change them as you wish

```bash
you@yourlaptop $ cms inventory add manager --service=manager --ip=10.1.1.1 --tag=latest-lite --timezone="America/Indiana/Indianapolis" --locale="us"
you@yourlaptop $ cms inventory set manager services to "bridge" --listvalue
```

We can then add the workers

```bash
you@yourlaptop $ cms inventory add "worker00[1-3]" --service=worker --ip="10.1.1.[2-4]" --router=10.1.1.1 --tag=latest-lite  --timezone="America/Indiana/Indianapolis" --locale="us"
you@yourlaptop $ cms inventory set "worker00[1-3]" dns to "8.8.8.8,8.8.4.4" --listvalue
```
> Note we are using Google's DNS here [8.8.8.8, 8.8.4.4]

Our cluster configuration is now complete. You may run the following to list your configuration. We include ours for a sanity check:

```bash
you@yourlaptop $ cms inventory list
+-----------+-------------+---------+---------+------------+----------+------------------------+----------+--------+------------------------------+--------+---------+-------------+-------------------+
| host      | tag         | cluster | service | services   | ip       | dns                    | router   | locale | timezone                     | owners | comment | description | keyfile           |
+-----------+-------------+---------+---------+------------+----------+------------------------+----------+--------+------------------------------+--------+---------+-------------+-------------------+
| manager   | latest-lite |         | manager | ['bridge'] | 10.1.1.1 |                        |          | us     | America/Indiana/Indianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| worker001 | latest-lite |         | worker  |            | 10.1.1.2 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | us     | America/Indiana/Indianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| worker002 | latest-lite |         | worker  |            | 10.1.1.3 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | us     | America/Indiana/Indianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| worker003 | latest-lite |         | worker  |            | 10.1.1.4 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | us     | America/Indiana/Indianapolis |        |         |             | ~/.ssh/id_rsa.pub |
+-----------+-------------+---------+---------+------------+----------+------------------------+----------+--------+------------------------------+--------+---------+-------------+-------------------+
```

## 5. Burning the Cluster

First, we must install the correct Raspberry OS image. We use the latest Raspberry OS lite version. We can do it as follows:

```bash
you@yourlaptop $ cms burn image get latest-lite
```

This will take a few moments...

After the image is downloaded, we are ready to burn. Plug in your first SD Card into your card
writer. Check your writer's path with the following:

```bash
you@yourlaptop $ cms burn info
# ----------------------------------------------------------------------
# SD Cards Found
# ----------------------------------------------------------------------

+----------+------------------------+-------------+------------------+--------------+------------+---------+----------+-------------+-------------+
| Path     | Info                   | Formatted   | Size             | Plugged-in   | Readable   | Empty   | Access   | Removable   | Writeable   |
|----------+------------------------+-------------+------------------+--------------+------------+---------+----------+-------------+-------------|
| /dev/sdb | Generic STORAGE DEVICE | True        | 64.1 GB/59.7 GiB | True         | True       | False   | True     | True        | True        |
+----------+------------------------+-------------+------------------+--------------+------------+---------+----------+-------------+-------------+
```

Record the path for the SDCard. In this case, it is `/dev/sdb`

> Note we omit some output of `cms burn info` for clarity.
> On MacOS, you may get an `ERROR: We could not find your USB reader in the list of known readers`. This can be ignored. Additionally, `cms burn info` will list the partitions as well. For example, if you see the path `/dev/disk2s1` and `/dev/disk2s2`, then your device is `/dev/disk2`.

We can now start burning the cluster. We start with the manager and enable WiFi on it. We also give it a password
for keyboard login: "cloudmesh" in this case.

```bash
you@yourlaptop $ cms burn raspberry "manager" --device=/dev/disk2 --ssid="SSID" --wifipassword="WIFI_PASSWORD" --password="cloudmesh" --country="US"
```

Now we can do the workers.

```bash
you@yourlaptop $ cms burn raspberry "worker00[1-3]" --device=/dev/disk2 --password="cloudmesh"
```

After each card is burned, `cms burn raspberry` will prompt you to swap cards to burn the next host.

After all cards have been burned, we can now plug in all our cards into our raspberry pis and boot. Ensure
that your workers and manager are connected into the same network switch via ethernet. Ensure this network
switch does not have internet access in itself. We will use the manager as the sole point of internet access here.

## 6. Burn Verification

After you boot, we recommend waiting 1-2 minutes for boot setup to complete.

First, ensure you have access to your manager by ssh'ing into it. After ssh'ing, verify internet connection
with a simple ping.

```bash
you@yourlaptop $ ssh pi@manager.local
pi@manager $ ping google.com
PING google.com (142.250.64.238) 56(84) bytes of data.
64 bytes from mia07s57-in-f14.1e100.net (142.250.64.238): icmp_seq=1 ttl=101 time=54.4 ms
64 bytes from mia07s57-in-f14.1e100.net (142.250.64.238): icmp_seq=2 ttl=101 time=74.6 ms
```

> Hint: Use ctrl+c to keyboard interrupt and stop the ping.

Note that if the ping fails or if you cannot ssh into your manager, then the cluster setup has failed as this means
that neither the manager nor workers have internet connection.

Next, let's verify connection to our workers. You may want to do the following for all hosts, but we only show one for now.

```bash
pi@manager $ exit
you@yourlaptop $ ssh -J pi@manager.local pi@worker001.local
pi@worker001 $
```

You should be able to ssh into the worker with no issues after accepting the fingerprint.

Let us now verify internet connection with proper routing through the following:

```bash
pi@worker001 $ traceroute google.com
traceroute to google.com (216.58.192.174), 30 hops max, 60 byte packets
 1  manager (10.1.1.1)  0.243 ms  0.295 ms  0.218 ms
 2  10.20.76.1 (10.20.76.1)  2.754 ms  2.306 ms  2.573 ms
 3  50.230.235.89 (50.230.235.89)  5.207 ms  5.798 ms  5.723 ms
 ...
 # Some output ommitted for clarity
```

> Hint: If traceroute isn't terminating, you can use ctrl+c to keyboard interrupt and terminate traceroute.

Note here how the first line of the result of `traceroute` indicates we went through the `manager` at ip `10.1.1.1`
to access the internet. This is expected.

Our cluster is now complete, and we have verified proper burning. We may now do other interesting things with this cluster (such as installing `k3s`)
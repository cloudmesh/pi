---
date: 2021-02-07
title: "Burning a set of Ubuntu Server Cards for Raspberry Pis with Internet Access"
linkTitle: "Burning an Ubuntu Cluster"
description: "A comprehensive tutorial of burning an Ubuntu cluster with internet access"
author: Richard Otten, Anthony Orlowski,  Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: False
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" />}}

{{% pageinfo %}}

In this tutorial, we explain how to easily set up a cluster of Pis with pre-configured Ubuntu cards
initialized with custom cloud-init configurations.

**Learning Objectives**

* Learn how to use cloudmesh-burn to create an ubuntu cluster
* Test the cluster after burning

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

## 1. Introduction

Cloud-init provides powerful tools for configuring an Ubuntu Server. It allows users to configure network
information, add authorized keys, run commands on boot, and other useful tasks to set up the operating system. While cloud-init is a very
powerful tool, it requires knowledge to use it properly and therefore has a high learning curve when it comes to cluster-specific tasks such as using user data and network configurations
to get a cluster operational.

For this reason, we provide a simple set of commands to not only burn SD Cards with ubuntu server but to augment them with configurations for cloud-init
to set up a cluster correctly.

In this tutorial, we will burn a cluster of Raspberry Pis with Ubuntu Server per a user-friendly configuration.
This cluster will have wifi access from the manager, and the manager will act as a router for the workers (in that all
internet traffic is routed through the manager). This type of setup is useful for those with restricted internet access
(no access to modem), especially those that are required to register the MAC addresses of their devices. With a cluster
of 10 or more nodes, this can be quite tedious to do.

## 2. Pre-requisites

* Computer/Laptop with MacOS or Linux. (Windows not supported yet)
* `python3 --version` > 3.8
* 4 Raspberry Pis and 4 SD Cards with power cables
* WiFi SSID and Password
* 4 Ethernet Cables
* An (un)managed ethernet switch

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

Because this is pre-release, we must use `origin/ubuntu` in `cloudmesh-pi-burn`.

```bash
you@yourlaptop $ cd cloudmesh-pi-burn
you@yourlaptop $ git checkout ubuntu
```

Finally, ensure you have an RSA key pair in `~/.ssh`. You can create one as follows. Use the default location in `~/.ssh/id_rsa`

```bash
you@yourlaptop $ ssh-keygen
```

## 4. Writing our cluster configuration

Cloudmesh has a simple system for managing cluster configs. This system is a "cloudmesh inventory".

We can first add a manager with cluster subnet IP `10.1.1.2`

```bash
you@yourlaptop $ cms inventory add manager --service=manager --ip=10.1.1.2 --tag=ubuntu-20.10-64-bit
you@yourlaptop $ cms inventory set manager services to bridge --listvalue
```

We can then add the workers

```bash
you@yourlaptop $ cms inventory add "worker00[1-3]" --service=worker --ip="10.1.1.[3-5]" --router=10.1.1.2 --tag=ubuntu-20.10-64-bit
you@yourlaptop $ cms inventory set "worker00[1-3]" dns to "8.8.8.8,8.8.4.4" --listvalue
```

Our cluster configuration is now complete. You may run the following to list your configuration. We include ours for a sanity check:

```bash
you@yourlaptop $ cms inventory list
+-----------+---------------------+---------+---------+------------+----------+------------------------+----------+--------+----------+--------+---------+-------------+-------------------+
| host      | tag                 | cluster | service | services   | ip       | dns                    | router   | locale | timezone | owners | comment | description | keyfile           |
+-----------+---------------------+---------+---------+------------+----------+------------------------+----------+--------+----------+--------+---------+-------------+-------------------+
| manager   | ubuntu-20.10-64-bit |         | manager | ['bridge'] | 10.1.1.2 |                        |          |        |          |        |         |             | ~/.ssh/id_rsa.pub |
| worker001 | ubuntu-20.10-64-bit |         | worker  |            | 10.1.1.3 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.2 |        |          |        |         |             | ~/.ssh/id_rsa.pub |
| worker002 | ubuntu-20.10-64-bit |         | worker  |            | 10.1.1.4 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.2 |        |          |        |         |             | ~/.ssh/id_rsa.pub |
| worker003 | ubuntu-20.10-64-bit |         | worker  |            | 10.1.1.5 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.2 |        |          |        |         |             | ~/.ssh/id_rsa.pub |
+-----------+---------------------+---------+---------+------------+----------+------------------------+----------+--------+----------+--------+---------+-------------+-------------------+
```

## 5. Burning the Cluster

First, we must install the correct Ubuntu Server image. We can do it as follows:

```bash
you@yourlaptop $ cms burn image get ubuntu-20.10-64-bit
```

This will take a few moments...

After the image is downloaded, we are ready to burn. Plug in your first SD Card into your card
writer. This will be the manager card. Check your writer's path with the following:

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

We can now start burning the cluster.

```bash
you@yourlaptop $ cms burn ubuntu "manager,worker00[1-3]" --device=/dev/sdb --ssid="WIFI_SSID" --wifipassword="PASSWORD" --country="US" -v
```

After each card is burned, `cms burn ubuntu` will prompt you to swap cards to burn the next host.

After all cards have been burned, we can now plug in our cards into our raspberry pis and boot. We recommend you boot them all at the same time or the manager first.

## 6. Burn Verification

After you boot, we recommend waiting 2-3 minutes for the cloud-init boot process to complete.

First, ensure you have access to your manager by ssh'ing into it. After ssh'ing, verify internet connection
with a simple ping.

```bash
you@yourlaptop $ ssh ubuntu@manager.local
ubuntu@manager $ ping google.com
```

> Hint: Use ctrl+c to keyboard interrupt and stop the ping.

Note that if the ping fails or if you cannot ssh into your manager, then the cluster setup has failed as this means
that neither the manager nor workers have internet connection.

Next, let's verify connection to our workers. You may want to do the following for all hosts, but we only show one for now.

```bash
ubuntu@manager $ ssh worker001
```

You should be able to ssh into the worker with no issues after accepting the fingerprint.

Let us now verify internet connection with proper routing through the following:

```bash
ubuntu@worker001 $ traceroute google.com
traceroute to google.com (172.217.7.238), 64 hops max
  1   10.1.1.2  0.431ms  0.364ms  0.356ms
  2   10.20.76.1  2.422ms  2.194ms  2.416ms
  3   50.230.235.89  4.739ms  3.705ms  3.153ms
  4   96.108.121.229  2.906ms  3.191ms  3.933ms
  5   96.108.120.145  8.996ms  9.530ms  9.724ms
  6   24.153.88.85  18.129ms  17.197ms  16.679ms
  7   96.110.40.49  19.170ms  18.062ms  18.242ms
  8   96.110.33.202  18.955ms  17.627ms  17.063ms
  9   96.87.9.122  15.804ms  15.120ms  15.679ms
```

> Hint: If traceroute isn't terminating, you can use ctrl+c to keyboard interrupt and terminate traceroute.

Note here how the first line of the result of `traceroute` indicates we went through the `manager` at ip `10.1.1.2`
to access the internet. This is expected.

If you run into an issue with `traceroute` (for example, `command not found`), then there is likely an issue with
internet access. Verify your manager has WiFi access.

Our cluster is now complete, and we have verified proper burning. We may now do other interesting things with this cluster (such as installing `k3s`)


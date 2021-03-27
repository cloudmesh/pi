---
date: 2021-03-23
title: "Burning a set of pre-configured Raspberry OS cards for Raspberry Pis with Wifi Access"
linkTitle: "Burning an Raspberry OS Cluster"
description: "A comprehensive tutorial of burning an Raspberry OS cluster with internet access"
author: Richard Otten, Anthony Orlowski,  Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: False
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" />}}

{{% pageinfo %}}

In this tutorial, we explain how to easily set up a preconfigured cluster of Pis using RaspberryOS while only burning SD Cards. The cluster is ready to boot after all cards have been burned. No other configuration is needed.

**Learning Objectives**

* Learn how to use cloudmesh-burn to create a RaspberryOS cluster
* Test the cluster after burning

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

## 1. Introduction

With the release of [Pi Imager 1.6](https://www.raspberrypi.org/blog/raspberry-pi-imager-update-to-v1-6/), it is possible to properly configure a Raspberry Pi (running Raspberry OS. While pi-imager only uses a limited number of parameters, our system adds network configurations to create a cluster with a simple network configuration. In addition to using RaspberryOs, we also have another tutorial that showcases how to use [Ubuntu](https://cloudmesh.github.io/pi/tutorial/ubuntu-burn/)) as operating system. Our tutorials are useful as typically many steps are involved. We circumvent them by simply burning a card for each of the PIs.

For this purpose we developed a speciall command called  `cms burn`, that allows us to easily create such cards. THe features this command supports includes:

* Set the hostname
* Enables SSH
* Confugures WiFi
* Locale Settings
* Change Password for the pi user
* Add authorized keys for the pi user
* Configure a static IP on the ethernet (eth0) interface along with routing preferences
* Configure a WiFi "bridge" for a Pi to act as a router to a cluster of Pis
* Runs the configuration on first boot.

We demonstrate the usage of `cms burn` command by creating a cluster of 4 pis (1 manager, 3 workers) where we
connect the manager to the internet via Wifi and configure the workers to access the internet through the manager via
ethernet connection. This might be useful for those with restricted internet access where devices must be registered
by MAC Address or through browser login.

## 2. Pre-requisites

* Computer/Laptop with MacOS or Linux. (Windows is not supported, but could be easily added with your help)
* `python3 --version` > 3.8
* WiFi SSID and Password
* 4 Raspberry Pis and 4 SD Cards with power cables (For the purposes of this tutorial) A minimum of 2 is needed, one manager and 1 worker)
* 4 Ethernet Cables (For the purposes of this tutorial)
* An (un)managed ethernet switch (For the purposes of this tutorial)

For parts lists please see our linsk on [piplanet.org](https://cloudmesh.github.io/pi/docs/hardware/parts/)

## 3. Notation

IN our tutorial we define the manager hostname to be `red`, while each worker has a number in it `red01`, `red02`, `red03`

The following image shows our cluster configuration:

TODO: add image

## 4. Installing cloudmesh and Setup

It is best practice to create virtual environments when you do not envision needing a python package consistently. Let us
create one for this tutorial.

On your Linux/Mac, open a new terminal.

```bash
you@yourlaptop $ python3 -m venv ~/ENV3
```

The above will create a new python virtual environment. Activate it with the following.

```bash
you@yourlaptop $ source ~/ENV3/bin/activate
```

First, we update pip and verify your `python` and `pip` are correct

```bash
(ENV3) you@yourlaptop $ pip install --upgrade pip
(ENV3) you@yourlaptop $ which python
~/ENV3/bin/python

(ENV3) you@yourlaptop $ which pip
~/ENV3/bin/pip
```
### 4.1 Install from Pip

TODO: THis may not yet work, but will be after we merge our code to main and relaese

```bash
(ENV3) you@yourlaptop $ pip install cloudmesh-pi-cluster
```

### 4.2 Install from Source

If you are a developer that likes to add new features we recommend our source set up 

Next, we install our convenient `cloudmesh-installer`

```bash
(ENV3) you@yourlaptop $ pip install cloudmesh-installer
```

Create a new directory `~/cm` and `cd` into it

```bash
(ENV3) you@yourlaptop $ mkdir ~/cm
(ENV3) you@yourlaptop $ cd ~/cm
```

Install the correct cloudmesh-repos with the following. In the future, we
will make this a PyPI package.

```bash
(ENV3) you@yourlaptop $ cloudmesh-installer get pi
```

### 4.3 Create an SSH key

It is important that we can easily accesss the manager and worker nodes from the laptop/desktop. Hence we create a keypait in `~/.ssh`. You can create one as follows by accepting the default location in `~/.ssh/id_rsa`

```bash
(ENV3) you@yourlaptop $ ssh-keygen
```

Please use a unique and strong passphrase. We will use this default key to access our cluster after burning.

## 5. Burning the Cluster

We are now ready to burn our cluster. Start by plugging in your first SD Card into your card writer. Check your writer's path with the following:

```bash
(ENV3) you@yourlaptop $ cms burn info
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

This command will autodetect the SSID, locale, and country of your laptop. We recommend not to use the password flags for the wifipassword and sudo, as they will be likely stored in the command history and logs. They will be asked for interactively with during the following command.

Recall only the manager (red) will have wifi access here.

```bash
(ENV3) you@yourlaptop $ cms burn raspberry "red,red0[1-3]" --device=/dev/disk2 -f
```
> Note the `-f` flag instructs `cms burn` to build a default cloudmesh inventory for the names provided. Here, we can run `cms inventory list --inventory="inventory-red.yaml"` to see the configurations of each hostname.

After each card is burned, `cms burn raspberry` will prompt you to swap cards to burn the next host.

After all cards have been burned, we can now plug in all our cards into our raspberry pis and boot. Ensure
that your workers and manager are connected into the same network switch via the ethernet cables. Ensure this network
switch does not have internet access in itself. We will use the manager as the sole point of internet access here. This we do deliberately as to be able to disconnect all nodes from the network via the Master in case this is needed.

## 6. Burn Verification and Post-Process Steps

After you boot, we recommend waiting 2-3 minutes for boot setup to complete.

### 6.1 Setting up a Proxy Jump with `cms host`

While we are waiting for the Pis to boot, we can setup a Proxy Jump on our ssh config to make accessing our workers from the manager easy (since our laptop does not have direct access to the workers by nature of the network setup in figure TODO)

Use the following command to set this up:

```
(ENV3) you@yourlaptop $ cms host config proxy pi@red.local "red0[1-3]"
```

### 6.2 Verifying Manager and Worker Access

We can use a simple `cms` command to verify connection to our Pis. This command simply reads the temperature of the cpu and gpu of each of the Pis.

```bash
(ENV3) you@yourlaptop $ cms pi temp "red,red0[1-3]"
pi temp red,red0[1-3]
+--------+--------+-------+----------------------------+
| host   |    cpu |   gpu | date                       |
|--------+--------+-------+----------------------------|
| red    | 47.712 |  47.2 | 2021-03-27 19:52:56.674668 |
| red01  | 37.485 |  37.4 | 2021-03-27 19:52:57.333300 |
| red02  | 38.946 |  38.9 | 2021-03-27 19:52:57.303389 |
| red03  | 38.946 |  39.4 | 2021-03-27 19:52:57.440690 |
+--------+--------+-------+----------------------------+
```

By receiving this information from our devices we have confirmed our access.

### 6.3 Gather and Scatter Authorized Keys

Each of the nodes only has our laptop's ssh-key in its respective `authorized_keys`. We can use `cms` to gather all keys in our cluster and then distribute them so that each node can ssh into eachother.

We first create ssh-keys for all the nodes in our cluster. Notice how we are given the public key as a return value.

```bash
(ENV3) you@yourlaptop $ cms host key create "red,red0[1-3]"
host key create red,red0[1-3]
+-------+---------+--------------------------------------------------+
| host  | success | stdout                                           |
+-------+---------+--------------------------------------------------+
| red   | True    | ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC99RR79UTQ |
|       |         | JznOPRN/FI6MqNsZ5Eirqs7JXA4UYfnMx8LVaD/ZcI6Sajr0 |
|       |         | 2nw2ucec8OMxtdzPrpWX5B+Hxz3GZWNKCbh2yHhMDIrf/Ohn |
|       |         | QGJrBx1mtAbqy4gd7qljEsL0FummdYmPdtHFBy7t2zkVp0J1 |
|       |         | V5YiLEbbrmX9RXQF1bJvHb4VNOOcwq47qX9h561q8qBxgQLz |
|       |         | F3iHmrMxmL8oma1RFVgZmjhnKMoXF+t13uZrf2R5/hVO4K6T |
|       |         | +PENSnjW7OX6aiIT8Ty1ga74FhXr9F5t14cofpN6QwuF2SqM |
|       |         | CgpVGfRSGMrLI/2pefszU2b5eeICWYePdopkslML+f+n     |
|       |         | pi@red                                           |
| red01 | True    | ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRN/rGGF+e |
|       |         | dZ9S2IWX4P26F7T2H+nsbw7CfeJ6df9oX/npYuM9BPDzcEP7 |
|       |         | +2jNIZtZVehJj5zHiodjAspCxjg+mByQZye1jioa3MBmgO3j |
|       |         | VwxCOPA7x0Wc2Dm9/QOg1kMMMlnNT2NHs+SeQMDXoUkpaLCQ |
|       |         | 108VQxaTclJ67USC1e/9B7OtjhsVm5kGA7Eamyd5PgtANT7G |
|       |         | jHERXSnGzFnbqqsZEBvCLWLSbaSq3adWR1bVvDblu11nyitE |
|       |         | x7YKZA9RK0A7rTBzrZa70SfG65dSbpqQFxmQYSrgiwVSBokk |
|       |         | 0vvk5l7NhBDrrrxWYWd9dm/SrDrInjcuDsCsjOVuccx7     |
|       |         | pi@red01                                         |
... # Ommitted some output for previty
+-------+---------+--------------------------------------------------+
```

We can subsequently gather these keys into a file.

```bash
(ENV3) you@yourlaptop $ cms host key gather "red,red0[1-3]" ~/.ssh/cluster_red_keys
```

And then Scatter them to the `authorized_keys` of our nodes.

```bash
(ENV3) you@yourlaptop $ cms host key scatter "red,red0[1-3]" ~/.sssh/cluster_red_keys
host key scatter red,red0[1-3] /Users/richie/.ssh/cluster_red_keys
+-------+---------+--------+
| host  | success | stdout |
+-------+---------+--------+
| red   | True    |        |
| red01 | True    |        |
| red02 | True    |        |
| red03 | True    |        |
+-------+---------+--------+
```

All nodes should now have `ssh` access to eachother.

## Installing `cms` on the Manger Pi

Some cloudmesh commands offered can be very useful on the Pi. You can install `cms` on all Pis in this fashion, but
we will only demonstrate this for the manager pi.

```bash
(ENV3) you@yourlaptop $ ssh red
pi@red $ curl -Ls https://raw.githubusercontent.com/cloudmesh/get/main/pi/index.html | sh -
```

This will not only install `cms`, but will also upgrade your system, install the dependencies for `cms`, and create a 
virtual environment. Because a system upgrade takes place, this command may take several minutes to run.

After a reboot, we can verify the success of the script with the following:

```bash
(ENV3) pi@red $ cms help
```

## Appendix

TODO: Below needs to be updated/implemented in code
## 5. Writing our cluster configuration

Cloudmesh has a simple system for managing cluster configurations as an inventory. 
We do this management for you, but you can controll it also from the commandline. 
We can first add a manager with cluster subnet IP `10.1.1.1`. We also add the `bridge` service which is
recognized by `cms` as the Wifi bridge service connecting devices on eth0 to the internet.
We also set the timezone and locale here. You may want to change them as you wish.

### 5.1 Default Cluster Creation

As we want to make the cluster very easy to create we are providing a deafult creation with the following command

```bash
you@yourlaptop $ cms inventory add cluster red,red[01-02]
```

THis command will find your current WiFi SSID, your current locale and set up a simple network as depicted in Figure 1 on your cluster. In case you have more or less nodes, the command will make appropriate updates.


### 4.2 Custom Cluster Creation

For a custom cluster you can inspect the parameters to the inventory command.  Here are the commands to use for the previous setup while writing them out. YOu can modify the parameters to your liking:

TODO: see if this is correct

```bash
you@yourlaptop $ cms inventory add red --service=manager --ip=10.1.1.1 --tag=latest-lite --timezone="America/Indiana/Indianapolis" --locale="us"
you@yourlaptop $ cms inventory set red services to "bridge" --listvalue
```

We can then add the workers

```bash
you@yourlaptop $ cms inventory add "red0[1-3]" --service=worker --ip="10.1.1.[2-4]" --router=10.1.1.1 --tag=latest-lite  --timezone="America/Indiana/Indianapolis" --locale="us"
you@yourlaptop $ cms inventory set "red0[1-3]" dns to "8.8.8.8,8.8.4.4" --listvalue
```
> Note we are using Google's DNS here [8.8.8.8, 8.8.4.4]


## 4.3 Inspect the Cluster Configuration

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
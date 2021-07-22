---
date: 2021-07-31
title: "NOT WORKING DRAFT: Burning a pre-configured Raspberry Pi Cluster on Windows 10"
linkTitle: "Pi Cluster from WIndows"
description: "A comprehensive tutorial of burning a Raspberry OS cluster with internet access"
author: Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: False
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" />}}

{{% pageinfo %}}

In this tutorial, we explain how to easily set up a preconfigured cluster of Pis using RaspberryOS while only burning 
SD Cards from Windows 10. The cluster is ready to boot after all cards have been burned. No other configuration is needed.

**Learning Objectives**

* Learn how to use cloudmesh-burn to create a RaspberryOS cluster
* Test the cluster after burning
* Use Windows 10 to conduct the burning

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

## 1. Introduction

With the release of [Pi Imager 1.6](https://www.raspberrypi.org/blog/raspberry-pi-imager-update-to-v1-6/), it is possible to configure a Raspberry Pi from any operating system while using RaspberryOS. While pi-imager only uses a limited number of parameters, our system adds network configurations to create a cluster including a simple network configuration. The system works while executing configurations automatically after the first boot. We will focus here on using Windows 10 for the burning. On piplanet.org we are providing additional tutorials that work also for Ubuntu and macOS.

Our tutorials are useful as typically many steps are involved to set up a cluster. This requires either the replication of time-consuming tasks that can be automated or the knowledge of DevOps frameworks.

We avoid this by simply burning a card for each of the PIs. No more hours wasted on setting up your initial cluster.

To facilitate this we developed a special command called  `cms burn`, which allows us to create preconfigured cards with the necessary information. The features this command supports include:

* Setting the hostname,
* Enabling SSH,
* Configuring WiFi,
* Setting the locale,
* Changing the password,
* Adding authorized keys,
* Configuring static IPs for wired ethernet along with routing preferences,
* Configuring a WiFi *bridge* for a manager Pi to act as a router between the worker PIs and the internet, and
* Automating the configuration on first boot.

We demonstrate the usage of the `cms burn` command by creating a cluster of 
5 pis (1 manager, 4 workers) where we connect the manager to the internet 
via Wifi and configure the workers to access the internet through the manager via
ethernet connection. This is useful for those with restricted internet access where devices must be registered
by MAC Address or through browser login.

## 2. Pre-requisites

* Computer/Laptop with macOS or Linux. (Windows is not supported, but could be easily added with your help. Please contact us if you like to help)
* `python3 --version` > 3.8
* WiFi SSID and password
* 5 Raspberry Pis and 5 SD Cards with power cables.  (However, you only need 
  a minimum of 2 is needed, one manager and 1 worker if you do not have 4 Pis)
* 5 Ethernet Cables 
* An unmanaged ethernet switch

For parts for different pi cluster configurations, please see  lists please see our links on [piplanet.org](https://cloudmesh.github.io/pi/docs/hardware/parts/)

## 3. Notation

In our tutorial we define the manager hostname to be `red`, while each 
worker has a number in it `red01`, `red02`, `red03`, `red04`

The following image shows our cluster configuration:

{{< imgproc network Fill "600x300" />}}

## 4. Installing cloudmesh and Setup

It is best practice to create virtual environments when you do not envision needing a python package consistently. 
We also want to place all source code in a common directory called `cm`. 
Let us set up this create one for this tutorial.

In a browser, go to python.org and install python from the download button you see on the front page. At the time of writing this installs the version 3.9.6. Also make sure you have gitbash installed which you can download from <https://git-scm.com/downloads>
Start a gitbash and create a virtual environment with


```bash
you@yourlaptop $ py -m venv ~/ENV3
```

This will create a new python virtual environment. Activate it with the following command.

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

### 4.1 Install from Pip for Regular Users

**The pip install for Windows is not yet suported!!**

```bash
(ENV3) you@yourlaptop $ pip install cloudmesh-pi-cluster
```

### 4.2 Install from Source (for Developers)

If you are a developer that likes to add new features we recommend our source set up. We start after you have created the virtual env with the install of our convenient `cloudmesh-installer` and creating a directory called `cm` in which we download the sources

```bash
(ENV3) you@yourlaptop $ pip install cloudmesh-installer
(ENV3) you@yourlaptop $ mkdir ~/cm
(ENV3) you@yourlaptop $ cd ~/cm
(ENV3) you@yourlaptop $ cloudmesh-installer get pi
```

This directory will now contain all source code. It will also have the needed installed `cms` command.

As we are still developping tthe windows verison, we need to switch to a specific branch

```
(ENV3) you@yourlaptop $ cloudmesh-installer get pi
(ENV3) you@yourlaptop $ cd cloudmesh-pi-burn
(ENV3) you@yourlaptop $ git checkout windows
(ENV3) you@yourlaptop $ pip install -e .
```

### 4.3 Initializing the cms Command

It is very important to initialize the cms command and test if it is properly installed. You do this simply with the command 

```bash
(ENV3) you@yourlaptop $ cms help
```

You will see a list of subcommands that are part of the cms if your installation succeeded.


### 4.3 Create an SSH key

It is important that we can easily access the manager and worker nodes from the laptop/desktop. Hence we create a keypair in `~/.ssh`. You can create one as follows by accepting the default location in `~/.ssh/id_rsa`

```bash
(ENV3) you@yourlaptop $ ssh-keygen
```

Please use a unique and strong passphrase. We will use this default key to access our cluster after burning.

## 5. Burning the Cluster

We are now ready to burn our cluster. Start by making sure you have the latest desired images to burn:  
```bash
(ENV3) you@yourlaptop $ cms burn image versions --refresh
(ENV3) you@yourlaptop $ cms burn image get latest-lite
(ENV3) you@yourlaptop $ cms burn image get latest-full
```

Next, plug in your first SD Card into your card writer. Check your writer's path with the following:

```bash
(ENV3) you@yourlaptop $ cms burn info

# ----------------------------------------------------------------------
# This is a Windows Computer
# ----------------------------------------------------------------------

+----------+-------+-------+---------+-------+-----------+--------+----------+--------+----------+
| Volume   |   ### | Ltr   | Label   | Fs    | Type      | Size   | Status   | Info   | dev      |
|----------+-------+-------+---------+-------+-----------+--------+----------+--------+----------|
| Volume   |     7 | F     | boot    | FAT32 | Removable | 256 MB | Healthy  |        | /dev/sde |
+----------+-------+-------+---------+-------+-----------+--------+----------+--------+----------+
+--------+-----------------+-----------------+-----------------------------------+--------------+--------+----------+
|   Disk | InterfaceType   | MediaType       | Model                             |   Partitions | Size   | Status   |
|--------+-----------------+-----------------+-----------------------------------+--------------+--------+----------|
|      4 | USB             | Removable Media | Generic STORAGE DEVICE USB Device |            2 | 59 GB  | Online   |
+--------+-----------------+-----------------+-----------------------------------+--------------+--------+----------+
WARNING: We could not find your USB reader in the list of known readers
```

THis command will take a minute to complete.

Record the disk for the SDCard. In this case, it is `4`.

> Note we omit some output of `cms burn info` for clarity.

On windows it will not autodetect the SSID, wifi password,  locale, and country of your laptop. Hence you have to specify it as a parameter. The timezone parameter should include hyphens in place of forward slashes (Ex. use "America-Indiana-Indianapolis" for "America/Indiana/Indianapolis")

```bash
(ENV3) you@yourlaptop $ cms burn raspberry "red,red0[1-4]" --disk=4 --new --locale=en_US.UTF-8 --timezone="America-Indiana-Indianapolis" --ssid=NETWORK --wifipassword=mypassword
```

```
# ----------------------------------------------------------------------
#  _____                 _                           ____   _____
# |  __ \               | |                         / __ \ / ____|
# | |__) |__ _ ___ _ __ | |__   ___ _ __ _ __ _   _| |  | | (___
# |  _  // _` / __| '_ \| '_ \ / _ \ '__| '__| | | | |  | |\___ \
# | | \ \ (_| \__ \ |_) | |_) |  __/ |  | |  | |_| | |__| |____) |
# |_|  \_\__,_|___/ .__/|_.__/ \___|_|  |_|   \__, |\____/|_____/
#                 | |                          __/ |
#                 |_|                         |___/
#  ____
# |  _ \
# | |_) |_   _ _ __ _ __
# |  _ <| | | | '__| '_ \
# | |_) | |_| | |  | | | |
# |____/ \__,_|_|  |_| |_|
#
#
# ----------------------------------------------------------------------

INFO: No inventory found or forced rebuild. Buidling inventory with defaults.
+-------+-------------+---------+---------+--------------------+----------+------------------------+----------+-------------+----------------------------+--------+---------+-------------+-------------------+
| host  | tag         | cluster | service | services           | ip       | dns                    | router   | locale      | timezone                   | owners | comment | description | keyfile           |
+-------+-------------+---------+---------+--------------------+----------+------------------------+----------+-------------+----------------------------+--------+---------+-------------+-------------------+
| red   | latest-lite |         | manager | ['bridge', 'wifi'] | 10.1.1.1 |                        |          | en_US.UTF-8 | AmericaIndianaIndianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| red01 | latest-lite |         | worker  |                    | 10.1.1.2 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | en_US.UTF-8 | AmericaIndianaIndianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| red02 | latest-lite |         | worker  |                    | 10.1.1.3 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | en_US.UTF-8 | AmericaIndianaIndianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| red03 | latest-lite |         | worker  |                    | 10.1.1.4 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | en_US.UTF-8 | AmericaIndianaIndianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| red04 | latest-lite |         | worker  |                    | 10.1.1.5 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | en_US.UTF-8 | AmericaIndianaIndianapolis |        |         |             | ~/.ssh/id_rsa.pub |
+-------+-------------+---------+---------+--------------------+----------+------------------------+----------+-------------+----------------------------+--------+---------+-------------+-------------------+
```

> Note the `--new` flag instructs `cms burn` to build a new 
> inventory and overwrites it if it already exists. To see the contents of this file you
> can use the command
>
> ```bash
 > cms inventory list --inventory=inventory-red.yaml
> ```

NOT TESTED FROM HERE ON. IMPROVEMENTS WILL BE LIKELY

After each card is burned, `cms burn raspberry` will prompt you to swap the SD card to burn the next host.

After all the cards have been burned, we can now plug them in our raspberry pis and boot. Ensure
that your workers and manager are connected to the same network switch via the ethernet cables. Ensure this network
switch does not have internet access in itself, e.g. do not connect the switch to the internet router. We will use the manager as the sole point of internet access here. This we do deliberately to be able to disconnect all nodes from the network via the Master in case this is needed.

## 6. Burn Verification and Post-Process Steps

After you boot, we recommend waiting 2-3 minutes for the boot process to complete.

### 6.1 Setting up a Proxy Jump with `cms host`

While we are waiting for the Pis to boot, we can set up proxy jump on our laptop/desktop while adding it to the ssh config file. This will make it easier to access our workers.  Use the following command to set this up:

```
(ENV3) you@yourlaptop $ cms host config proxy pi@red.local "red0[1-4]"
```

It will do the appropriate modifications.

### 6.2 Verifying Manager and Worker Access

First verify that you can reach the manager (red). 

```
(ENV3) you@yourlaptop $ ssh red
...
pi@red:~ $ exit
```

>Note: If this does not work, it  is likely that the wifi configuration was 
> incorrect, or there is an RF block on the Pi that could not be removed due 
> to an unknown locale of the burning machine. 2.4GHz wifi is more likely to 
> work without explicit country configuration than 5 GHz bands.

We can use a simple `cms` command to verify connection to our Pis. For this purpose, we use our  build in temperature command that reads the temperature values from each of the Pis.

```bash
(ENV3) you@yourlaptop $ cms pi temp "red,red0[1-4]"
pi temp red,red0[1-4]
+--------+--------+-------+----------------------------+
| host   |    cpu |   gpu | date                       |
|--------+--------+-------+----------------------------|
| red    | 47.712 |  47.2 | 2021-03-27 19:52:56.674668 |
| red01  | 37.485 |  37.4 | 2021-03-27 19:52:57.333300 |
| red02  | 38.946 |  38.9 | 2021-03-27 19:52:57.303389 |
| red03  | 38.946 |  39.4 | 2021-03-27 19:52:57.440690 |
| red04  | 38.936 |  39.4 | 2021-03-27 19:52:57.550690 |
+--------+--------+-------+----------------------------+
```

By receiving this information from our devices we have confirmed our access.

### 6.3 Gather and Scatter Authorized Keys

Each of the nodes only has our laptop's ssh-key in its respective `authorized_keys` file. We can use the `cms` command to gather all keys in our cluster and then distribute them so that each node can ssh into each other.

We first create ssh-keys for all the nodes in our cluster. 

```bash
(ENV3) you@yourlaptop $ cms host key create "red,red0[1-4]"
host key create red,red0[1-4]
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
... # Ommitted some output for brevity
+-------+---------+--------------------------------------------------+
```

We can subsequently gather these keys into a file.

```bash
(ENV3) you@yourlaptop $ cms host key gather "red,red0[1-4]" ~/.ssh/cluster_red_keys
```

And then Scatter them to the `authorized_keys` of our nodes.

```bash
(ENV3) you@yourlaptop $ cms host key scatter "red,red0[1-4]" ~/.ssh/cluster_red_keys
host key scatter red,red0[1-4] /Users/richie/.ssh/cluster_red_keys
+-------+---------+--------+
| host  | success | stdout |
+-------+---------+--------+
| red   | True    |        |
| red01 | True    |        |
| red02 | True    |        |
| red03 | True    |        |
| red04 | True    |        |
+-------+---------+--------+
```

All nodes should now have `ssh` access to each other.

### 6.4 Installing `cms` on a Pi

Some cloudmesh commands offered can be very useful on the Pis. You can install `cms` on all Pis in this fashion, but
we will only demonstrate this for the manager pi.

For the production version pleas use 

```bash
(ENV3) you@yourlaptop $ ssh red
pi@red $ curl -Ls http://cloudmesh.github.io/get/pi | sh -
```

However, to get the newest development version please use

```bash
(ENV3) you@yourlaptop $ ssh red
pi@red $ curl -Ls https://raw.githubusercontent.com/cloudmesh/get/main/pi/index.html | sh -
```

This will not only install `cms`, but will also upgrade your system, install the dependencies for `cms`, and create a 
virtual environment. Because a system upgrade takes place, this command may take several minutes to run.

After a reboot, we can verify the success of the script with the following:

```bash
(ENV3) pi@red $ cms help
help

Documented commands (type help <topic>):
========================================
EOF     check     default  help       pause     quit   start      test
admin   clear     diagram  host       pi        set    stop       var
banner  commands  dryrun   info       provider  shell  stopwatch  version
bridge  config    echo     inventory  py        sleep  sys
burn    debug     gui      man        q         ssh    term
```

## 7. Appendix

## 7.1 Writing our cluster configuration

Cloudmesh has a simple system for managing cluster configurations as an inventory. 
We do this management for you, but you can control it also from the command line. 
We can first add a manager with cluster subnet IP `10.1.1.1`. We also add the `bridge` service which is
recognized by `cms` as the Wifi bridge service connecting devices on eth0 to the internet.
We also set the timezone and locale here. You may want to change them as you wish.

### 7.2 Default Cluster Creation

As we want to make the cluster very easy to create we demonstrated in 
Section 5 how to create a default cluster directly from the burn command. 
As a future feature, this behavior will also be implemented into the inventory 
command. To make a default inventory named inventory-red.yaml:

```bash
you@yourlaptop $ cms inventory add cluster "red,red[01-04]"
```

This command will find your current WiFi SSID, your current locale and set up a simple network as depicted in Figure 1 on your cluster. In case you have more or fewer nodes, the command will make appropriate updates.


### 7.3 Custom Cluster Creation

For a custom cluster, you can inspect the parameters of the inventory command.  Here are the commands to use for the previous setup while writing them out. You can modify the parameters to your liking:

```bash
you@yourlaptop $ cms inventory add red --service=manager --ip=10.1.1.1 --tag="latest-lite" --timezone="America/Indiana/Indianapolis" --locale="us" --inventory="inventory-red.yaml"
you@yourlaptop $ cms inventory set red services to "bridge,wifi" --listvalue --inventory="inventory-red.yaml"
```

We can then add the workers

```bash
you@yourlaptop $ cms inventory add "red0[1-4]" --service=worker --ip="10.1.1.[2-5]" --router=10.1.1.1 --tag="latest-lite"  --timezone="America/Indiana/Indianapolis" --locale="us" --inventory="inventory-red.yaml"
you@yourlaptop $ cms inventory set "red0[1-4]" dns to "8.8.8.8,8.8.4.4" --listvalue --inventory="inventory-red.yaml"
```
> Note we are using Google's DNS here [8.8.8.8, 8.8.4.4]


### 7.4 Inspect the Cluster Configuration

Our cluster configuration is now complete. You may run the following to list your configuration. We include ours for a sanity check:

```bash
you@yourlaptop $ cms inventory list --inventory="inventory-red.yaml"
+-------+-------------+---------+---------+--------------------+----------+------------------------+----------+--------+------------------------------+--------+---------+-------------+-------------------+
| host  | tag         | cluster | service | services           | ip       | dns                    | router   | locale | timezone                     | owners | comment | description | keyfile           |
+-------+-------------+---------+---------+--------------------+----------+------------------------+----------+--------+------------------------------+--------+---------+-------------+-------------------+
| red   | latest-lite |         | manager | ['bridge', 'wifi'] | 10.1.1.1 |                        |          | us     | America/Indiana/Indianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| red01 | latest-lite |         | worker  |                    | 10.1.1.2 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | us     | America/Indiana/Indianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| red02 | latest-lite |         | worker  |                    | 10.1.1.3 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | us     | America/Indiana/Indianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| red03 | latest-lite |         | worker  |                    | 10.1.1.4 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | us     | America/Indiana/Indianapolis |        |         |             | ~/.ssh/id_rsa.pub |
| red04 | latest-lite |         | worker  |                    | 10.1.1.5 | ['8.8.8.8', '8.8.4.4'] | 10.1.1.1 | us     | America/Indiana/Indianapolis |        |         |             | ~/.ssh/id_rsa.pub |
+-------+-------------+---------+---------+--------------------+----------+------------------------+----------+--------+------------------------------+--------+---------+-------------+-------------------+
```

### 7.5 Burning a Custom Cluster

You can now specify your inventory as you burn your cluster or specific 
machines from the cluster with the burn command. All hosts data found in the 
inventory will be written to the machines, regardless if they are in the 
burn command or not.

Burn the whole cluster.

```bash
(ENV3) you@yourlaptop $ cms burn raspberry "red,red0[1-4]" --device=/dev/sdb 
--inventory="inventory-red.yaml"
```

Burn a specific machine.

```bash
(ENV3) you@yourlaptop $ cms burn raspberry "red03" --device=/dev/sdb --inventory="inventory-red.yaml"
```

## Appendix

### Managing known_hosts

In case you reburn a SDCard and use it in your cluster you will get a warning once you try to ssh into the machine. To remove the error simply execute the command

```bash
$ ssh-keygen -R HOSTNAME
```

where hostname is either the hostname or the ip address of your machine. that is registered in known hosts.
To see the list, please use 

```bash
$cat ~/.ssh/known_hosts
```


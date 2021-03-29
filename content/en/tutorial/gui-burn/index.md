---
date: 2021-03-29
title: "GUI Burning a set of pre-configured SD cards for Raspberry Pis with 
Wifi 
Access"
linkTitle: "Burning a Cluster using Cloudmesh Burn GUI"
description: "A GUI tutorial of burning a cluster with internet access"
author: Rama Asuri, Richard Otten, Anthony Orlowski,  Gregor von Laszewski (
[laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: False
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" />}}

{{% pageinfo %}}

In this tutorial, we explain how to easily set up a preconfigured cluster of 
Pis using RaspberryOS or Ubuntu while only burning SD Cards. The cluster is 
ready to boot after all cards have been burned. No other configuration is needed.

**Learning Objectives**

* Learn how to use cloudmesh-burn to create a cluster using Cloudmesh Burn GUI
* Test the cluster after burning

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

## 1. Introduction

With the release of [Pi Imager 1.6](https://www.raspberrypi.
org/blog/raspberry-pi-imager-update-to-v1-6/), it is possible to configure a 
Raspberry Pi from any operating system while using RaspberryOS. While 
pi-imager only uses a limited number of parameters, our system supports 
both RaspberryOS and Ubunty, and adds network configurations to create a 
cluster with a simple network configuration. The system works while executing 
configurations automatically after the first boot.

> Note: at this time we have not yet ported our system to Windows, but it is fairly easy to do so. If you like to help, please contact laszewski@gmail.com.

In addition to using the GUI, we have additional command line 
tutorials for [RaspberryOS](https://cloudmesh.github.io/pi/tutorial/raspberry-burn/),
and [Ubuntu](https://cloudmesh.github.io/pi/tutorial/ubuntu-burn/) that 
provide additional flexibility. Our tutorials are useful as typically many 
steps are involved to set up a cluster. This requires either the replication of time-consuming tasks that can be automated or the knowledge of DevOps frameworks.

We avoid this by simply burning a card for each of the PIs. No more hours wasted on setting up your initial cluster.

To facilitate this we developed a special command called  `cms burn gui`, which 
allows us to create preconfigured cards with the necessary information. The features this command supports include:

* Setting the hostname,
* Enabling SSH,
* Configuring WiFi,
* Setting the locale,
* Adding authorized keys,
* Configuring static IPs for wired ethernet along with routing preferences,
* Configuring a WiFi *bridge* for a manager Pi to act as a router between the worker PIs and the internet, and
* Automating the configuration on first boot.

We demonstrate the usage of the `cms burn gui` command by creating a cluster of 
4 pis (1 manager, 3 workers) where we
connect the manager to the internet via Wifi and configure the workers to access the internet through the manager via
ethernet connection. This is useful for those with restricted internet access where devices must be registered
by MAC Address or through browser login.

## 2. Pre-requisites

* Computer/Laptop with macOS or Linux. (Windows is not supported, but could be easily added with your help. Please contact us if you like to help)
* `python3 --version` > 3.8
* WiFi SSID and password
* 5 Raspberry Pis and 5 SD Cards with power cables.  (However, you only need 
  a minimum of 2 is needed, one manager and 1 worker if you do not have 5 Pis)
* 5 Ethernet Cables 
* An unmanaged ethernet switch

For parts for different pi cluster configurations, please see  lists please see our links on [piplanet.org](https://cloudmesh.github.io/pi/docs/hardware/parts/)

## 3. Notation

In our tutorial we define the manager hostname to be `red`, while each 
worker has a number in it `red01`, `red02`, `red03`, `red04`

The following image shows our cluster configuration:

{{< imgproc network Fill "600x300" />}}

## 4. Installing cloudmesh and Setup

It is best practice to create virtual environments when you do not envision needing a python package consistently. We also want to 
place all source code in a common directory called `cm`. 
Let us set up this create one for this tutorial.

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

### 4.1 Install from Pip for Regular Users

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
(ENV3) you@yourlaptop $ ls
```

This directory will now contain all source code. It will also have the needed installed `cms` command.

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

We are now ready to burn our cluster. Start by plugging in your first SD 
Card into your card writer. Then run the following command, where the 
--hostname includes the names of the devices to be burned. You will be asked 
to input your `sudo` password which is needed to burn the sd cards. After 
entering the password a simple GUI will appear.

```
(ENV3) you@yourlaptop $ cms burn gui --hostname=red,red0[1-4]
# ----------------------------------------------------------------------
#  _____                               _                
# |  __ \                             | |               
# | |__) |_ _ _ __ __ _ _ __ ___   ___| |_ ___ _ __ ___ 
# |  ___/ _` | '__/ _` | '_ ` _ \ / _ \ __/ _ \ '__/ __|
# | |  | (_| | | | (_| | | | | | |  __/ ||  __/ |  \__ \
# |_|   \__,_|_|  \__,_|_| |_| |_|\___|\__\___|_|  |___/
#                                                       
#                                                       
# ----------------------------------------------------------------------

Manager:       red
Workers:       ['red01', 'red02', 'red03', 'red04']
IPS:           ['10.1.1.1', '10.1.1.2', '10.1.1.3', '10.1.1.4', '10.1.1.5']
Key:           /home/anthony/.ssh/id_rsa.pub
Dryrun:        False
sudo password: 
```

{{< imgproc gui-launch Fill "600x300" />}}

Ensure the appropriate device is selected so you do not accidentally burn to 
the wrong storage device. It is best to only have one attached storage 
device to prevent mistakes.

{{< imgproc gui-device Fill "600x300" />}}

Next, select the OS that you would like to burn to the SD cards. 
Selecting the radio button will automatically update the image field for 
each machine. RaspberryOS supports two tags, latest-full (a desktop environment 
that takes more storage space) and latest-lite (smaller image with no desktop). 
Ubuntu only has one tag per distribution type. 

> If you want to further customize your image selction, you can input any 
> tag from `cms burn image versions --refresh`.

{{< imgproc gui-os Fill "600x300" />}}

Next, verify the path to the SSH key that will be written to all hosts 
authorized_keys file. Verify the SSID (this will be prepopulated with your 
machines current wifi network if one exists), and enter the wifi password.

{{< imgproc gui-security Fill "600x300" />}}

We are now ready to burn.

> Note: you can further customize image tags and IP addresses.

Burn the manager device by pressing the `Burn` button next to the machine `red`.
In the command line prompt you will see the inventory created for the 
cluster, the underlying burn command, OS image download progress, and finally 
you will be asked to verify that the sd card is inserted.

```
# ----------------------------------------------------------------------
#  _____                      _                 _ _             
# |  __ \                    | |               | (_)            
# | |  | | _____      ___ __ | | ___   __ _  __| |_ _ __   __ _ 
# | |  | |/ _ \ \ /\ / / '_ \| |/ _ \ / _` |/ _` | | '_ \ / _` |
# | |__| | (_) \ V  V /| | | | | (_) | (_| | (_| | | | | | (_| |
# |_____/ \___/ \_/\_/ |_| |_|_|\___/ \__,_|\__,_|_|_| |_|\__, |
#                                                          __/ |
#                                                         |___/ 
#  _____                                 
# |_   _|                                
#   | |  _ __ ___   __ _  __ _  ___  ___ 
#   | | | '_ ` _ \ / _` |/ _` |/ _ \/ __|
#  _| |_| | | | | | (_| | (_| |  __/\__ \
# |_____|_| |_| |_|\__,_|\__, |\___||___/
#                         __/ |          
#                        |___/           
# ----------------------------------------------------------------------

INFO: Attempting to download latest-lite
Downloading 2021-03-04-raspios-buster-armhf-lite.zip

...

INFO: Verifying sha1
INFO: Verifying sha256
SHA1 is ok
SHA256 is ok
Extracting 2021-03-04-raspios-buster-armhf-lite.img
INFO: Attempting to download latest-full
Downloading 2021-03-04-raspios-buster-armhf-full.zip

...

INFO: Verifying sha1
INFO: Verifying sha256
SHA1 is ok
SHA256 is ok
Extracting 2021-03-04-raspios-buster-armhf-full.img
Is the card to be burned for red inserted? (Y/n) y
```

The `Burn` button will turn grey while the burn is in progress.

{{< imgproc gui-inprogress Fill "600x300" />}}

And the `Burn` button will turn green once the burn has completed. It is 
best to check the command line output to verify there were no unhandled 
errors. If an error occurred, you can first try to re-burn before further 
troubleshooting. 

{{< imgproc gui-done Fill "600x300" />}}

Continue to burn the workers 1 by 1, remembering to answer the "card 
inserted?" prompt on the commandline,  until you have completed burning all SD 
cards.

{{< imgproc gui-complete Fill "600x300" />}}

> Note: You can view a network diagram and rack diagram on the respective tabs.

{{< imgproc gui-network Fill "600x300" />}}

{{< imgproc gui-rack Fill "600x300" />}}

Now, plug in the SD cards and boot the cluster.

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

Now we can use a simple `cms` command to verify connection to our Pis. For this 
purpose, we use our  build in temperature command that reads the temperature values from each of the Pis.

```bash
(ENV3) you@yourlaptop $ cms pi temp "red,red0[1-4]"
pi temp red,red0[1-4]
+--------+--------+-------+----------------------------+
| host   |    cpu |   gpu | date                       |
|--------+--------+-------+----------------------------|
| red    | 52.095 |  52.5 | 2021-03-29 16:24:29.375779 |
| red01  | 51.608 |  51.6 | 2021-03-29 16:24:29.775136 |
| red02  | 54.53  |  54.5 | 2021-03-29 16:24:29.735953 |
| red03  | 55.504 |  55.5 | 2021-03-29 16:24:30.375218 |
| red04  | 50.147 |  50.6 | 2021-03-29 16:24:30.949371 |
+--------+--------+-------+----------------------------+
```

By receiving this information from our devices we have confirmed our access.

### 6.3 Gather and Scatter Authorized Keys

Each of the nodes only has our laptop's ssh-key in its respective `authorized_keys` file. We can use the `cms` command to gather all keys in our cluster and then distribute them so that each node can ssh into each other.

We first create ssh-keys for all the nodes in our cluster. 

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
... # Ommitted some output for brevity
+-------+---------+--------------------------------------------------+
```

We can subsequently gather these keys into a file.

```bash
(ENV3) you@yourlaptop $ cms host key gather "red,red0[1-4]" ~/.
ssh/cluster_red_keys
```

And then Scatter them to the `authorized_keys` of our nodes.

```bash
(ENV3) you@yourlaptop $ cms host key scatter "red,red0[1-4]" ~/.
sss/cluster_red_keys
host key scatter red,red0[1-3] /Users/richie/.ssh/cluster_red_keys
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

## Installing `cms` on a Pi

Some cloudmesh commands offered can be very useful on the Pis. You can install `cms` on all Pis in this fashion, but
we will only demonstrate this for the manager pi.

For the production version pleas use 

```bash
(ENV3) you@yourlaptop $ ssh red
pi@red $ curl -Ls curl -Ls http://cloudmesh.github.io/get/pi | sh -
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

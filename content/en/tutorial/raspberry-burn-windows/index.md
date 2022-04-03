---
date: 2022-04-03
title: "DRAFT: Burning a pre-configured Raspberry PI OS Cluster"
linkTitle: "DRAFT: Pi Cluster from your OS (not approved yet)"
description: "A comprehensive tutorial of burning a Raspberry OS cluster with internet access"
author: Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io), Venkata (DK) Kolli [github.com/dkkolli](https://github.com/dkkolli)
draft: False
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" />}}

{{% pageinfo %}}

In this tutorial, we explain how to easily set up a preconfigured cluster of Pis 
using Raspberry PI OS while burning SD Cards from either a Windows 10 desktop/Laptop 
or a PI 4 using Raspberry PI OS 64 bit. The cluster is ready to boot after all 
cards have been burned. No other configuration is needed. You can chose to use 
64-bit or 32-bit on the nodes for the cluster.

**Learning Objectives**

* Learn how to use cloudmesh-burn to create a RaspberryOS cluster
* Test the cluster after burning
* Use either Windows 10 or use a PI4 to conduct the burning

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

## 1. Introduction

With the release of [Pi Imager
1.6](https://www.raspberrypi.org/blog/raspberry-pi-imager-update-to-v1-6/),
it is possible to configure a Raspberry Pi from any operating system
while using RaspberryOS. While pi-imager only uses a limited number of
parameters, our system adds network configurations to create a cluster
including a simple network configuration. The system works while
executing configurations automatically after the first boot. We will
focus here on using a computer for burning the SD Cards that can uses either Windows 10 
or Rasberry PI OS for the burning. On <http://piplanet.org> we are
providing additional tutorials that work also for Ubuntu and macOS.

Our tutorials are very useful as typically many steps are involved to set
up a cluster. This requires either the replication of time-consuming
tasks that can be automated or the knowledge of DevOps frameworks that you 
may not be familiar with.

We avoid this by simply burning a card for each of the PIs. No more
hours wasted on setting up your initial cluster.

To facilitate this we developed a special command called `cms burn`,
which allows us to create preconfigured cards with the necessary
information. The features this command supports include:

* Setting the hostname,
* Enabling SSH,
* Configuring WiFi,
* Setting the locale,
* Changing the password,
* Adding authorized keys,
* Configuring static IPs for wired ethernet along with routing
  preferences,
* Configuring a WiFi *bridge* for a manager Pi to act as a router
  between the worker PIs and the internet, and
* Automating the configuration on first boot.

We demonstrate the usage of the `cms burn` command by creating a
cluster of 5 pis (1 manager, 4 workers) where we connect the manager
to the internet via Wifi and configure the workers to access the
internet through the manager via ethernet connection. This is useful
for those with restricted internet access where devices must be
registered by MAC Address or through browser login as the internet 
connection is tunneled through the manager PI

## 2. Pre-requisites

* Computer/Laptop with  Windows10 or PI 4 with Raspberry PI OS 64-bit
* `python3 --version` > 3.9.2
* WiFi SSID and password
* 5 Raspberry Pis and 5 SD Cards with power cables.  (However, you only need 
  a minimum of 2 is needed, one manager and 1 worker if you do not have 4 Pis.
  You can adapt our tutorial accordingly)
* 5 Ethernet Cables 
* An unmanaged ethernet switch

For parts for different pi cluster configurations, please see lists
please see our links on
[piplanet.org](https://cloudmesh.github.io/pi/docs/hardware/parts/)

## 3. Notation

In our tutorial we define the manager hostname to be `red`, while each 
worker has a number in it `red01`, `red02`, `red03`, `red04`. Our 
tool specifically identifies the manager node to be the one without the number.
Naturally, you can use a different name then using `red`. This can also be come 
in handy in case you want to create multiple clusters to create a distributed 
cluster environment for use or development purposes.

The following image shows our cluster configuration:

{{< imgproc network Fill "600x300" />}}

## 4. Installing cloudmesh and Setup


{{< tabs tabTotal="3" tabLeftAlign="3">}}
{{< tab tabName="Windows" >}}

At the time of writing this tutorial uses Python 3.10.4. To install, go
to python.org and click the download button you see on the front page
and install this or a newer version. We additionally use gitbash for
our commands so make sure you have gitbash installed. You can download
from <https://git-scm.com/downloads>. Our ```burn``` commands will
require administrator privileges, so launch an administrator gitbash
window by right-clicking on the program.

It is best practice to create virtual environments for python. Hence,  
do not use our programwithout using a virtualenv.
In your gitbash window create a virtual environment with


```bash
you@yourlaptop $ py -m venv ~/ENV3
```

This will create a new python virtual environment. Activate it with
the following command.

```bash
you@yourlaptop $ source ~/ENV3/Scripts/activate
```

{{< /tab >}}
{{< tab tabName="Rasperry_PI_OS_64-bit" >}}

At the time of writing this tutorial uses Python 3.9.2 is the 
default version. It is best practice to create virtual environments 
for python.  Hence, do not use our programwithout using a virtualenv.

```bash
you@yourlaptop $ python -m venv ~/ENV3
```

This will create a new python virtual environment. Activate it with
the following command.

```bash
you@yourlaptop $ source ~/ENV3/bin/activate
```

{{< /tab >}}
{{< /tabs >}}


First, we update pip and verify your `python` and `pip` are correct

```bash
(ENV3) you@yourlaptop $ pip install --upgrade pip
(ENV3) you@yourlaptop $ which python
~/ENV3/Scripts/python

(ENV3) you@yourlaptop $ which pip
~/ENV3/Scripts/pip
```


### ~~4.1 Install from Pip for Regular Users~~

~~**The pip install for Windows is not yet suported!!. So please use
the Install from source installation documentation. Once we officially
release this code the install from pip can be used.**~~

~~```bash~~
~~(ENV3) you@yourlaptop $ pip install cloudmesh-pi-cluster~~
~~```~~

### 4.2 Install from Source (for Developers)

If you are a developer that likes to add new features we recommend our
source set up. We start after you have created the virtualenv with the
install of our convenient `cloudmesh-installer` and creation of the
`cm` directory in which we download the sources

```bash
(ENV3) you@yourlaptop $ mkdir ~/cm
(ENV3) you@yourlaptop $ cd ~/cm
(ENV3) you@yourlaptop $ pip install cloudmesh-installer
(ENV3) you@yourlaptop $ cloudmesh-installer get pi
```

This directory will now contain all source code. It will also have
installed the needed `cms` command.

As we are still developing the windows verison, we need to switch to a
specific branch. In both of the blocks below, a ```git fetch```
immediately before the ```git checkout windows``` command may be
necessary if the windows branch can't be found.

```
(ENV3) you@yourlaptop $ cd cloudmesh-pi-burn
(ENV3) you@yourlaptop $ git checkout windows
(ENV3) you@yourlaptop $ pip install -e .
(ENV3) you@yourlaptop $ cd ..
(ENV3) you@yourlaptop $ cd cloudmesh-inventory
(ENV3) you@yourlaptop $ git checkout windows
(ENV3) you@yourlaptop $ pip install -e .
```

### 4.3 Initializing the cms Command

It is very important to initialize the cms command and test if it is
properly installed. You do this simply with the command

```bash
(ENV3) you@yourlaptop $ cms help
```

You will see a list of subcommands that are part of the cms if your
installation succeeded. Check if you can see the command

```
burn
```
in the list.

### 4.3 Create an SSH key

We use ssh to easily login to the manager and worker nodes from the
laptop/desktop. Hence we create a keypair in `~/.ssh`. You can create
one as follows by accepting the default location in `~/.ssh/id_rsa`

```bash
(ENV3) you@yourlaptop $ ssh-keygen
```

Please use a unique and strong passphrase. We will use this default
key to access our cluster after burning.

In case you do not always want to type in your passphrase, you can use
ssh-agent in your gitbash window as follows:

```bash
(ENV3) you@yourlaptop $ eval `ssh-agent`
(ENV3) you@yourlaptop $ ssh-add

```

These two commands will start the ssh-agent and add your key to it so
it is cached for future use within the same gitbash terminal

## 5. Burning the Cluster

We are now ready to burn our cluster. Start by making sure you have
the latest images to burn. Please chose the 64-bit or the 32-bit image
tab to see details:


{{< tabs tabTotal="3" tabLeftAlign="2">}}
{{< tab tabName="Rasperry_PI_OS_64-bit_image" >}}


```bash
(ENV3) you@yourlaptop $ cms burn image versions --refresh
(ENV3) you@yourlaptop $ cms burn image get latest-lite
(ENV3) you@yourlaptop $ cms burn image get latest-full
```

{{< /tab >}}
{{< tab tabName="Rasperry_PI_OS_32-bit_image" >}}

```bash
(ENV3) you@yourlaptop $ cms burn image versions --refresh
(ENV3) you@yourlaptop $ cms burn image get latest-lite
(ENV3) you@yourlaptop $ cms burn image get latest-full
```

{{< /tab >}}
{{< /tabs >}}

Next, plug in your first SD Card into your card writer.  Check your
writer's path with the following while using gitbash as administrative
user.


> *Note: To run gitbash as administrative user, type in the Windows search form and click on Run as administrator). Qw will ougment all commands with the keyword (admin) that need to be run in administrative mode*

### 5.1 Get Burn Info

```bash
(ENV3) (admin) you@yourlaptop $ cms burn info
```

{{< tabs tabTotal="2" tabLeftAlign="2">}}
{{< tab tabName="Sample_output_Windows" >}}

```
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

IMPORTANT: Record the disk for the SDCard. In this case, it is `4`.


{{< /tab >}}
{{< tab tabName="Sample_output_PI4" >}}

In case of a Raspbery PI you will see a column device in the table output. When 
specifying the burn command you will be using the `--device` flag. Let us assume 
you get the device `/dev/sda`. Then the flag in the burn command is `--device/dev/sda`

```
TBD

```

{{< /tab >}}
{{< /tabs >}}`



This command will take a minute to complete. The warning occurs as
your reader may be too new and we do not have it in our database of
recognized readers. As long as you see `Removable Media` and `GENERIC
STORAGE DEVICE` it will be fine.

> Note we omit some output of `cms burn info` for clarity.

### 5.2 Executing Burn Command

To burn the latest 32 bit OS use the following command. Otherwise, look at our subsequent note
for instructions to burn the latest 64 bit OS.

{{< tabs tabTotal="2" tabLeftAlign="2">}}
{{< tab tabName="Burn_On_Windows" >}}

> **IMPORTANT: verify the disk number with `cms burn info`**

```bash
(ENV3) (admin) you@yourlaptop $ cms burn raspberry "red,red0[1-4]" \
                                         --password=myloginpassword \
                                         --disk=4 \ 
                                         --new \
                                         --locale=en_US.UTF-8 \
                                         --timezone="America-Indiana-Indianapolis" \
                                         --ssid=NETWORK \
                                         --wifipassword=mywifipassword
```


On windows it will not autodetect the SSID, wifi password, locale, or
country of your laptop. Hence you have to specify these as
parameters. 

{{< /tab >}}
{{< tab tabName="Burn_On_Raspbian_OS 64-bit" >}}

> **IMPORTANT: verify the device name  with `cms burn info`**

```bash
(ENV3) (admin) you@yourlaptop $ cms burn raspberry "red,red0[1-4]" \
                                         --password=myloginpassword \
                                         --device=/dev/sda \ 
                                         --new \
                                         --locale=en_US.UTF-8 \
                                         --timezone="America-Indiana-Indianapolis" \
                                         --ssid=NETWORK \
                                         --wifipassword=mywifipassword
```

On Raspberry PI OS, Linux, and macOS the timezone and locale will be 
automatically detected. Thus you do not have to specify 
them. However if you detect issues, please add them. 

{{< /tab >}}
{{< /tabs >}}`

Timezones can be found at
(<https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>).

Timezones are typically defined with forward slashes in the string 
identifying them. However, as we use python forward 
slashes have a specific meaning in python and would interfere with 
our implementation. Therefor we use `-` instead of '/'.

Hence, when entering timezones for the ```--timezone``` parameter, please
replace forward slashes with hyphens, as shown in the example shown next:

> ```--timezone="America/Indiana/Indianapolis"```  

must be replaced with:  

> ```--timezone="America-Indiana-Indianapolis```  

If the network name has a space in it, please use two sets of quotes:
```"--ssid='Net Work'"```. In general, we recommend not to use any spaces in
network names.

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

> Note the `--new` flag instructs `cms burn` to build a new (the -f flag does the same but we have not yet tested it).
> inventory and overwrites it if it already exists. To see the contents of this file you
> can use the command
>
> ```bash
 > cms inventory list --inventory=inventory-red.yaml
> ```

> Note: if you want to burn the **64 bit OS** use the following series of commands
> instead.This creates a default cluster configuration, and then changes the OS tag
> latest-lite-64.
>
> ```bash
 > (ENV3) (admin) you@yourlaptop $ cms burn image versions --refresh
 > (ENV3) (admin) you@yourlaptop $ cms burn image get latest-lite-64 
 > (ENV3) (admin) you@yourlaptop $ cms inventory add cluster "red,red0[1-4]"
 > (ENV3) (admin) you@yourlaptop $ cms inventory set "red,red0[1-4]" tag to latest-lite-64 --inventory="inventory-red.yaml"
 > (ENV3) (admin) you@yourlaptop $ cms burn raspberry "red,red0[1-4]" --password=myloginpassword --disk=4 --locale=en_US.UTF-8 --timezone="America-Indiana-Indianapolis" --ssid=NETWORK --wifipassword=mywifipassword
> ```


After each card is burned, `cms burn raspberry` will prompt you to
swap the SD card to burn the next host.

After all the cards have been burned, we can now plug them in our
raspberry pis and boot. Ensure that your workers and manager are
connected to the same network switch via the ethernet cables. Ensure
this network switch does not have internet access in itself, e.g. do
not connect the switch to the internet router. We will use the manager
as the sole point of internet access here. This we do deliberately to
be able to disconnect all nodes from the network via the Master in
case this is needed.


## 6. Burn Verification and Post-Process Steps

After you boot, we recommend waiting 2-3 minutes for the boot process to complete.
You will notice that the read LED will be on and that the green LED is off.
If this is not the case, please wait. If it does not work after a long while, 
please reboot the PI that has issues and see if it works after the reboot.
Also make sure you check your hardware and network.



### 6.1 Setting up a Proxy Jump with `cms host`

While we are waiting for the Pis to boot, we can set up proxy jump on
our laptop/desktop while adding it to the ssh config file. This will
make it easier to access our workers.  Use the following command to
set this up:

NOT TESTED FROM HERE ON. IMPROVEMENTS WILL BE LIKELY


```
(ENV3) you@yourlaptop $ cms host config proxy pi@red.local "red0[1-4]"
```

TO: Gregor believes the previous line is a documentation error 
and the following line may work:

```
(ENV3) you@yourlaptop $ cms host config pi@red.local "red0[1-4]"
```

The previous line is actually better, but ther is an implementation
bug that does not copy the host key from the maseter on the worker
nodes. I think that was once upon a time implemented, and may have ben
removed and is now a bug. The workaround is


```
(ENV3) you@yourlaptop $ cms host pi@red.local "red0[1-4]"
(ENV3) you@yourlaptop $ cms pi temp "red,red0[1-4]"

# VERIFY AND USE YN CHOOISE IF THINGS ARE OK, IF SO EXECUTE THE NEXT LINES

(ENV3) you@yourlaptop $ cms host key gather "red,red0[1-4]" \"~/.ssh/cluster_red_keys\"
(ENV3) you@yourlaptop $ cms host key scatter "red,red0[1-4]" \"~/.ssh/cluster_red_keys\"
(ENV3) you@yourlaptop $ cms host config pi@red.local "red0[1-4]"
```

We could wrap this into an option in some form. However the temp test
should be performed first. We could document the two cases There are
advantages and disadvantages about the two cases. a) proxy: you make
it look like a cluster where each node is behind the proxy host b)
with no proxy you can directly loginto the nodes from the laptop
making ssh a bit faster and when many many nodes are involved possibly
better. However this does probably not realy matter. I suggest we
support both cases


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

We can use a simple `cms` command to verify connection to our Pis. For
this purpose, we use our build in temperature command that reads the
temperature values from each of the Pis.

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

Each of the nodes only has our laptop's ssh-key in its respective
`authorized_keys` file. We can use the `cms` command to gather all
keys in our cluster and then distribute them so that each node can ssh
into each other.

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
(ENV3) you@yourlaptop $ cms host key gather "red,red0[1-4]" \"~/.ssh/cluster_red_keys\"
```

And then Scatter them to the `authorized_keys` of our nodes.

```bash
(ENV3) you@yourlaptop $ cms host key scatter "red,red0[1-4]" \"~/.ssh/cluster_red_keys\"
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

Some cloudmesh commands offered can be very useful on the Pis. You can
install `cms` on all Pis in this fashion, but we will only demonstrate
this for the manager pi.

For the production version pleas use 

```bash
(ENV3) you@yourlaptop $ ssh red
pi@red $ curl -Ls http://cloudmesh.github.io/get/pi | sh -
```

~~However, to get the newest development version please use~~

~~(ENV3) you@yourlaptop $ ssh red
pi@red $ curl -Ls https://raw.githubusercontent.com/cloudmesh/get/main/pi/index.html | sh -~~

This will not only install `cms`, but will also upgrade your system,
install the dependencies for `cms`, and create a virtual
environment. Because a system upgrade takes place, this command may
take several minutes to run.

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

This command will find your current WiFi SSID, your current locale and
set up a simple network as depicted in Figure 1 on your cluster. In
case you have more or fewer nodes, the command will make appropriate
updates.


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

You can now specify your inventory as you burn your cluster or
specific machines from the cluster with the burn command. All hosts
data found in the inventory will be written to the machines,
regardless if they are in the burn command or not.

Burn the whole cluster.

```bash
(ENV3) (admin) you@yourlaptop $ cms burn raspberry "red,red0[1-4]" --device=/dev/sdb 
--inventory="inventory-red.yaml"
```

Burn a specific machine.

```bash
(ENV3) (admin) you@yourlaptop $ cms burn raspberry "red03" --device=/dev/sdb --inventory="inventory-red.yaml"
```

### 7.6 Managing known_hosts

In case you reburn a SDCard and use it in your cluster you will get a
warning once you try to ssh into the machine. To remove the error
simply execute the command

```bash
you@yourlaptop $ ssh-keygen -R HOSTNAME
```

where hostname is either the hostname or the ip address of your
machine. that is registered in known hosts.  To see the list, please
use

```bash
you@yourlaptop $ cat ~/.ssh/known_hosts
```

### 7.7 Get the OS Image

```bash
you@yourlaptop  $ cms burn image versions --refresh

+-----------------------+------------+-------------+--------+-----------------------------------------+
| Tag                   | Date       | OS          | Type   | Version                                 |
|-----------------------+------------+-------------+--------+-----------------------------------------|
| lite-2020-05-28       | 2020-05-28 | raspberryos | lite   | raspios_lite_armhf-2020-05-28           |
| lite-2020-08-24       | 2020-08-24 | raspberryos | lite   | raspios_lite_armhf-2020-08-24           |
| lite-2020-12-04       | 2020-12-04 | raspberryos | lite   | raspios_lite_armhf-2020-12-04           |
| lite-2021-01-12       | 2021-01-12 | raspberryos | lite   | raspios_lite_armhf-2021-01-12           |
| lite-2021-03-25       | 2021-03-25 | raspberryos | lite   | raspios_lite_armhf-2021-03-25           |
| lite-2021-05-28       | 2021-05-28 | raspberryos | lite   | raspios_lite_armhf-2021-05-28           |
| latest-lite           | 2021-05-28 | raspberryos | lite   | raspios_lite_armhf-2021-05-28           |
| full-2020-05-28       | 2020-05-28 | raspberryos | full   | raspios_full_armhf-2020-05-28           |
| full-2020-08-24       | 2020-08-24 | raspberryos | full   | raspios_full_armhf-2020-08-24           |
| full-2020-12-04       | 2020-12-04 | raspberryos | full   | raspios_full_armhf-2020-12-04           |
| full-2021-01-12       | 2021-01-12 | raspberryos | full   | raspios_full_armhf-2021-01-12           |
| full-2021-03-25       | 2021-03-25 | raspberryos | full   | raspios_full_armhf-2021-03-25           |
| full-2021-05-28       | 2021-05-28 | raspberryos | full   | raspios_full_armhf-2021-05-28           |
| latest-full           | 2021-05-28 | raspberryos | full   | raspios_full_armhf-2021-05-28           |
| ubuntu-20.04.2-64-bit | 2021-02-01 | ubuntu      | ubuntu | 20.04.2&architecture=server-arm64+raspi |
| ubuntu-20.04.2-32-bit | 2021-02-01 | ubuntu      | ubuntu | 20.04.2&architecture=server-armhf+raspi |
| ubuntu-20.10-64-bit   | 2021-02-01 | ubuntu      | ubuntu | 20.10&architecture=server-arm64+raspi   |
| ubuntu-20.10-32-bit   | 2021-02-01 | ubuntu      | ubuntu | 20.10&architecture=server-armhf+raspi   |
| ubuntu-desktop        | 2021-02-01 | ubuntu      | ubuntu | 20.10&architecture=desktop-arm64+raspi  |
+-----------------------+------------+-------------+--------+-----------------------------------------+
```

```bash
you@yourlaptop $ cms burn image get latest-lite
you@yourlaptop $ cms burn image get latest-fll
```

### 7.7 Related tutorials

- [ ] TODO find the links, point to the medium.com once first.

We provide also a list of related tutorials for other operating systems

This includes

Cluster with RaspberryOS on it:

* [Easy Raspberry PI Cluster Setup with Cloudmesh from MacOS](https://laszewski.medium.com/easy-raspberry-pi-cluster-setup-with-cloudmesh-from-macos-e160ac848bf)
* [Burning A Cluster with RaspberryOS on it from a Raspberry Pi]
* [TODO: Burning A Cluster with RaspberryOS on it from macOS](https://laszewski.medium.com/easy-raspberry-pi-cluster-setup-with-cloudmesh-sdcard-burner-a2035dfea22)
* [TODO: Burning A Cluster with RaspberryOS on it from Ubuntu]()
* [TODO: Burning A Cluster with RaspberryOS on it from Windows 10]()

Cluster with Ubuntu on it:

* [TODO: Burning A cluster with Ubuntu on it from macOS]()
* [TODO: Burning A cluster with Ubuntu on it from Ubuntu]()
* Please note that burning the clustere from Windows 10 with
  Ubuntu on the nodes has not yet been completed.
  If you like to help, contact us.

We have the following totorials also on other web pages. Here is a list


Hackaday:

* [Preconfigured SDCards for Raspberry Pi Clusters](https://hackaday.io/project/177874-preconfigured-sdcards-for-raspberry-pi-clusters)
* [https://hackaday.io/project/177904-headless-rasbery-pi-cluster-from-macs](https://hackaday.io/project/177904-headless-rasbery-pi-cluster-from-macs)

Piplanet:

Many tutorials are available at

* [piplanet.org/tutorial](https://cloudmesh.github.io/pi/tutorial/)




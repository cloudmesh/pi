
---
title: "Link Collection abut PI Clusters and Parts"
linkTitle: "Links"
weight: 20
description: >
  A number of links related to software to use PI's and create clusters.
---


{{% pageinfo %}}

**Learning Objectives**

* Get informed what resources exist

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

## Software

#### OS

* [RaspberyOS, 32 bit](https://www.raspberrypi.org/software/)
* [Ubuntu](https://ubuntu.com/download/raspberry-pi)
* [Ubuntu 20.04 Server, 64bit](https://ubuntu.com/download/raspberry-pi/thank-you?version=20.04.2&architecture=server-arm64+raspi)
* [Ubuntu 20.10 Server, 64bit](https://ubuntu.com/download/raspberry-pi/thank-you?version=20.10&architecture=server-arm64+raspi)
* [Ubuntu 20.10 Desktop, 64bit](https://ubuntu.com/download/raspberry-pi/thank-you?version=20.10&architecture=desktop-arm64+raspi)

### Booting and Startup

* [USB mass storage boot, raspberypi.org](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/msd.md)
* [Five Ways to Run a Program On Your Raspberry Pi At Startup](https://www.dexterindustries.com/howto/run-a-program-on-your-raspberry-pi-at-startup/)
* [How to Run a Script at Boot on Raspberry Pi, Tom's Hardware](https://www.tomshardware.com/how-to/run-script-at-boot-raspberry-pi)
  
#### SDCard Creation

* [Cludhmesh Pi Burn](https://github.com/cloudmesh/cloudmesh-pi-burn/blob/main/README.md) Very good for burning multiple cars for clusters with easy setup of a cluster of PIs that are fully connected with each other. 
* [Pi Imager, raspberrypi.org](https://www.raspberrypi.org/blog/raspberry-pi-imager-imaging-utility/) Best suited for burning individuall cards. Requires additional work after burning, such as setting hostname, and enable ssh. Time consuming when setting up a cluster.
* [Pi Bakery](https://www.pibakery.org/) Easy setup of individual Pis, with the ability to add post instalation information such as Wifi, hostname and others. GUI driven. Not targeted towards Cluster setups.

#### PXE Boot

* [Pi4 Network booting, raspberrypi.org](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net.md)
* [Tutoria Network boot your Raspberry Pig, raspberrypi.org](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net_tutorial.md)


### Network of Workstations

* [Cludhmesh Pi Burn](https://github.com/cloudmesh/cloudmesh-pi-burn/blob/main/README.md) Setting up a cluster of Pis easily including ssh, keys, and networking.

### SLURM

* [Slurm on Pi zero, raspberrypi.org Forum post](https://www.raspberrypi.org/forums/viewtopic.php?p=1261596#p1261596)

### MPI

* [Build a Raspberry Pi cluster computer, The MagPi magazine](https://magpi.raspberrypi.org/articles/build-a-raspberry-pi-cluster-computer)
* [Installing MPI for Python on a Raspberry Pi Cluster, The New Stack](https://thenewstack.io/installing-mpi-python-raspberry-pi-cluster-runs-docker/)
* [Building a Raspberry Pi Cluster. Part III - OpenMPI, Python, and Parallel, Garrett Mills, Medium](https://glmdev.medium.com/building-a-raspberry-pi-cluster-f5f2446702e8) Medium requires a subscription if you read more than a small number of articles

### Kubernetes

* see our special section on kubernetes
  
### Network Configurations

#### mDNS

* [Going headless with Avahi Zeroconf MDNS (Pi4, maybe Pi 3B, etc) - Raspberry Pi Forums](https://www.raspberrypi.org/forums/viewtopic.php?t=267113)

#### Mesh Network

* [Workshop to create a sensor application over a WiFi Mesh network, binnes, GitHub](https://github.com/binnes/WiFiMeshRaspberryPi),
* [DIY: How to Create a Home Mesh WiFi using Raspberry Pi | iotTrends.tech](https://www.iottrends.tech/blog/diy-how-to-create-a-home-mesh-wifi-using-raspberry-pi/)


---
date: 2021-02-07
title: "Ubuntu on the Pi"
linkTitle: "Ubuntu"
description: "A collection of links and tutrials that halp making using Ubuntu on the Pi."
author: Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" >}}
Upuntu Turorials
{{< /imgproc >}}


{{% pageinfo %}}

A collection of links and tutorials that halp making using Ubuntu on the Pi.

**Learning Objectives**

* Find tutorials and useful infpormation about PI's and Ubuntu.
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## Introduction

Ubuntu is a real good alternative for an operating system on teh PI. The reason
is that at this time RaspberryOS is only supporting 32-bit, while Ubuntu
supports both 32 and 64 bit versions of their operating system. We recommend to
just install the 64 bit version.

## Canonical Tutorials

* [The very useful Wiki](https://wiki.ubuntu.com/ARM/RaspberryPi)
* [Ubuntu PI tutorials from Canonical](https://ubuntu.com/tutorials?q=pi)
  
  Currently this includes

  * [How to install Ubuntu Desktop on Raspberry Pi 4](https://ubuntu.com/tutorials/how-to-install-ubuntu-desktop-on-raspberry-pi-4#1-overview)
  * [How to create an Ubuntu Server SDcard for Raspberry Pi](How to create an Ubuntu Server SDcard for Raspberry Pi)
  * [How to install Ubuntu Server on your Raspberry Pi](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview)
  * [How to build a Raspberry Pi Kubernetes cluster using MicroK8s](https://ubuntu.com/tutorials/how-to-kubernetes-cluster-on-raspberry-pi#1-overview)
  * [How to install Ubuntu Core on your Raspberry Pi](https://ubuntu.com/tutorials/how-to-install-ubuntu-core-on-raspberry-pi#1-overview)
  * [Create an Ubuntu image for a Raspberry Pi on Windows](https://ubuntu.com/tutorials/create-an-ubuntu-image-for-a-raspberry-pi-on-windows#1-overview)
  * [Create an Ubuntu image for a Raspberry Pi on MacOS](https://ubuntu.com/tutorials/create-an-ubuntu-image-for-a-raspberry-pi-on-macos#1-overview)
  * [Create an Ubuntu image for a Raspberry Pi on Ubuntu](https://ubuntu.com/tutorials/create-an-ubuntu-image-for-a-raspberry-pi-on-ubuntu#1-overview)
  * [How to use the AdGuard Home Ubuntu Appliance](https://ubuntu.com/tutorials/how-to-install-adguard-home-raspberry-pi#1-overview)
  
## Initialization

* [Clud init](https://cloudinit.readthedocs.io/en/latest/)
* [Headless Setup via user-data](https://roboticsbackend.com/install-ubuntu-on-raspberry-pi-without-monitor/)
  * [network](https://stackoverflow.com/questions/62930794/ubuntu-focal-headless-setup-on-raspberry-pi-4-cloud-init-wifi-initialisation-b)
  * [user-data](https://askubuntu.com/questions/1302840/ubuntu-setup-user-data-ssh)
  
## FAQ

### dd from compressed files

from: https://www.zdnet.com/article/hands-on-adventures-with-ubuntu-linux-on-the-raspberry-pi-4/

```
xzcat ubuntu-20.10-preinstalled-desktop-arm64+raspi.img.xz | dd bs=4M of=/dev/sdX iflag=fullblock oflag=direct status=progress
```

xzcat uncompresses the download file and writes it to standard output, so we can pipe it to the dd command
dd is the Linux raw copy utility, which will actually write the data to the SD card
bs=4M tells dd to read/write the data in blocks of 4 Megabytes
of=/dev/sdX tells dd where to write the output; you need to replace the X with the device identifier for the SD card on your system; be very careful about this, because putting the wrong character here can have catastrophic consequences
iflag=fullblock tells dd to accumulate full blocks on the input before proceeding to the output
oflag=direct tells dd to use direct I/O operations for the data
status=progress tells dd to show a periodic summary of the data transfer


### cloudint reset

* https://www.raspberrypi.org/forums/viewtopic.php?t=255465

sudo cloud-init clean --logs --reboot

Will cause cloud-init to reset itself and re-run after rebooting the machine.
Note that this does not clean up everything that cloud-init did the first time
round (user creation, file-writing, etc.), so depending on the configuration it
may or may not work successfully the second time (though generally I've found
it reasonably useful for testing). Currently, the only way to completely clean
the system is to re-image.


### k3s

* good tutorial: https://mhausenblas.info/kube-rpi/
* https://medium.com/@amadmalik/installing-kubernetes-on-raspberry-pi-k3s-and-docker-on-ubuntu-20-04-ef51e5e56

### k3sup with static adresses

* Important read but we want to use k3s and not k3sup
  https://medium.com/icetek/building-a-kubernetes-cluster-on-raspberry-pi-running-ubuntu-server-8fc4edb30963

* https://ma.ttias.be/deploying-highly-available-k3s-k3sup/

### k9s

some tool, nt sure if useful

* https://github.com/derailed/k9s
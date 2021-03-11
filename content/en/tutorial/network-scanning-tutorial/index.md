---
date: 2021-02-07
title: "Network Scanning Tutorial"
linkTitle: "Network Scanning Tutorial"
description: "This post includes useful network enumeration commands."
author: Anthony Orlowski ([antorlowski@gmail.com](mailto:antorlowski@gmail.com))
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{< imgproc image Fill "600x300" >}}
The Web Page.
{{< /imgproc >}}


{{% pageinfo %}}

Abstract

**Learning Objectives**

* Learn how to enumerate and verify network conditions on a Pi cluster.
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## Introduction

While working with clusters there will be many times you need to 
troubleshoot network connectivity. Below are useful commands to help you enumerate 
and verify you network is operating correctly.

### IP Address

The ip address command can help you determine your network interface card 
configuration (NIC) including IP address, networks, and MAC address. 

```
(ENV3) pi@red:~ $ ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether dc:a6:32:e8:03:09 brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.1/24 brd 10.1.1.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::bc02:69de:ea6d:78a2/64 scope link 
       valid_lft forever preferred_lft forever
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether dc:a6:32:e8:03:0a brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.27/24 brd 192.168.1.255 scope global dynamic noprefixroute wlan0
       valid_lft 86368sec preferred_lft 75568sec
    inet6 fe80::20a9:5c10:42fe:5eb0/64 scope link 
       valid_lft forever preferred_lft forever
(ENV3) pi@red:~ $ 

```

### Ping

To ping an IP address

```
ping 10.1.1.1
```

#### Ping when you do not know the IP address. 

Try using multicast doman name servcie (mDNS) to resolve the hostname using 
the .local extension.

```
ping red.local
```

#### Ping from a specific interface

If you need to ping out a specific interface, such as eth0 or wlan0

```
ping -I wlan0 red.local
```

### ARP

When your computer needs to send a packet to an IP address it must 
first determine the next hop MAC address. It does this using the ARP protocol. 

#### To view the ARP table (MAC Address to IP address )

Next hop MAC address to IP pairings can be viewed in the ARP table. The ARP 
also contains conveniently contains hostnames if they were resolved. 

```
arp -a
```

```
pi@red:~ $ arp -a
red001 (10.1.1.2) at dc:a6:32:e7:fe:69 [ether] on eth0
? (192.168.1.1) at dc:ef:09:d9:5f:64 [ether] on wlan0
? (192.168.1.12) at e4:b3:18:d4:bd:d1 [ether] on wlan0
? (192.168.1.14) at e8:d8:d1:82:42:b8 [ether] on wlan0
red002 (10.1.1.3) at dc:a6:32:e8:02:25 [ether] on eth0
```

#### To clear the ARP table, forcing MAC addresses to be resolved again on next use.

```
ip -s -s neigh flush all
```

### Route

The route command shows you all the rules you machine uses to route packets.

The example below informs us the default route is using the wlan0 interface, 
while the 10.1.1.0/24 network will be reached using the eth0 interface.

```
pi@red:~ $ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         192.168.1.1     0.0.0.0         UG    303    0        0 wlan0
10.1.1.0        0.0.0.0         255.255.255.0   U     202    0        0 eth0
192.168.1.0     0.0.0.0         255.255.255.0   U     303    0        0 wlan0
```

### Traceroute

Traceroute is a tool to determine the network routers on a path from your 
host to a destination ip. For example, lets verify the worker (red001) uses the 
manager pi (10.1.1.1) to reach the internet (8.8.8.8)

```
pi@red001:~ $ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  red (10.1.1.1)  0.290 ms  0.252 ms  0.182 ms
 2  192.168.1.1 (192.168.1.1)  3.362 ms  3.577 ms  3.484 ms
 3  96.120.112.113 (96.120.112.113)  22.974 ms  15.305 ms  21.364 ms
 4  96.110.168.9 (96.110.168.9)  20.590 ms  19.890 ms  20.401 ms
 5  96.108.120.86 (96.108.120.86)  20.164 ms  21.079 ms  21.164 ms
 6  96.108.120.145 (96.108.120.145)  27.577 ms  22.101 ms  22.144 ms
 7  24.153.88.85 (24.153.88.85)  28.857 ms  29.504 ms  29.553 ms
 8  be-32241-cs04.350ecermak.il.ibone.comcast.net (96.110.40.61)  30.314 ms  31.071 ms  31.177 ms
 9  be-2112-pe12.350ecermak.il.ibone.comcast.net (96.110.33.210)  36.510 ms be-2412-pe12.350ecermak.il.ibone.comcast.net (96.110.33.222)  36.423 ms be-2111-pe11.350ecermak.il.ibone.comcast.net (96.110.33.194)  35.794 ms
10  96-87-9-122-static.hfc.comcastbusiness.net (96.87.9.122)  33.767 ms 66.208.233.86 (66.208.233.86)  34.202 ms 96-87-9-122-static.hfc.comcastbusiness.net (96.87.9.122)  34.035 ms
11  * * *
12  dns.google (8.8.8.8)  33.843 ms  33.433 ms  34.622 ms

```

#### NMAP

NMAP is a a tool that can conduct a wide variety of network scans. We will 
use NMAP to find the IP of our manager pi (red) from our laptop on our 
wireless network (192.168.1.0/24). 

> Note: Raspberry Pi MAC addresses start with DC:A6:32, so we know 192.168.1.
> 27 is our manager pi

```
anthony@anthony-ubuntu:~$ sudo nmap -sP 192.168.1.0/24

Starting Nmap 7.60 ( https://nmap.org ) at 2021-03-11 14:16 EST
Nmap scan report for _gateway (192.168.1.1)
Host is up (0.0031s latency).
MAC Address: DC:EF:09:D9:5F:64 (Netgear)
Nmap scan report for 192.168.1.7
Host is up (0.18s latency).
MAC Address: E0:F6:B5:EA:C6:CC (Unknown)
Nmap scan report for 192.168.1.14
Host is up (0.46s latency).
MAC Address: E8:D8:D1:82:42:B8 (Unknown)
Nmap scan report for 192.168.1.19
Host is up (-0.017s latency).
MAC Address: 34:93:42:87:BA:46 (Unknown)
Nmap scan report for 192.168.1.23
Host is up (0.98s latency).
MAC Address: D0:D2:B0:90:2E:60 (Apple)
Nmap scan report for 192.168.1.27
Host is up (1.5s latency).
MAC Address: DC:A6:32:E8:03:0A (Unknown)
Nmap scan report for anthony-ubuntu (192.168.1.12)
Host is up.
Nmap done: 256 IP addresses (7 hosts up) scanned in 17.90 seconds
```

### /etc/hosts

This file contains static hostname to IP mappings.

```
(ENV3) pi@red:~ $ cat /etc/hosts
127.0.0.1  localhost
::1        localhost ip6-localhost ip6-loopback
ff02::1    ip6-allnodes
ff02::2    ip6-allrouters
#
127.0.1.1  red
#
10.1.1.1	red
10.1.1.2	red001
10.1.1.3	red002
```


---
date: 2021-02-07
title: "Installing K3S on Cloudmesh"
linkTitle: "Installing K3S on Cloudmesh"
draft: True
description: "This tutorial explains basics of K3S and provides instructions to Install on Cloudmesh"
author: Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: True
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{< imgproc image Fill "600x300" >}}
TODO: Caption for the image
{{< /imgproc >}}


{{% pageinfo %}}

Please describe what this tutorial is about. 

**Learning Objectives**

* Learn how to ...
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## Introduction

K3s is a lightweight version of Kubernetes. It is a highly available Kubernetes certified distribution designed for production workloads in unattended, limited resource, remote locations, or inside an IoT appliance. The developers of K3s declare that K3s is capable of almost everything that K8s can do. 

So, what makes it such a lightweight distribution?

The memory usage is reduced by running many components within a single process. This eliminates the significant overhead that would otherwise be duplicated for each component. The binary file size is smaller by removing third-party storage drivers and cloud service providers.

* Running it requires less memory.
* A small, 40Mb binary file that contains all the non-container components for starting a cluster. 

## Features

K3s is a fully compatible K8s distribution with the following features:

* It is packaged as a single binary file.
* It contains a lightweight backend storage medium based on SQLite3 (a lightweight embedded database management system) as the default storage engine. Etcd3, MySQL, and Postgres databases are also available.
* K3s uses a simple launcher that handles many complex TLS duties and other functions.
* Added features include such features as a local storage provider, load balancer, Helm controller (tooltip: a packager that helps install and manage the lifecycle of K8s applications), and the Traefik login controller (tooltip: a Docker-enabled reverse proxy that provides a built-in dashboard).
vAll control components operate within a single binary file and process.
* Most all external dependencies have been minimized to reduce size.

## Install K3S on Manager
```
curl -sfL https://get.k3s.io | sh -
```

## Verify Installation

```
status k3s
```

## Utilities installed on Manager

* kubectl - A handy CLI-based program for interacting with K3s via a console or terminal.
* crictl - This is a program used for communicating with the containers and other container runtimes.
* k3s-killall.sh - : This is a bash script that cleans up all containers and network components after the install.
* k3s-uninstall.sh: This is a bash script that removes all clusters and scripts.

## Configuration

The kubeconfig file is written to /etc/rancher/k3s/k3s.yaml. This file is required for the Kubernetes configuration.

## Add workers

```
curl -sfL https://get.k3s.io | K3S_URL=${k3s_url} K3S_TOKEN=${k3s_token} sh -
```

## Cloumesh Commands

```
    pi k3 install [--master=MASTER] [--workers=WORKERS] [--step=COMMAND]
    pi k3 join --master=MASTER --workers=WORKERS
    pi k3 uninstall [--master=MASTER] [--workers=WORKERS]
    pi k3 delete [--master=MASTER] [--workers=WORKERS]
    pi k3 status [--master=MASTER] [--workers=WORKERS]
    pi k3 view
    pi script list SERVICE [--details]
    pi script list SERVICE NAMES
    pi script list
    
```


## References

[K3S]: K3S installation, <https://www.liquidweb.com/kb/how-to-install-and-configure-k3s-on-ubuntu-18-04/>


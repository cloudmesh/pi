
---
title: "Kubernetes"
linkTitle: "Kubernetes"
description: >
  Links related to running Kubernetes on a Pi cluster.
---

{{% pageinfo %}}

**Learning Objectives**

* Get informed what others do

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

TBD

* Identified as useful: <https://opensource.com/article/20/3/kubernetes-raspberry-pi-k3s>


Complete to this format:

* [title, author, publication, date](https://google.com)


### fedora

* [Kubernetes on Raspberry Pi 4 on Fedora, Matthias Runge, 04 January 2021](http://www.matthias-runge.de/2021/01/04/k8s-raspi4-fedora/)
  kubespray
* [apacheconna2017](https://archive.fosdem.org/2020/schedule/event/containers_k8s_arm64/attachments/slides/3806/export/events/attachments/containers_k8s_arm64/slides/3806/Cloud.pdf)
  unclear firmware update, ppt, fedora


### x86 via docker

* [Raspberry Pi 4 Kubernetes Cluster with x86 Support, Ajay Patel](https://ajayp.app/posts/2020/06/raspberry-pi-4-kubernetes-cluster-with-x86-support/)
  sd cards may fail on heavy RW


### Raspbian

* [Running a Kubernetes Cluster with Dashboard on Raspberry Pi 4, Jeppe Andersen Blog, Nov 3, 2019](https://www.nocture.dk/2020/07/02/running-a-kubernetes-cluster-with-dashboard-on-raspberry-pi-4/)
  dashboard
* [codesqueak/k18srpi4: Kubernetes on a Raspberry Pi 4 Cluster,  Nov 3, 2019](https://github.com/codesqueak/k18srpi4)
  Raspbian Buster Lite / Kernel 4:19


### Ubuntu

* [Ubuntu 20.10 on Raspberry Pi delivers the full Linux desktop and micro clouds, Ubuntu](https://ubuntu.com/blog/ubuntu-20-10-on-raspberry-pi-delivers-the-full-linux-desktop-and-micro-clouds)
* [Build a Kubernetes cluster with the Raspberry Pi,  Chris Collins, Opensource.com, 05 Jun 2020](https://opensource.com/article/20/6/kubernetes-raspberry-pi)
  Ubuntu easy to follow, uses upto date ubuntu kubernetes install
* [How Raspberry Pi and Kubernetes work together, The Enterprisers Project](https://enterprisersproject.com/article/2020/9/how-raspberry-pi-and-kubernetes-go-together)
  just a pointer to Collins page
* [How to build a Raspberry Pi Kubernetes cluster using MicroK8s, Ubuntu](https://ubuntu.com/tutorials/how-to-kubernetes-cluster-on-raspberry-pi#1-overview)
  easy to follow, discusses cgroups in cmmdline.txt 
* [Kubernetes on 64 Bit OS Raspberry Pi 4 · Robert Sirchia](https://sirchia.cloud/posts/kubernetes-on-64-bit-os-raspberry-pi-4/)
  Ubuntu 19.10
* [Running kubernetes on Raspberry Pi - Viktor Andersson](https://viktorvan.github.io/kubernetes/kubernetes-on-raspberry-pi/)
  Ubuntu likely outdated, has comment on large sd cards, mentions PI3 and Pi4
* [mhausenblas/kube-rpi: Kubernetes on Raspberry Pi 4 with 64-bit OS](https://github.com/mhausenblas/kube-rpi)
  tp link wireless to wired, ubuntu 19.10

### RancherOS

* [Rancher Docs: Raspberry Pi](https://rancher.com/docs/os/v1.x/en/installation/server/raspberry-pi/)
  Pi3
* [Home, Raspberry Pi Dramble, Jeff Gerling Github ](https://www.pidramble.com/)
  Needs evaluation

### k8s

* [Kubernetes (K8s) Private Cloud with Raspberry Pi 4s - DEV Community](https://dev.to/anton2079/kubernetes-k8s-private-cloud-with-raspberry-pi-4s-k0d)
* [KubeSail Blog, MicroK8s on the Raspberry Pi 4](https://kubesail.com/blog/microk8s-raspberry-pi/)


### k3s

* [k3s-io/k3s: Lightweight Kubernetes](https://github.com/k3s-io/k3s)
* [How Rancher Labs’ K3s Makes It Easy to Run Kubernetes at the Edge – The New Stack](https://thenewstack.io/how-rancher-labs-k3s-makes-it-easy-to-run-kubernetes-at-the-edge/)
* [K3s: Lightweight Kubernetes](https://k3s.io/)
* [Tutorial: Install a Highly Available K3s Cluster at the Edge – The New Stack](https://thenewstack.io/tutorial-install-a-highly-available-k3s-cluster-at-the-edge/)
* [Raspberry Pi Cluster Part 2: ToDo API running on Kubernetes with k3s](https://www.dinofizzotti.com/blog/2020-05-09-raspberry-pi-cluster-part-2-todo-api-running-on-kubernetes-with-k3s/)
* [Self-hosting Kubernetes on your Raspberry Pi](https://blog.alexellis.io/self-hosting-kubernetes-on-your-raspberry-pi/)
  Reports Pi 3 have issues with kubernetes, k3s, arcade

### Hyperoid, k3s

* [Everything I know about Kubernetes I learned from a cluster of Raspberry Pis, Jeff Geerling, November 26, 2019](https://www.jeffgeerling.com/blog/2019/everything-i-know-about-kubernetes-i-learned-cluster-raspberry-pis)
  k3s-ansible, nice videos, lists many other options for k*, requires to go in various parts
* [K3s vs k8s – What’s the difference between K8s and k3s - Civo.com](https://www.civo.com/blog/k8s-vs-k3s)

### TuringPI

* https://turingpi.com/installing-kubernetes-cluster-on-the-turingpi/

### k3sup

* [Kubernetes Homelab with Raspberry Pi and k3sup](https://blog.alexellis.io/raspberry-pi-homelab-with-k3sup/)

### microk8

* [MicroK8s tutorials](https://microk8s.io/tutorials)

### Medium.com

Requires fee, if you read several articles (I have not read them)

* [Walk-through — install Kubernetes to your Raspberry Pi in 15 minutes, Alex Ellis, Mar 1, 2020·9, Medium](https://alexellisuk.medium.com/walk-through-install-kubernetes-to-your-raspberry-pi-in-15-minutes-84a8492dc95a)
  requires access to medium.com
* [Kubernetes 1.17 on a Raspberry Pi 4 Cluster, Jamie Duncan, Dec 16, 2019·5, Medium](https://medium.com/@jamieeduncan/kubernetes-1-17-on-a-raspberry-pi-4-cluster-4a259b804664)
* [Step Stepguide — Kubernetes Cluster on Raspberry Pi 4B: kubernetes](https://www.reddit.com/r/kubernetes/comments/enojpn/step_by_stepguide_kubernetes_cluster_on_raspberry/)
* [Building a kubernetes cluster on Raspberry Pi and low-end equipment. Part 1, Eduard Iskandarov, ITNEXT](https://itnext.io/building-a-kubernetes-cluster-on-raspberry-pi-and-low-end-equipment-part-1-a768359fbba3)


## Services

### Azure SQL Edge

* [Building a Raspberry Pi cluster to run Azure SQL Edge on Kubernetes, DBA From The Cold](https://dbafromthecold.com/2020/11/30/building-a-raspberry-pi-cluster-to-run-azure-sql-edge-on-kubernetes/)


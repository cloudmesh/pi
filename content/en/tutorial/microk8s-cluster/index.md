---
date: 2021-04-13
title: "Employ MicroK8s on a Pi Cluster"
linkTitle: "Employ MicroK8s on a Pi Cluster"
description: "Easily install your own MicroK8s cluster on Raspberry Pis"
author: Anthony Orlowski, Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: True
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{< imgproc image Fill "600x300" >}}
{{< /imgproc >}}


{{% pageinfo %}}

Install, manage, operate, and uninstall MicroK8s on a cluster of Raspberry Pis 
running Ubuntu.

**Learning Objectives**

* Learn how to easily install, manage, operate, and unisntall a MicroK8s cluster 
  using `cms`.
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## 1. Introduction

MicroK8s provides a lightweight distribution of Kubernetes that is good for 
single board computers like the Raspberry Pi. MicroK8s features a 
distributed sql database and features a high-availability protocol. In this 
tutorial we will install, verify, and unistall MicroK8s on a cluster of Pis that was created using the Cloudmesh burn 
software.

## 2. Prequisites

This tutorial assumes a cluster burned using one of the following methods:


[Burn an Ubuntu Cluster](https://cloudmesh.github.io/pi/tutorial/ubuntu-burn/)

[Use our GUI to Burn a Cluster](https://cloudmesh.github.io/pi/tutorial/gui-burn/)

The tutorial supports Ubuntu as the cluster OS.

>NOTE: currently the microk8s snap  is not avalaible for armhf. It is 
> available for arm64, but our clusters only support the 32-bit Raspberry OS

## 3. CMS microk8s Commands
```
        pi microk8s install NAMES
        pi microk8s uninstall NAMES
        pi microk8s start NAMES
        pi microk8s stop NAMES
        pi microk8s inspect NAMES
        pi microk8s enable addon ADDONS NAMES
        pi microk8s cluster info SERVER
        pi microk8s join NAMES SERVER
        pi microk8s get node SERVER
        pi microk8s remove node NAMES
```

## 4. Install MicroK8s on the Cluster

```
you@yourlaptop:~/cm$ cms pi microk8s install white,white0[1-6]
pi microk8s install white,white0[1-6]
INFO: Installing microk8s on ['white', 'white01', 'white02', 'white03', 'white04', 'white05', 'white06']
INFO: This may take a few minutes
+---------+---------+--------------------------------------------------+
| host    | success | stdout                                           |
+---------+---------+--------------------------------------------------+
| white   | True    | microk8s (1.20/stable) v1.20.5 from Canonical*   |
|         |         | installed                                        |
| white01 | True    | microk8s (1.20/stable) v1.20.5 from Canonical*   |
|         |         | installed                                        |
| white02 | True    | microk8s (1.20/stable) v1.20.5 from Canonical*   |
|         |         | installed                                        |
| white03 | True    | microk8s (1.20/stable) v1.20.5 from Canonical*   |
|         |         | installed                                        |
+---------+---------+--------------------------------------------------+
```

At this point each node is its own stand-alone MicroK8s node. We need to 
join at least three of them together to support high-availability features.  

## 5. Join Nodes to be a Cluster

Unfortunately, we are required to join the nodes sequentially, so this may take 
some time to execute.

```
you@yourlaptop:~/cm$ cms pi microk8s join white0[1-3] white
pi microk8s join white0[1-3] white
INFO: Joining nodes ['white01', 'white02', 'white03'] to server white
INFO: Fetching unique join URL from white for each worker
Using join  command: sudo microk8s join 192.168.1.16:25000/ee096e8a19aff04d50a6c9662c40fcc3 &
INFO: Joining white01 to the white
INFO: This may take a few minutes
+---------+---------+--------------------------------------------------+
| host    | success | stdout                                           |
+---------+---------+--------------------------------------------------+
| white01 | True    | Contacting cluster at 192.168.1.16               |
|         |         | Waiting for this node to finish joining the      |
|         |         | cluster. ..                                      |
+---------+---------+--------------------------------------------------+
INFO: Fetching unique join URL from white for each worker
Using join  command: sudo microk8s join 192.168.1.16:25000/283316a2680bac5dfbf1aa4cd1a8c31a &
INFO: Joining white02 to the white
INFO: This may take a few minutes
+---------+---------+--------------------------------------------------+
| host    | success | stdout                                           |
+---------+---------+--------------------------------------------------+
| white02 | True    | Contacting cluster at 192.168.1.16               |
|         |         | Waiting for this node to finish joining the      |
|         |         | cluster. ..                                      |
+---------+---------+--------------------------------------------------+
INFO: Fetching unique join URL from white for each worker
Using join  command: sudo microk8s join 192.168.1.16:25000/3908f9412faa4ec006cbfc06e6e496e8 &
INFO: Joining white03 to the white
INFO: This may take a few minutes
+---------+---------+--------------------------------------------------+
| host    | success | stdout                                           |
+---------+---------+--------------------------------------------------+
| white03 | True    | Contacting cluster at 192.168.1.16               |
|         |         | Waiting for this node to finish joining the      |
|         |         | cluster. ..                                      |
+---------+---------+--------------------------------------------------+

```

You now have a MicroK8s cluster

## 6. Get Node Info

```
you@yourlaptop:~/cm$ cms pi microk8s get node white
pi microk8s get node white
INFO: Getting node info from server white
NAME      STATUS   ROLES    AGE     VERSION                     INTERNAL-IP    EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION     CONTAINER-RUNTIME
white01   Ready    <none>   10m     v1.20.5-34+057bda1e79d450   10.1.1.2       <none>        Ubuntu 20.10   5.8.0-1019-raspi   containerd://1.3.7
white03   Ready    <none>   4m46s   v1.20.5-34+057bda1e79d450   10.1.1.4       <none>        Ubuntu 20.10   5.8.0-1019-raspi   containerd://1.3.7
white02   Ready    <none>   7m24s   v1.20.5-34+057bda1e79d450   10.1.1.3       <none>        Ubuntu 20.10   5.8.0-1019-raspi   containerd://1.3.7
white     Ready    <none>   17m     v1.20.5-34+057bda1e79d450   192.168.1.16   <none>        Ubuntu 20.10   5.8.0-1006-raspi   containerd://1.3.7
```

## 8. Enable Addons 

```
you@yourlaptop:~/cm$ cms pi microk8s enable addon dns,dashboard white
pi microk8s enable addon dns,dashboard white
INFO: Enabling addons dns dashboard on ['white']
+-------+---------+--------------------------------------------------+
| host  | success | stdout                                           |
+-------+---------+--------------------------------------------------+
| white | True    | Enabling DNS                                     |
|       |         | Applying manifest                                |
|       |         | serviceaccount/coredns created                   |
|       |         | configmap/coredns created                        |
|       |         | deployment.apps/coredns created                  |
|       |         | service/kube-dns created                         |
|       |         | clusterrole.rbac.authorization.k8s.io/coredns    |
|       |         | created                                          |
|       |         | clusterrolebinding.rbac.authorization.k8s.io/cor |
|       |         | edns created                                     |
|       |         | Restarting kubelet                               |
|       |         | Adding argument --cluster-domain to nodes.       |
|       |         | Configuring node 10.1.1.4                        |
|       |         | Configuring node 10.1.1.2                        |
|       |         | Configuring node 10.1.1.3                        |
|       |         | Adding argument --cluster-dns to nodes.          |
|       |         | Configuring node 10.1.1.4                        |
|       |         | Configuring node 10.1.1.2                        |
|       |         | Configuring node 10.1.1.3                        |
|       |         | Restarting nodes.                                |
|       |         | Configuring node 10.1.1.4                        |
|       |         | Configuring node 10.1.1.2                        |
|       |         | Configuring node 10.1.1.3                        |
|       |         | DNS is enabled                                   |
|       |         | Enabling Kubernetes Dashboard                    |
|       |         | Enabling Metrics-Server                          |
|       |         | clusterrole.rbac.authorization.k8s.io/system:agg |
|       |         | regated-metrics-reader created                   |
|       |         | clusterrolebinding.rbac.authorization.k8s.io/met |
|       |         | rics-server:system:auth-delegator created        |
|       |         | rolebinding.rbac.authorization.k8s.io/metrics-   |
|       |         | server-auth-reader created                       |
|       |         | apiservice.apiregistration.k8s.io/v1beta1.metric |
|       |         | s.k8s.io created                                 |
|       |         | serviceaccount/metrics-server created            |
|       |         | deployment.apps/metrics-server created           |
|       |         | service/metrics-server created                   |
|       |         | clusterrole.rbac.authorization.k8s.io/system:met |
|       |         | rics-server created                              |
|       |         | clusterrolebinding.rbac.authorization.k8s.io/sys |
|       |         | tem:metrics-server created                       |
|       |         | clusterrolebinding.rbac.authorization.k8s.io/mic |
|       |         | rok8s-admin created                              |
|       |         | Adding argument --authentication-token-webhook   |
|       |         | to nodes.                                        |
|       |         | Configuring node 10.1.1.4                        |
|       |         | Configuring node 10.1.1.2                        |
|       |         | Configuring node 10.1.1.3                        |
|       |         | Metrics-Server is enabled                        |
|       |         | Applying manifest                                |
|       |         | serviceaccount/kubernetes-dashboard created      |
|       |         | service/kubernetes-dashboard created             |
|       |         | secret/kubernetes-dashboard-certs created        |
|       |         | secret/kubernetes-dashboard-csrf created         |
|       |         | secret/kubernetes-dashboard-key-holder created   |
|       |         | configmap/kubernetes-dashboard-settings created  |
|       |         | role.rbac.authorization.k8s.io/kubernetes-       |
|       |         | dashboard created                                |
|       |         | clusterrole.rbac.authorization.k8s.io/kubernetes |
|       |         | -dashboard created                               |
|       |         | rolebinding.rbac.authorization.k8s.io/kubernetes |
|       |         | -dashboard created                               |
|       |         | clusterrolebinding.rbac.authorization.k8s.io/kub |
|       |         | ernetes-dashboard created                        |
|       |         | deployment.apps/kubernetes-dashboard created     |
|       |         | service/dashboard-metrics-scraper created        |
|       |         | deployment.apps/dashboard-metrics-scraper        |
|       |         | created                                          |
|       |         |                                                  |
|       |         | If RBAC is not enabled access the dashboard      |
|       |         | using the default token retrieved with:          |
|       |         |                                                  |
|       |         | token=$(microk8s kubectl -n kube-system get      |
|       |         | secret | grep default-token | cut -d " " -f1)    |
|       |         | microk8s kubectl -n kube-system describe secret  |
|       |         | $token                                           |
|       |         |                                                  |
|       |         | In an RBAC enabled setup (microk8s enable RBAC)  |
|       |         | you need to create a user with restricted        |
|       |         | permissions as shown in:                         |
|       |         | https://github.com/kubernetes/dashboard/blob/mas |
|       |         | ter/docs/user/access-control/creating-sample-    |
|       |         | user.md                                          |
+-------+---------+--------------------------------------------------+
```

## 7. Get Cluster Info

```
you@yourlaptop:~/cm$ cms pi microk8s cluster info white
pi microk8s cluster info white
INFO: Getting cluster info from server white

Kubernetes control plane is running at https://127.0.0.1:16443
CoreDNS is running at https://127.0.0.1:16443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://127.0.0.1:16443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## 9. Start the MicroK8s Services

```
you@yourlaptop:~/cm$ cms pi microk8s start white,white0[1-2]
pi microk8s start white,white0[1-2]
INFO: Starting microk8s services on ['white', 'white01', 'white02']
+---------+---------+----------+
| host    | success | stdout   |
+---------+---------+----------+
| white   | True    | Started. |
| white01 | True    | Started. |
| white02 | True    | Started. |
+---------+---------+----------+
```

## 10. Stop the MicroK8s Services

```
you@yourlaptop:~/cm$ cms pi microk8s stop white,white0[1-2]
pi microk8s stop white,white0[1-2]
INFO: Stopping microk8s services on ['white', 'white01', 'white02']
+---------+---------+----------+
| host    | success | stdout   |
+---------+---------+----------+
| white   | True    | Stopped. |
| white01 | True    | Stopped. |
| white02 | True    | Stopped. |
+---------+---------+----------+
```

## 11. Inspect the MicroK8s Services

```
you@yourlaptop:~/cm$ cms pi microk8s inspect white,white0[1-2]
pi microk8s inspect white,white0[1-2]
INFO: Inspecting microk8s services on ['white', 'white01', 'white02']
+---------+---------+--------------------------------------------------+
| host    | success | stdout                                           |
+---------+---------+--------------------------------------------------+
| white   | True    | Inspecting Certificates                          |
|         |         | Inspecting services                              |
|         |         |   Service snap.microk8s.daemon-cluster-agent is  |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-containerd is     |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-apiserver is      |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-apiserver-kicker  |
|         |         | is running                                       |
|         |         |   Service snap.microk8s.daemon-control-plane-    |
|         |         | kicker is running                                |
|         |         |   Service snap.microk8s.daemon-proxy is running  |
|         |         |   Service snap.microk8s.daemon-kubelet is        |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-scheduler is      |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-controller-       |
|         |         | manager is running                               |
|         |         |   Copy service arguments to the final report     |
|         |         | tarball                                          |
|         |         | Inspecting AppArmor configuration                |
|         |         | Gathering system information                     |
|         |         |   Copy processes list to the final report        |
|         |         | tarball                                          |
|         |         |   Copy snap list to the final report tarball     |
|         |         |   Copy VM name (or none) to the final report     |
|         |         | tarball                                          |
|         |         |   Copy disk usage information to the final       |
|         |         | report tarball                                   |
|         |         |   Copy memory usage information to the final     |
|         |         | report tarball                                   |
|         |         |   Copy server uptime to the final report tarball |
|         |         |   Copy current linux distribution to the final   |
|         |         | report tarball                                   |
|         |         |   Copy openSSL information to the final report   |
|         |         | tarball                                          |
|         |         |   Copy network configuration to the final report |
|         |         | tarball                                          |
|         |         | Inspecting kubernetes cluster                    |
|         |         |   Inspect kubernetes cluster                     |
|         |         | Inspecting juju                                  |
|         |         |   Inspect Juju                                   |
|         |         | Inspecting kubeflow                              |
|         |         |   Inspect Kubeflow                               |
|         |         |                                                  |
|         |         | Building the report tarball                      |
|         |         |   Report tarball is at                           |
|         |         | /var/snap/microk8s/2097/inspection-              |
|         |         | report-20210413_194731.tar.gz                    |
| white01 | True    | Inspecting Certificates                          |
|         |         | Inspecting services                              |
|         |         |   Service snap.microk8s.daemon-cluster-agent is  |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-containerd is     |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-apiserver is      |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-apiserver-kicker  |
|         |         | is running                                       |
|         |         |   Service snap.microk8s.daemon-control-plane-    |
|         |         | kicker is running                                |
|         |         |   Service snap.microk8s.daemon-proxy is running  |
|         |         |   Service snap.microk8s.daemon-kubelet is        |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-scheduler is      |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-controller-       |
|         |         | manager is running                               |
|         |         |   Copy service arguments to the final report     |
|         |         | tarball                                          |
|         |         | Inspecting AppArmor configuration                |
|         |         | Gathering system information                     |
|         |         |   Copy processes list to the final report        |
|         |         | tarball                                          |
|         |         |   Copy snap list to the final report tarball     |
|         |         |   Copy VM name (or none) to the final report     |
|         |         | tarball                                          |
|         |         |   Copy disk usage information to the final       |
|         |         | report tarball                                   |
|         |         |   Copy memory usage information to the final     |
|         |         | report tarball                                   |
|         |         |   Copy server uptime to the final report tarball |
|         |         |   Copy current linux distribution to the final   |
|         |         | report tarball                                   |
|         |         |   Copy openSSL information to the final report   |
|         |         | tarball                                          |
|         |         |   Copy network configuration to the final report |
|         |         | tarball                                          |
|         |         | Inspecting kubernetes cluster                    |
|         |         |   Inspect kubernetes cluster                     |
|         |         | Inspecting juju                                  |
|         |         |   Inspect Juju                                   |
|         |         | Inspecting kubeflow                              |
|         |         |   Inspect Kubeflow                               |
|         |         |                                                  |
|         |         | Building the report tarball                      |
|         |         |   Report tarball is at                           |
|         |         | /var/snap/microk8s/2097/inspection-              |
|         |         | report-20210413_194738.tar.gz                    |
| white02 | True    | Inspecting Certificates                          |
|         |         | Inspecting services                              |
|         |         |   Service snap.microk8s.daemon-cluster-agent is  |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-containerd is     |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-apiserver is      |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-apiserver-kicker  |
|         |         | is running                                       |
|         |         |   Service snap.microk8s.daemon-control-plane-    |
|         |         | kicker is running                                |
|         |         |   Service snap.microk8s.daemon-proxy is running  |
|         |         |   Service snap.microk8s.daemon-kubelet is        |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-scheduler is      |
|         |         | running                                          |
|         |         |   Service snap.microk8s.daemon-controller-       |
|         |         | manager is running                               |
|         |         |   Copy service arguments to the final report     |
|         |         | tarball                                          |
|         |         | Inspecting AppArmor configuration                |
|         |         | Gathering system information                     |
|         |         |   Copy processes list to the final report        |
|         |         | tarball                                          |
|         |         |   Copy snap list to the final report tarball     |
|         |         |   Copy VM name (or none) to the final report     |
|         |         | tarball                                          |
|         |         |   Copy disk usage information to the final       |
|         |         | report tarball                                   |
|         |         |   Copy memory usage information to the final     |
|         |         | report tarball                                   |
|         |         |   Copy server uptime to the final report tarball |
|         |         |   Copy current linux distribution to the final   |
|         |         | report tarball                                   |
|         |         |   Copy openSSL information to the final report   |
|         |         | tarball                                          |
|         |         |   Copy network configuration to the final report |
|         |         | tarball                                          |
|         |         | Inspecting kubernetes cluster                    |
|         |         |   Inspect kubernetes cluster                     |
|         |         | Inspecting juju                                  |
|         |         |   Inspect Juju                                   |
|         |         | Inspecting kubeflow                              |
|         |         |   Inspect Kubeflow                               |
|         |         |                                                  |
|         |         | Building the report tarball                      |
|         |         |   Report tarball is at                           |
|         |         | /var/snap/microk8s/2097/inspection-              |
|         |         | report-20210413_194727.tar.gz                    |
+---------+---------+--------------------------------------------------+
```

## 12. Remove a Node from its Cluster

This will remove a node from its cluster and return it to a standalone node 
state.

```
you@yourlaptop:~/cm$ cms pi microk8s remove node white03
pi microk8s remove node white03
INFO: Removing nodes ['white03'] from thier cluster
INFO: This may take a few minutes
+---------+---------+--------------------------------------+
| host    | success | stdout                               |
+---------+---------+--------------------------------------+
| white03 | True    | Generating new cluster certificates. |
|         |         | Waiting for node to start. .         |
+---------+---------+--------------------------------------+
```

At this point you can stop the services or uninstall microk8s if you no 
longer desire this node.

## 13. Uninstall MicroK8s

This will completely remove MicroK8s from the system.

```
you@yourlaptop:~/cm$ cms pi microk8s uninstall white,white0[1-3] 
pi microk8s uninstall white,white0[1-3]
INFO: Uninstalling microk8s on ['white', 'white01', 'white02', 'white03']
INFO: This may take a few minutes
+---------+---------+------------------+
| host    | success | stdout           |
+---------+---------+------------------+
| white   | True    | microk8s removed |
| white01 | True    | microk8s removed |
| white02 | True    | microk8s removed |
| white03 | True    | microk8s removed |
+---------+---------+------------------+
```


       

        
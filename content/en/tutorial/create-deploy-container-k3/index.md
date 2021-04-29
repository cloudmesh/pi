---
date: 2021-04-29
title: "Create and Deploy a Container with Docker and K3s"
linkTitle: "Create and Deploy a Container with Docker and K3s"
description: "This post is walks you through using your pi cluster to create 
and deploy a container on Docker and K3s"
author: Anthony Orlowski([antorlowski@gmail.com](mailto:antorlowski@gmail.com))
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

In this tutorial we will use a cms-burn created cluster to install Docker, 
create a Docker container for the cloudmesh-openapi service, deploy the 
container on Docker, install K3s, deploy the container on K3s, and enable 
access to the container from an external host. 

This is currently (4/29/21) tested on a Raspberry pi using Ubuntu OS.

**Learning Objectives**

* Learn how to install Docker, create a docker container, deploy a docker 
  container, install k3s, deploy a container on K3s, make K3s 
  containers externally accessible.
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## 1. Introduction

Many tutorials walk you through individual components of our learning 
objectives. This tutorial will walk you through step-by-step to create a 
service and deploy it on a cms-brun created cluster.

## 2. Prerequisites

This tutorial assumes a cluster burned using one of the following methods:

[Burn a Raspberry OS Cluster](https://cloudmesh.github.io/pi/tutorial/raspberry-burn/) (not currently tested)

[Burn an Ubuntu Cluster](https://cloudmesh.github.io/pi/tutorial/ubuntu-burn/) (currently tested)

[Use our GUI to Burn a Cluster](https://cloudmesh.github.io/pi/tutorial/gui-burn/)

## 3. Install Docker

Access your cluster manager (red) and get the cloudmesh Docker installer.

```
laptop $ ssh red
red $ cloudmesh-installer get docker-command
```

Now we install Docker.

```
red $ cms docker deploy --host=localhost
```

Let us verify the install by checking the version.

```
red $ sudo Docker version
```

## 4. Create a Dockerfile

We will create a file named `Dockerfile` in a directory 
`cloudmesh-openapi-container`. Substitute your prefered editor if you do not 
like emacs.

```
red $ mkdir cloudmesh-openapi-container
red $ cd cloudmesh-openapi-container
red $ emacs Dockerfile
```

In `Dockerfile` add the following lines. This provides Docker the commands 
needed to install [cloudmesh-openapi](https://cloudmesh.github.io/pi/tutorial/analytics-services/) 
and the needed packages for our PipleLineAnovaSVM example into a Ubuntu 
container.
```
# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN mkdir cm
RUN apt update
RUN apt install python3-venv python3-wheel python3-dev python3-pip build-essential -y
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install pip -U
RUN pip install cloudmesh-installer
RUN apt install git -y
RUN cd cm; cloudmesh-installer get openapi
RUN pip install sklearn pandas
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Indiana/Indianapolis
RUN apt install tzdata -y
RUN apt install emacs -y
CMD /bin/bash
```

## 5. Build a Docker Image

Now we build an image based on the instructions provided in `Dockerfile`. We 
name the image `cloudmesh-openapi`. The `.` instructs Docker to use the 
Dockerfile in the present working directory.

```
red $ sudo docker build -t cloudmesh-openapi .
```

## 6. Start a Docker Container

Now we start a Docker containe using our `cloudmesh-openapi` image. The 
`-it` provide an interactive terminal, the `-p` maps the container port 8080 
to the host port 8080, and `/bin/bash` is the command to run in the container.

```
red $ sudo docker run -it -p 8080:8080 cloudmesh-openapi /bin/bash
```

## 7. Generate and Start the Cloudmesh-Openapi PipelineAnovaSVM Service

Generate the service yaml.

```
container $ cms openapi generate PipelineAnovaSVM \
    --filename=./tests/Scikitlearn-experimental/sklearn_svm.py \
    --import_class \
    --enable_upload
```

Start the service (defaults to port 8080). Leave this running and go to a 
new terminal.

```
container $ cms openapi server start ./tests/Scikitlearn-experimental/sklearn_svm.yaml --host=0.0.0.0
```

## 8. Interact with the Running Service

In another terminal on your laptop you can now access the service from 
`red.local:8080` because we mapped the container port 8080 to the host port 8080.

In a web browser go to `http://red.local:8080/cloudmesh/ui` to access the 
web UI of the service.

Alternatively, you can access the service directly from the command line of 
your laptop.

```
laptop $ curl -L -o iris.data "https://raw.githubusercontent.com/cloudmesh/cloudmesh-openapi/main/tests/Scikitlearn-experimental/iris.data"

laptop$ export CMSIP=red.local:8080

laptop$ curl -X POST "http://$CMSIP/cloudmesh/upload" -H  "accept: text/plain" -H  "Content-Type: multipart/form-data" -F "upload=@iris.data"

laptop$ curl -X GET "http://$CMSIP/cloudmesh/PipelineAnovaSVM/train?filename=iris.data" -H  "accept: text/plain"

laptop$ curl -X GET "http://$CMSIP/cloudmesh/PipelineAnovaSVM/make_prediction?model_name=iris&params=5.1%2C%203.5%2C%201.4%2C%200.2" -H  "accept: */*"
```

You can now `ctrl-C` and `exit` the running container to stop the service.

## 9. Save a Docker Image

We need to save the Docker image so we can provide it to our K3s cluster. 
alternatively you can upload it to a Docker registry like DockerHub.

We save our image in a tarfile named `cloudmesh-openapi.tar`.

```
red $ sudo docker save --output cloudmesh-openapi.tar cloudmesh-openapi:latest
```

We will reference this file later to import it to our K3s cluster.


## 10. Install K3s on our Pi Cluster

Enable containers in the kernel, and wait for the cluster to reboot.

```
laptop $ cms pi k3 enable containers red,red[01-03]
```

Now install K3s

```
laptop $ cms pi k3 install cluster red,red0[1-3]
```

Verify all nodes show up.

```
laptop $ cms pi k3 cluster info
```

## 11. Import the `cloudmesh-openapi` Image into All K3s Nodes

As we are not using an image repository, we need to copy our 
`cloudmesh-openapi.tar` file to all k3s nodes.

```
red $ sudo scp -i ~/.ssh/id_rsa cloudmesh-openapi.tar  ubuntu@red01:/home/ubuntu/cloudmesh-openapi-container/
red $ sudo scp -i ~/.ssh/id_rsa cloudmesh-openapi.tar  ubuntu@red02:/home/ubuntu/cloudmesh-openapi-container/
red $ sudo scp -i ~/.ssh/id_rsa cloudmesh-openapi.tar  ubuntu@red03:/home/ubuntu/cloudmesh-openapi-container/
```

Now we import the image into K3s.

```
red $ sudo k3s ctr images import ~/cloudmesh-openapi-container/cloudmesh-openapi.tar
red01 $ sudo k3s ctr images import ~/cloudmesh-openapi-container/cloudmesh-openapi.tar
red02 $ sudo k3s ctr images import ~/cloudmesh-openapi-container/cloudmesh-openapi.tar
red03 $ sudo k3s ctr images import ~/cloudmesh-openapi-container/cloudmesh-openapi.tar
```

Validate the container is present.

```
red $ sudo k3s ctr images list 
```

## 12. Create a Kubernetes Pod Manifest YAML

To create Pod in Kubernetes, you need to define a YAML file. We create one 
named `cloudmesh-openapi-pod.yaml`. The pod is the smallest deployable unit 
of computing in K8s, and is a group of one or more containers. In our case one.

Create `cloudmesh-openapi-pod.yaml` and paste the following lines in the 
document. 

```
apiVersion: v1
kind: Pod
metadata:
  name: cloudmesh-openapi-pod
  labels:
    app: cloudmesh-openapi-pod
spec:
  containers:
  - name: cloudmesh-openapi
    image: cloudmesh-openapi:latest
    imagePullPolicy: Never
    command:
      - "sleep"
      - "604800"
```

This will define a pod named `cloudmesh-openapi-pod`, containing 
one container named `cloudmesh-openapi` based on our 
`cloudmesh-openapi:latest` image, running the command `sleep 604800`. This 
will essentially keep our container running for 7 days and then it will 
close and restart based on the default restart policy: ALWAYS. The `.
metadata.label.app` is important as it allows us to select our pod in our 
in our following load-balancer service. The `.spec.imagePullPolicy: Never` 
is also important as it prevents K8s from trying to download our image from 
any repository and instead use the local copy. 

## 13. Deploy a Pod

Deploy your pod by applying the `cloudmesh-openapi-pod.yaml` configuration.

```
red $ sudo kubectl apply -f ./cloudmesh-openapi-pod.yaml
```

Check that the pod is running.

```
red $ sudo kubectl get pods
```

## 14. Start a Shell in the Pod

We need to start a shell in our Pod so we can generate and run the 
cloudmesh-openapi service.

```
red $ sudo kubectl exec --stdin --tty cloudmesh-openapi-pod -- /bin/bash
```

We can now run our serice generate and start command.

```
container $ cms openapi generate PipelineAnovaSVM \
    --filename=./tests/Scikitlearn-experimental/sklearn_svm.py \
    --import_class \
    --enable_upload
```

```
container $ cms openapi server start ./tests/Scikitlearn-experimental/sklearn_svm.yaml --host=0.0.0.0
```
You can now `exit` and the container and the service will continue running.

## 15. Create a Kubernetes Service Manifest to Start a K3s Load-Balancer

Kubernetes services expose your cluster Pods to external networks. K3s comes 
with a build int load balancer that watches for Kubernetes LoadBalancer
services, and then deploys the necessary network infrastructure to make your 
service accessible.

Create a file names `cloudmesh-openapi-lb-service.yaml` and paste the 
following lines.

```
apiVersion: v1
kind: Service
metadata:
  name: cloudmesh-openapi-lb-service
spec:
  selector:
    app: cloudmesh-openapi-pod
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 30000
  type: LoadBalancer
```

It is important that the `.spec.selector.app` matches that defined in your 
pod yaml. The `port` is the port accessible on cluster internal nodes, the 
`targetPort` is the port in the container to which traffic will be forwarded,
and the `nodePort` is the port on cluster external networks can access the 
service. This must match a predefined range.

## 16. Deploy the LoadBalancer Service

Deploy the loadbalancer.

```
red $ sudo kubectl apply -f ./cloudmesh-openapi-lb.service.yaml
```

Check to ensure it deployed.

```
red $ sudo kubectl get services -o wide
```

Check to see the load balancer pods are deployed on all agent nodes.

```
red $ sudo kubectl get pods
```

## 17. Interact with the `cloudmesh-openapi` Pod

Because the loadbalancer is running on all nodes and forwarding traffic to 
the existing pod, we can now reach our service from our laptop at `red.local:30000`. For some 
reason `red.local:8080` works as well, I can't explain that yet.

On your laptop web browser browse to `http://red.local:30000/cloudmesh/ui`

Alternatively, interact with the service from the command line.

```
laptop $ curl -L -o iris.data "https://raw.githubusercontent.com/cloudmesh/cloudmesh-openapi/main/tests/Scikitlearn-experimental/iris.data"

laptop$ export CMSIP=red.local:30000

laptop$ curl -X POST "http://$CMSIP/cloudmesh/upload" -H  "accept: text/plain" -H  "Content-Type: multipart/form-data" -F "upload=@iris.data"

laptop$ curl -X GET "http://$CMSIP/cloudmesh/PipelineAnovaSVM/train?filename=iris.data" -H  "accept: text/plain"

laptop$ curl -X GET "http://$CMSIP/cloudmesh/PipelineAnovaSVM/make_prediction?model_name=iris&params=5.1%2C%203.5%2C%201.4%2C%200.2" -H  "accept: */*"
```

## 18. Commands Useful for Debugging

Useful `kubectl` commands to debug a broken pod/service

```
sudo kubectl describe pod cloudmesh-openapi-pod
sudo kubectl logs --previous cloudmesh-openapi-pod cloudmesh-openapi
sudo kubectl logs cloudmesh-openapi-pod cloudmesh-openapi
sudo kubectl delete pod cloudmesh-openapi-pod
sudo kubectl delete service clodmesh-openapi-lb-service
sudo kubectl get pods --show-labels
sudo kubectl edit pod cloudmesh-openapi-pod
```

If you have trouble accessing the pod shell, like below. Try stopping and 
restarting the K3s services.

```
(ENV3) ubuntu@red:~/cloudmesh-openapi-container$ sudo kubectl exec --stdin --tty cloudmesh-openapi-pod -- /bin/bash
error: unable to upgrade connection: Authorization error (user=kube-apiserver, verb=create, resource=nodes, subresource=proxy)
```

Stop and restart the K3s services.

```
red $ cms pi k3 stop agent red,red0[1-3]
red $ cms pi k3 stop server red
red $ cms pi k3 start server red
ree $ cms pi k3 start agent red,red0[1-3]
```


## 19. Uninstall K3s

```
laptop $ cms pi k3 uninstall cluster red,red0[1-3]
```

## 20. Unistall Docker

```
red $ sudo apt-get purge docker-ce docker-ce-cli containerd.io
red $ sudo rm -rf /var/lib/docker
red $ sudo rm -rf /var/lib/containerd
```


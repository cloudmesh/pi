---
date: 2021-02-07
title: "Introduction to Docker"
linkTitle: "Introduction to Docker"
description: "This post will cover Docker basics and commands"
author: Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
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

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your 
applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker’s methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

## Hypervisor vs container-based virtualization

* Hypervisor – As seen in figure 1, there are limitations with hypervisor - Kernel Resource Duplication and Application Portability Issue
* Container – As seen in figure 2, container based virtualization is cost efficient, fast deployment and guaranteed portability.

![Figure 1](https://github.com/cloudmesh/pi/blob/main/content/en/tutorial/docker-pi/Figure1.png)

![Figure 2](https://github.com/cloudmesh/pi/blob/main/content/en/tutorial/docker-pi/Figure2.png)
## Docker architecture

Docker uses a client-server architecture. The Docker client talks to the Docker daemon, which does the heavy lifting of building, running, and distributing your Docker containers. The Docker client and daemon can run on the same system or connect a Docker client to a remote Docker daemon. The Docker client and daemon communicate using a REST API, over UNIX sockets, or a network interface. Another Docker client is Docker Compose, which lets you work with applications consisting of a set of containers.

![Figure3](https://github.com/cloudmesh/pi/blob/main/content/en/tutorial/docker-pi/Figure3.png)
## Docker objects

### Images

* Images are read-only templates used to create containers. 
* Images are created with the docker build command, either by us or by other docker users. 
* Images are composed of layers of other images. 
* Images are stored in a Docker registry.

### Containers


* If an image is a class, then a container is an instance of a  class - a runtime object.
* Containers are lightweight and portable encapsulations of an environment in which to run applications.
* Containers are created from images. Inside a container, it has all the binaries and dependencies needed to run the application.


### Registries and Repositories

* A registry is where we store our images.
* You can host your own registry, or you can use Docker’s public registry which is called DockerHub.
* Inside a registry, images are stored in repositories.
* Docker repository is a collection of different docker images  with the same name, that have different tags, each tag  usually represents a different version of the image.


## Two ways to build docker images

### Commit changes made in a Docker container
Docker commit command would save the changes we made to the Docker container’s file system to a new image
```
   docker commit container_ID repository_name:tag
```


### Write a Dockerfile
 A Dockerfile is a text document that contains all the instructions users provide to assemble an image.
 Each instruction will create a new image layer to the image.
 Instructions specify what to do when building the image.

## Docker Build Context

Docker build command takes the path to the build context as an argument.
When build starts, docker client would pack all the files in the build context into a tarball then transfer the tarball file to the daemon. By default, docker would search for the Dockerfile in the build context path.

## Docker Compose


Docker compose is a very handy tool to quickly get docker environment up and running.

Docker compose uses yaml files to store the configuration of all the containers, which removes the burden to maintain  our scripts for docker orchestration

* docker compose up starts up all the containers. 
* docker compose ps checks the status of the containers managed by docker compose. 
* docker compose logs outputs colored and aggregated logs for the compose-managed 
containers. 
* docker compose logs with dash f option outputs appended log when the log grows. 
* docker compose logs with the container name in the end outputs the logs of a specific 
container. 
* docker compose stop stops all the running containers without removing them. 
* docker compose rm removes all the containers. 
* docker compose build rebuilds all the images.

## Docker Network Types

* Closed Network / None Network	
* Bridge Network
* Host Network
* Overlay Network

## Orchestration


The portability and reproducibility of a containerized process mean we have an opportunity to move and scale our containerized applications across clouds and data centers. Containers effectively guarantee that those applications run the same way anywhere, allowing us to quickly and easily take advantage of all these environments. Furthermore, as we scale our applications up, we’ll want some tooling to automate the maintenance of those applications, replace failed containers automatically, and manage the rollout of updates and reconfigurations of those containers during their lifecycle.
Tools to manage, scale, and maintain containerized applications are called orchestrators, and the most common examples of these are Kubernetes and Docker Swarm. 


## Docker Swarm

* To deploy your application to a swarm, you submit your service to a manager node. 
* The manager node dispatches units of work called tasks to worker nodes. 
* Manager nodes also perform the orchestration and cluster management functions required to maintain the desired state of the swarm.
* Worker nodes receive and execute tasks dispatched from manager nodes. 
* An agent runs on each worker node and reports on the tasks assigned to it. The worker node notifies the manager node of the current state of its assigned tasks so that the manager can maintain the desired state of each worker.


## Reference

[^docker]: Docker website, <https://docs.docker.com/get-started/overview/>
[^training]: Online Level-up training, <https://www.level-up.one/courses/>



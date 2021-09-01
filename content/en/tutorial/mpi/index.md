---
date: 2021-09-01
title: "Deploy MPI for Python (mpi4py) on your Pi Cluster"
linkTitle: "Deploy MPI for Python (mpi4py) on your Pi Cluster"
description: "Take advantage of parallel communication on your cluster"
author: Anthony Orlowski ([antorlowski@gmail.com](mailto:antorlowski@gmail.com))
draft: False
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" >}}
{{< /imgproc >}}


{{% pageinfo %}}

In this tutorial we will deploy and demonstrate MPI for use across a cluster of Raspberry Pis. The Pis can run Ubuntu or Raspberry OS.

**Learning Objectives**

* Learn how to install and try MPI on a cluster of raspberry pis
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## 1. Introduction

Modern AI and Deep Learning algorithms require immense processing power to churn through big data. In this tutorial we show how to install and try out MPI on a cluster of Raspberry Pis. MPI gives developers access to a powerful set of parallel processing, synchronization, and communication tools to develop thier algorithms in a scalable manner on clustesr. mpi4py gives developers access to MPI from Python allowing easy integration into Python applications.

## 2. Prerequisites 

This tutorial assumes a cluster burned using one of the following methods:

[Burn a Raspberry OS Cluster](https://cloudmesh.github.io/pi/tutorial/raspberry-burn/)

[Burn an Ubuntu Cluster](https://cloudmesh.github.io/pi/tutorial/ubuntu-burn/)

[Use our GUI to Burn a Cluster](https://cloudmesh.github.io/pi/tutorial/gui-burn/)

The tutorial supports both Raspberry OS and Ubuntu.

## 3. CMS MPI Commands 

Below are the MPI commands available from CMS

```
 mpi deploy raspberry HOSTS
 mpi deploy ubuntu HOSTS
 mpi uninstall raspberry HOSTS
 mpi uninstall ubuntu HOSTS
```

## 4. Install MPI

We can install MPI on a cluster of Pis using the following command. The installation is done in parallel to scale with the number of hosts. Make sure to choose the argument that corresponds to the OS installed on the Raspberry Pis. In this example we will demonstrate the installation on a cluster of Pis running Raspberry OS.

Required python packages are installed, followed by MPI and mpi4py, and then the version of MPI installed is checked.

A return code of 0 indicates command success, any other indicates a failure.

```
(ENV3) you@yourlaptop:~ $ cms mpi deploy raspberry "red,red0[1-3]"
mpi deploy raspberry red,red0[1-3]

# ----------------------------------------------------------------------
# Install MPI on hosts
# ----------------------------------------------------------------------

INFO: Installing essential python packages
INFO: sudo apt-get install python3-venv python3-wheel python3-dev build-essential python3-pip -y; pip3 install pip -U; python3 -m venv ~/ENV3
+-------+------------+--------+
| host  | returncode | stderr |
+-------+------------+--------+
| red   | 0          |        |
| red01 | 0          |        |
| red02 | 0          |        |
| red03 | 0          |        |
+-------+------------+--------+
INFO: Installing mpi on hosts
INFO: sudo apt-get install openmpi-bin -y; source ~/ENV3/bin/activate; pip3 install mpi4py
+-------+------------+--------+
| host  | returncode | stderr |
+-------+------------+--------+
| red   | 0          |        |
| red01 | 0          |        |
| red02 | 0          |        |
| red03 | 0          |        |
+-------+------------+--------+
INFO: Checking version of mpi on hosts
INFO: mpicc --showme:version
+-------+------------+--------+-------------------------------------+
| host  | returncode | stderr | stdout                              |
+-------+------------+--------+-------------------------------------+
| red   | 0          |        | mpicc: Open MPI 3.1.3 (Language: C) |
| red01 | 0          |        | mpicc: Open MPI 3.1.3 (Language: C) |
| red02 | 0          |        | mpicc: Open MPI 3.1.3 (Language: C) |
| red03 | 0          |        | mpicc: Open MPI 3.1.3 (Language: C) |
+-------+------------+--------+-------------------------------------+

```

## 5. Tryout MPI on a Single Host

To test MPI functionality on a single host you can run the following command to run 4 processes on a single Pi.

```
(ENV3) pi@red:~ $ mpiexec -n 4 python3 -m mpi4py.bench helloworld
Hello, World! I am process 0 of 4 on red.
Hello, World! I am process 1 of 4 on red.
Hello, World! I am process 2 of 4 on red.
Hello, World! I am process 3 of 4 on red.
```

## 6. Tryout MPI on a Cluster

To test MPI functionality on a cluster you can run the following command.

```
(ENV3) pi@red:~ $ mpiexec -n 4 -host red,red01,red02,red03 python3 -m mpi4py.bench helloworld
Hello, World! I am process 0 of 3 on red.
Hello, World! I am process 1 of 3 on red01.
Hello, World! I am process 2 of 3 on red02.
Hello, World! I am process 2 of 3 on red03.
```

**However, this will only run one process per host.** A raspberry Pi 4 has 4 vprocessors. We can make a machine file to declare this information and then use `mpirun` and the `machinefile` to use all available processors.

Create a file named `machinefile` with the following content.

```
pi@red slots=4
pi@red01 slots=4
pi@red02 slots=4
pi@red03 slots=4
```

Now we can run the same helloworld example while using all available processors.

```
(ENV3) pi@red:~ $ mpirun -np 12 -machinefile ./machinefile python3 -m mpi4py.bench helloworld
Hello, World! I am process  0 of 16 on red.
Hello, World! I am process  1 of 16 on red.
Hello, World! I am process  2 of 16 on red.
Hello, World! I am process  3 of 16 on red.
Hello, World! I am process  4 of 16 on red01.
Hello, World! I am process  6 of 16 on red01.
Hello, World! I am process  5 of 16 on red01.
Hello, World! I am process  7 of 16 on red01.
Hello, World! I am process  8 of 16 on red02.
Hello, World! I am process  9 of 16 on red02.
Hello, World! I am process 10 of 16 on red02.
Hello, World! I am process 11 of 16 on red02.
Hello, World! I am process 12 of 16 on red03.
Hello, World! I am process 13 of 16 on red03.
Hello, World! I am process 14 of 16 on red03.
Hello, World! I am process 15 of 16 on red03.
```

## 7. Uninstall MPI

You can unistall MPI in the following manner.

```
(ENV3) you@yourlaptop:~ $ cms mpi uninstall ubuntu "red,red0[1-3]"
mpi uninstall ubuntu red,red0[1-3]

# ----------------------------------------------------------------------
# Uninstall MPI on hosts
# ----------------------------------------------------------------------

INFO: Uninstalling mpi on hosts
INFO: sudo apt-get --purge remove mpich-doc mpich -y; source ~/ENV3/bin/activate; pip3 uninstall mpi4py -y
+-------+------------+--------+
| host  | returncode | stderr |
+-------+------------+--------+
| red   | 0          |        |
| red01 | 0          |        |
| red02 | 0          |        |
| red03 | 0          |        |
+-------+------------+--------+
```

## 8. Learn More

To learn more about MPI4PY, including examples of communication mechanisms, please see this [report](https://cloudmesh.github.io/cloudmesh-mpi/report-mpi.pdf).
---
title: "Fortan"
date: 2017-01-05
description: >
  In case you like to experiment with FORTRAN, you can install and use it.
---


{{% pageinfo %}}

**Learning Objective**

Python is in scientific computing still used. It is easy to set up on a Pi 
so you can experiment with it.

* Set op Fortan
* Run it on your PI
  
**Topics Covered**

{{< table_of_contents >}}

{{% /pageinfo %}}

You may find still that many scientific programs are written in fortran. 
For some smaller fortran programs it is even possible to run them on a
Raspberry pi. 

## Installation

Naturally you will need to install a fortran compiler,
which you can do with

```bash
pi$ sudo apt-get install gfortran
```

## Example

To test it out store the following program into `hello.f90`

```fortran
program hello
    print *, "Hello World!"
end program hello
```

Now you can compile it with

```bash
pi$ gfortran -o hello hello.f90
```

Execute it with

```
pi$ hello
```

---
date: 2021-02-07
title: "Cms Commands"
linkTitle: "Cms Commands"
description: "How to ad dnew commands to cloudmesh."
author: Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: True
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{< imgproc image Fill "600x300" >}}
Cloudmesh Commands
{{< /imgproc >}}


{{% pageinfo %}}

We explain how to very quickly add new commands to cloudmesh

**Learning Objectives**

* Learn how to quickly add new commands to cloudmesh
* Learn how to modify the commands for your liking
* Understand how we use docopts for manual page generation
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## Introduction

Cloudmesh offers an easy-to-use command line and shell interface using a library
called `cloudmesh-cmd5`. Cmd5 installs a program called Cloudmesh Shell or
`cms` when called in a terminal. Cludmesh can be installed either directly from pip of developers can install it via the cloudmesh-installer that also downloads the source. The installations are discussed in detail in the Cloudmesh Manual.

In any case, we recommend you use a venv to assure that you d not by accident
destroy your system-wide python installation. We always use the environment
`~/ENV3` to have all tutorials uniform and to simplify them. If you do not yet have one create it as follows.

### Check if you have a good version of python

We recommend installing a 64-bit version of python directly from python.org.
Anaconda is also possible, but we do not use anaconda much as it has many
unnecessary packages and thus is not ideal for cloud-based research. It is
always better to assemble just the libraries that you really need.


```
python --version
# on some systems you need to use python3 or python3.9
```

For convenience, we assume your system uses python3.9. Now create the venv with

```bash
$ python3.9 -m venv ~/ENV3
$ source ~/ENV3/bin/activate
$ pip install pip -U
```

To install Cloudmesh shell from PyPI you can say 

```bash
$ pip install cloudmesh-cms
```

To install it with source say

```bash
$ mkdir ~/cm
$ cd ~/cm
$ pip install cloudmesh-installer
$ cloudmesh-installer get cms
$ cmas help
```

### Creating new commands

Now you have everything that you need to install new commands. The important
feature that cloudmesh includes is that it uses python namespaces. This makes
it possible to develop your own command in separate directories and store them
in GitHub in your own repositories.

To create a command we simply create a new directory for it and populate it
with a template by calling the command generation command in cloudmesh. For
simplicity, we name the directory `cloudmesh-gregor` but you can name it the way
you like it. We intend to create a command called gergor

```
mkdir -p ~/cm/cloudmesh-gregor
cd ~/cm/cloudmesh-gregor
cms sys command generate gregor .
pip install -e .
cms help
```

Yes, this is it, you have now generated a new command `gregor` that you can see listed in the commands. Try it out with 

```
cms gregor
```

### Modifying the command

To change the source, go to the file

```bash
emacs ~/cm/cloudmesh-gregor/cloudmesh/gregor/command/gregor.py
```

There you will see a comment as part of the command using docopts. We chose
docopts for our command generation as it allows us to design the documentation
first before we implement it. Docopts will take this docstring and generate a
dictionary that we can inspect and use in if conditions. We have significantly
enhanced the cms tool from python to more conveniently program new commands. 
For example, we  use a `dotdict`
implementation allowing us to say

`arguments.FILE` instead of `argunemnts["FILE"]`

This has two limitations

1. you can not use build-in names such as `format`, `list`, and so on. In this case, you still have to use `arguments["format"]` as `.format` in python has a
   very special meaning.

2. in case a parameter is passed as an option with `--option` or `--option2=OPTION2`
   you can obviously not use `arguments.--option`
   For you to use `arguments.option` we introduced a function called
   Parameter 
   
   ```python
   from cloudmesh.shell.command import command, map_parameters
   
   map_parameters(arguments,
                  "option",
                  "option2")
   ```

   that maps the ``--`` preceded options simply into the arguments dictionary
   without the `--`.
   

### Accessing Variables

Cloudmesh has also a build-in mechanism to store and use cms variables. YOu can
see them while using the command

```python
$ cms set
```

These are variables that you can use to for example initialize options not
just form the command line, but through preset values you yous yourself.

Let us assume you like to preset the FILE to the value `
~/cm/cloudmesh-gregor/README.md`

you can do this with 

```python
cms set FILE=~/cm/cloudmesh-gregor/README.md`
```

Now you can enhance your program by checking if the variable exists and use
it. This has the advantage that the implementation is slightly more dynamic
than using the `[default: value]` option from cloudmesh and allows to use of a
shared state of the variable between invocations.

We simply add the following just after the map parameters function

```python
variables = Variables()

arguments.output = Parameter.find(
    "FILE",
    arguments,
    variables,
    "~/cm/cloudmesh-gregor/README.md")
```

The order in the `find` is done sequentially. First, we look if arguments.FILE
is defined by the command, then we look if it is in the variables, then we set a 
default value. The default value is simply last.

### Debugging dicts and variables

We also included a simple debug function that prints the content of dicts as
well as the filename and the line number in the program.


YOu can use it for displaying the contents of the arguments so you can see how
to best crate if conditions that react to their state. Please be reminded that
the order in the if conditions are relevant t write your command. Assure your
`arguments` setting does not fire the specific rule you intend
to use.

```python
from cloudmesh.common.debug import VERBOSE

VERBOSE(arguments)
```

YOU can use VERBOSE with any variable, but it works best with one dicts having
a single layer such as `arguments` or `variables`.

## References

1. CLoudmesh manual
2. cms sys
3. `from cloudmesh.shell.command import command, map_parameters`
3. `from cloudmesh.common.debug import VERBOSE`

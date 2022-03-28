---
date: 2021-02-07
title: "Broken"
linkTitle: "Broken"
description: "TBD."
author: Richard Otten, Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: True
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---



{{% pageinfo %}}

TBD

**Learning Objectives**

* Learn how to ...
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

## Introduction

Flask is a python web application framework which is easy to get started with & capable of handling complex applications. Brief details on Flask can be found [here][].

[here]: "https://pythonbasics.org/what-is-flask-python/"

## Installation

Instructions in this tutorial are from the official Flask [installation guide][]. This tutorial assumes you have Python 3 available, but details on setup using Python 2 can be found inn the official guide. 

[installation guide]: "https://flask.palletsprojects.com/en/1.1.x/installation/"

To begin work with Flask, create a project directory and set up a virtual environment for dependencies:

```
$ mkdir myproject
$ cd myproject
$ python3 -m venv venv
```

Now, start the virtual environment and install Flask:

``` 
$ . venv/bin/activate 
$ pip install Flask
```

You are now ready to go! 

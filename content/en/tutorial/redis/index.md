---
date: 2021-02-07
title: "Broken"
linkTitle: "Broken A"
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

Redis is an **[In-Memory Database][]** & key-value store often used for caching. It is known for its exceptionally fast read-write operations (100,000/second) in memory. It can be used as an alternative to [YAMLDB][] in our implementation. 

[In-Memory Database]: "https://medium.com/@denisanikin/what-an-in-memory-database-is-and-how-it-persists-data-efficiently-f43868cff4c1"

[YAMLDB]: "https://github.com/cloudmesh/yamldb"

## Installation

Installation & setup instructions are taken from the [Redis Quickstart][] webpage.
[Redis QuickStart]: "https://redis.io/topics/quickstart"

To install the latest available version of Redis, enter the following commands in your Pi terminal:

```
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
```
After these commands have finished executing, enter the following command to check if the build has worked correctly:

```
$ make test
```
## Setup & Testing

Set up PATH environment variables for the server and command line interface with the following commands:

```
$ sudo cp src/redis-server /usr/local/bin/  
$ sudo cp src/redis-server /usr/local/bin/
```  

Start an instance of the Redis server:  
```
$ redis-server
```

As a default this should run on port 6739. Send a command through the Redis command line interface to the running instance to make sure it is working properly. Enter the following:  
 
```
$ redis-cli ping
```  
Expect the response ```PONG```

## Brief Examples
An official introduction to Redis commands is given in Redis's [Introduction to Data Types][] article.

[Introduction to Data Types]: "https://redis.io/topics/data-types-intro"

Try out the following examples in Redis CLI's *interactive mode* by typing in ```redis-cli``` without any commands or arguments. 

### Databases

Redis databases are referred to using integer indices (Ex. database "0", database "1", etc). By default, a Redis instance contains 16 databases, and is set to database 0 when first accessed by a client. 

Use the ```SELECT``` command followed by the index of the database to switch between databases. 

Try entering  

```$ SELECT 3``` 

This will switch the current database to database 3. 

Use the ```FLUSHDB``` to erase all key-value pairs from a database.

### Keys

Set and get key-value pairs in a Redis database using the ```GET``` and ```SET``` commands. Try the following example: 

``` $ SET color blue```  

This should return ```OK``` to indicate the creation was successful. Now, enter:

``` $ GET color```

This should return ```blue```

Now try: 

```$ FLUSHDB```  

followed by  

```$ GET color```  

The key-value pair should no longer be in the database, and you should see a return value of ```(nil)```











---
title: "Perl One Liners"
linkTitle: "Perl One Liners"
description: >
    Manipulating files with convenient perl one line commands.
---


{{% pageinfo %}}
**Learning Objectives**

* Familiarize yourself with manipulating files by using Perl one line commands.

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

Perl is a programming language that used to be very popular with system
administrators. It predates Python. It has some very powerful regular
expression abilities allowing you to easily do things on the commandline
that woul otherwise thake many hours. Here ar some useful perl one line
commands.

## Strip trailing whitespace from a file

```bash
$ perl -lpe 's/\s*$//' FILENAME
```

## Replace wrong quote

```bash
$ perl -i -p -e "s/’/'/g;"  *.md
```

## Remove `^M` from file

```bash
$ perl -p -i -e 's/\r\n$/\n/g'
```

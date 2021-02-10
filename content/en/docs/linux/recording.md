---
title: "Recordings"
linkTitle: "Recordings"
description: >
  Sometimes it is useful to develop tutorials that showcase typed in actions on
  a terminal. We show you how to record with various tools.
---


{{% pageinfo %}}
**Learning Objectives**

* Learn how to record your terminal sessions.
* Learn how to take screenshots.
* Do not use screenshots when filing bugs.

**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

In Linux and OSX it is possible to easly record and replay a terminal session.
There are several programs that can do this. A good overview article about it is given at

* <https://linoxide.com/linux-how-to/linux-terminal-recording-tools/>

From these programs we have tried

* script, which is preinstalled and you do not have it immediatly available
* TermRecord that also depends on ttyrec, so you need to install this as well


## TermRecord

### OSX

```bash
$ brew install ttyrec
$ pip install TermRecord
```

To use it simply invoke

```bash
$ TermRecord -o recording.html
```

To replay open the html page in a browser. Befor eyou publish it for example in
the docs folder in a github repository, please make sure you have not exposed
any information that allows others to compromise your system.

In case you use chrome you can replay it also from the commandline with

```bash
$ google-chrome /tmp/test.html
```

## Screencapture

On macOS you can use the screen capture command use

```OSX SHIT-COMMAND - 4 Screen capture```

or say on the commandline 

```
$ screencapture a.gif
```

## Do not use screenshots when filing bugs

In general it is a bad practice to use screenshots whne filing bugs. The reason
is that they can not easily parsed or content can be copied to replicate the bug.
Thus avoid using screenshots when using for example github issues if you can.

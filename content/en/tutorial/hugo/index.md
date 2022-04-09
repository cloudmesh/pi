---
date: 2022-04-03
title: "Hugo Pages"
linkTitle: "Hugo Pages"
description: "A collection of advanced features supported by this hugo instance"
author: Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io), Venkata (DK) Kolli [github.com/dkkolli](https://github.com/dkkolli)
draft: False
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc image Fill "600x300" />}}

{{% pageinfo %}}

Here comes a small abstract

**Learning Objectives**

* here comes a list of learning objectives
* 
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## Documentation GUI components

{{< notice warning >}}
This is a warning notice. Be warned!
{{< /notice >}}


{{< notice tip >}}
This is a very good tip.
{{< /notice >}}

{{< notice note >}}
This is a very good tip.
{{< /notice >}}

{{< notice info >}}
This is a very good tip.
{{< /notice >}}


{{< terminal-gitbash "gregor@gitbash" "~/ (gitbash)" >}}
$ cms
+-------------------------------------------------------+
|   ____ _                 _                     _      |
|  / ___| | ___  _   _  __| |_ __ ___   ___  ___| |__   |
| | |   | |/ _ \| | | |/ _` | '_ ` _ \ / _ \/ __| '_ \  |
| | |___| | (_) | |_| | (_| | | | | | |  __/\__ \ | | | |
|  \____|_|\___/ \__,_|\__,_|_| |_| |_|\___||___/_| |_| |
+-------------------------------------------------------+
|                  Cloudmesh CMD5 Shell                 |
+-------------------------------------------------------+
$ _
{{< /terminal-gitbash >}}


{{< terminal-macos "gregor@macOS" "~/ (zsh)" >}}
$ cms
+-------------------------------------------------------+
|   ____ _                 _                     _      |
|  / ___| | ___  _   _  __| |_ __ ___   ___  ___| |__   |
| | |   | |/ _ \| | | |/ _` | '_ ` _ \ / _ \/ __| '_ \  |
| | |___| | (_) | |_| | (_| | | | | | |  __/\__ \ | | | |
|  \____|_|\___/ \__,_|\__,_|_| |_| |_|\___||___/_| |_| |
+-------------------------------------------------------+
|                  Cloudmesh CMD5 Shell                 |
+-------------------------------------------------------+
$ _
{{< /terminal-macos >}}

{{< terminal-ubuntu "gregor@ubuntu" "~/ (bash)" >}}
$ cms
+-------------------------------------------------------+
|   ____ _                 _                     _      |
|  / ___| | ___  _   _  __| |_ __ ___   ___  ___| |__   |
| | |   | |/ _ \| | | |/ _` | '_ ` _ \ / _ \/ __| '_ \  |
| | |___| | (_) | |_| | (_| | | | | | |  __/\__ \ | | | |
|  \____|_|\___/ \__,_|\__,_|_| |_| |_|\___||___/_| |_| |
+-------------------------------------------------------+
|                  Cloudmesh CMD5 Shell                 |
+-------------------------------------------------------+
$ _
{{< /terminal-ubuntu >}}



## 1. Introduction

Sections should be umbered

## 2. Tabs


{{< tabs tabTotal="2" tabLeftAlign="2">}}
{{< tab tabName="macOS/Linux/Raspberry" >}}

This program is typically already running on macOS and Ubuntu, so 
you do not have to invoke it separately. Hence a simple add will do.

```bash {linenos=table, linenostart=22}
(ENV3) you@yourlaptop $ ssh-add
```

{{< /tab >}}
{{< tab tabName="Windows" >}}

On windows, you have to start the agent first so that ssh-add can be
used while typing in the gitbash terminal:

```bash {linenos=table, linenostart=22}
(ENV3) you@yourlaptop $ eval `ssh-agent`
(ENV3) you@yourlaptop $ ssh-add
```

These two commands will start the ssh-agent and add your key to it so
it is cached for future use within the same gitbash terminal.

{{< /tab >}}
{{< /tabs >}}

## Table

| Firstname | Lastname           |
|-----------|--------------------|
| Gregor    | von Laszewski      |


## Expand

<hr>

{{< expand "Week 1: Introduction" >}}
<p></p>
This is the first week

{{< /expand >}}

<hr> 

{{< expand "Week 2: First Topic" >}}
<p></p>
This is the second week

{{< /expand >}}

<hr>

## Mermaid

### Pie Chart

{{< mermaid align="left">}}
pie
    title Performance Fractions
    "Data" : 5
    "FFT" : 30
    "Tensorflow" : 50
    "Other" : 15
{{< /mermaid >}}

### Gantt Chart

{{< mermaid align="left" theme="neutral" >}}
gantt
dateFormat  YYYY-MM-DD
title Adding GANTT diagram to mermaid
excludes weekdays 2014-01-10

section A section
Completed task            :done,    des1, 2014-01-06,2014-01-08
Active task               :active,  des2, 2014-01-09, 3d
Future task               :         des3, after des2, 5d
Future task2               :         des4, after des3, 5d
{{< /mermaid >}}

### Sequence Diagram

{{<mermaid>}}
sequenceDiagram
    participant Alice
    participant Bob
    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->John: Fight against hypochondria
    end
    Note right of John: Rational thoughts <br/>prevail...
    John-->Alice: Great!
    John->Bob: How about you?
    Bob-->John: Jolly good!
{{< /mermaid >}}

### Flow Chart

{{<mermaid align="left">}}
graph LR;
    A[Hard edge] -->|Link text| B(Round edge)
    B --> C{Decision}
    C -->|One| D[Result one]
    C -->|Two| E[Result two]
{{< /mermaid >}}


---
date: 2021-02-07
title: "Gradio"
linkTitle: "Gradie"
description: >
  Gradio
author: Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
draft: True
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{< imgproc webpage Fill "600x300" >}}
The Web Page.
{{< /imgproc >}}



{{% pageinfo %}}

Abstract

**Learning Objectives**

* Learn how to ...
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## Install 

```
pip install gradio
```


## Example

Needs to integrate the workers
```
import gradio as gr

def manager(name):
  return "The manager is " + name + "!"

def workers(name):
  return "The workers are " + name + "!"

iface = gr.Interface(fn=manager, inputs="text", outputs="text")
iface.launch()
```


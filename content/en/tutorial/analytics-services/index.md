---
date: 2021-04-22
title: "Autogenerating Analytics Rest Services"
linkTitle: "Analytics Services"
description: "In this section, we will deploy a Pipeline Anova SVM API on an openapi service using cloudmesh-openapi"
author: Richard Otten, and Gregor von Laszewski ([laszewski@gmail.com](mailto:laszewski@gmail.com)) [laszewski.github.io](https://laszewski.github.io)
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
  params:
    byline: "Photo: Gregor von Laszewski / CC-BY-CA"
---

{{% pageinfo %}}


On this page, we will deploy a Pipeline Anova SVM onto our openapi server, and subsequently train the model 
with data and make predictions from said data. All code needed for this is 
provided in the [cloudmesh-openapi](https://github.
com/cloudmesh/cloudmesh-openapi) repository. The code is largely based on 
this [sklearn example](https://scikit-learn.org/stable/auto_examples/feature_selection/plot_feature_selection_pipeline.html). It is supported on Raspberry Pi OS, Linux and Mac.

**Learning Objectives**

* Learn how to create autogeneratred analytic services in Python and 
  deployed with cloudmesh-openapi.
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}


## 1. Overview

### 1.1 Prerequisite

It is also assumed that the user has installed and has familiarity with the following:
* `python3 --version` >= 3.8
* Linux Command line

### 1.2 Effort

* 15 minutes (not including assignment)

### 1.3 List of Topics Covered

In this module, we focus on the following:

* Training ML models with stateless requests
* Generating RESTful APIs using `cms openapi` for existing python code 
* Deploying openapi definitions onto a localserver
* Interacting with newly created openapi services

### 1.4 Syntax of this Tutorial.

We describe the syntax for terminal commands used in this tutorial
using the following example:

```
(TESTENV) ~ $ echo "hello"
```

Here, we are in the python virtual environment `(TESTENV)` in the home directory `~`. The `$` symbol denotes the beginning of the terminal command (ie. `echo "hello"`). When copying and pasting commands, do not include `$` or anything before it.

## 2. Creating a virtual environment

It is best practice to create virtual environments when you do not envision needing a python package consistently. We also want to place all source code in a common directory called cm. Let us set up this create one for this tutorial.

On clusters created with cloudmesh-burn this virtual environment and `cm` 
directory are already created and enabled by default, so you can skip to the `pip` installations 
further below in this section if you do not want to isolate this in a 
separate venv.

On your Linux/Mac, open a new terminal.

```
~ $ python3 -m venv ~/ENV3
```

The above will create a new python virtual environment. Activate it with the following.

```
~ $ source ~/ENV3/bin/activate
```

First, we update pip and verify your python and pip are correct

```
(ENV3) ~ $ which python
/Users/user/ENV3/bin/python

(ENV3) ~ $ which pip
/Users/user/ENV3/bin/pip

(ENV3) ~ $ pip install -U pip
```

Now we can use `cloudmesh-installer` to install the code in developer mode. This gives you access to the source code.

First, create a new directory for the cloudmesh code.

```
(ENV3) ~ $ mkdir ~/cm
(ENV3) ~ $ cd ~/cm
```

Next, we install `cloudmesh-installer` and use it to install cloudmesh openapi.

```
(ENV3) ~/cm $ pip install -U pip
(ENV3) ~/cm $ pip install cloudmesh-installer
(ENV3) ~/cm $ cloudmesh-installer get openapi
```

Finally, for this tutorial, we use `sklearn`. Install the needed packages as follows:

```
(ENV3) ~/cm $ pip install sklearn pandas
```

## 3. The Python Code

Let's take a look at the python code we would like to make a REST service from. First, let's navigate to the local openapi repository that was installed with `cloudmesh-installer`.

```
(ENV3) ~/cm $ cd cloudmesh-openapi

(ENV3) ~/cm/cloudmesh-openapi $ pwd
/Users/user/cm/cloudmesh-openapi
```

Let us take a look at the PipelineAnova SVM example code. The code can also be viewed [here](https://github.com/cloudmesh/cloudmesh-openapi/tree/main/tests/Scikitlearn-experimental)

A
[Pipeline](https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html)
is a *pipeline* of transformations to apply with a final
estimator. Analysis of variance
([ANOVA](https://en.wikipedia.org/wiki/Analysis_of_variance)) is used
for feature selection. A Support vector machine
[SVM](https://en.wikipedia.org/wiki/Support_vector_machine) is used as
the actual learning model on the features.

Use your favorite editor to look at it (whether it be vscode, vim,
nano, etc). We will use emacs
```
(ENV3) ~/cm/cloudmesh-openapi $ emacs ./tests/Scikitlearn-experimental/sklearn_svm.py
```

You may also look at the code [here](https://github.com/cloudmesh/cloudmesh-openapi/blob/main/tests/Scikitlearn-experimental/sklearn_svm.py)

The class within this file has two main methods to interact with (except for the file upload capability which is added at runtime)

```
@classmethod
def train(cls, filename: str) -> str:
    """
    Given the filename of an uploaded file, train a PipelineAnovaSVM
    model from the data. Assumption of data is the classifications 
    are in the last column of the data.

    Returns the classification report of the test split
    """
    # some code...

@classmethod
def make_prediction(cls, model_name: str, params: str):
    """
    Make a prediction based on training configuration
    """
    # some code...
```

Note the parameters that each of these methods takes in. These parameters are expected as part of the stateless request for each method.

## 4. Generating the OpenAPI YAML file

Let us now use the python code from above to create the openapi YAML file that we will deploy onto our server. To correctly generate this file, use the following command:
```
(ENV3) ~/cm/cloudmesh-openapi $ cms openapi generate PipelineAnovaSVM \
    --filename=./tests/Scikitlearn-experimental/sklearn_svm.py \
    --import_class \
    --enable_upload
```
Let us digest the options we have specified:

* `--filename` indicates the path to the python file in which our code is located
* `--import_class` notifies `cms openapi` that the YAML file is generated 
  from a class. The name of this class is specified as `PipelineAnovaSVM`
* `--enable_upload` allows the user to upload files to be stored on the server for reference. This flag causes `cms openapi` to auto-generate a new python file with the `upload` method appended to the end of 
the file. For this example, you will notice a new file has been added in the same directory as `sklearn_svm.py`. The file is aptly called: `sklearn_svm_upload-enabled.py`

## 5. The OpenAPI YAML File (optional) 

If Section 2 above was correctly, cms will have generated the corresponding openapi YAML file. Let us take a look at it.

```
(ENV3) ~/cm/cloudmesh-openapi $ emacs ./tests/Scikitlearn-experimental/sklearn_svm.yaml
```

You may also view the yaml file [here](https://github.com/cloudmesh/cloudmesh-openapi/blob/main/tests/Scikitlearn-experimental/sklearn_svm.yaml)

This YAML file has a lot of information to digest. The basic structure is documented [here](https://swagger.io/docs/specification/basic-structure/). However, it is not necessary to understand this information to deploy RESTful APIs. 

However, take a look at `paths:` on line 9 in this file. Under this section, we have several different endpoints for our API listed. Notice the correlation between the endpoints and the python file we generated from.

## 6. Starting the Server

Using the YAML file from Section 2, we can now start the server.

```
(ENV3) ~/cm/cloudmesh-openapi $ cms openapi server start ./tests/Scikitlearn-experimental/sklearn_svm.yaml
```

The server should now be active. Navigate to [http://localhost:8080/cloudmesh/ui](http://localhost:8080/cloudmesh/ui). 

{{< imgproc cloudmesh_ui Fill "850x463" />}}

## 7. Interacting With the Endpoints

### 7.1 Uploading the Dataset

We now have a nice user inteface to interact with our newly generated
API. Let us upload the data set. We are going to use the iris data set in this example. We have provided it for you to use. Simply navigate to the `/upload` endpoint by clicking on it, then click Try it out.

We can now upload the file. Click on Choose File and upload the data set located at `~/cm/cloudmesh-openapi/tests/Scikitlearn-experimental/iris.data`. Simply hit Execute after the file is uploaded. We should then get a `200` return code (telling us that everything went ok).

{{< imgproc upload_endpoint Fill "850x463" />}}

### 7.2 Training on the Dataset

The server now has our dataset. Let us now navigate to the `/train` endpoint by, again, clicking on it. Similarly, click `Try it out`. The parameter being asked for is the filename. The filename we are interested in is `iris.data`. Then click execute. We should get another `200` return code with a Classification Report in the Response Body.

{{< imgproc train_endpoint Fill "850x463" />}}

### 7.3 Making Predictions

We now have a trained model on the iris data set. Let us now use it to make predictions. The model expects 4 attribute values: sepal length, seapl width, petal length, and petal width. Let us use the values `5.1, 3.5, 1.4, 0.2` as our attributes. The expected classification is `Iris-setosa`.

Navigate to the `/make_prediction` endpoint as we have with other endpoints. Again, let us `Try it out`. We need to provide the name of the model and the params (attribute values). For the model name, our model is aptly called `iris` (based on the name of the data set). 

{{< imgproc make_prediction_endpoint Fill "850x463" />}}

As expected, we have a classification of `Iris-setosa`. 

## 8. Clean Up (optional)

At this point, we have created and trained a model using `cms openapi`. After satisfactory use, we can shut down the server. Let us check what we have running.

```
(ENV3) ~/cm/cloudmesh-openapi $ cms openapi server ps
openapi server ps

INFO: Running Cloudmesh OpenAPI Servers

+-------------+-------+--------------------------------------------------+
| name        | pid   | spec                                             |
+-------------+-------+--------------------------------------------------+
| sklearn_svm | 94428 | ./tests/Scikitlearn-                             |
|             |       | experimental/sklearn_svm.yaml                    |
+-------------+-------+--------------------------------------------------+
```

We can stop the server with the following command:

```
(ENV3) ~/cm/cloudmesh-openapi $ cms openapi server stop sklearn_svm
```

We can verify the server is shut down by running the `ps` command again.

```
(ENV3) ~/cm/cloudmesh-openapi $ cms openapi server ps
openapi server ps

INFO: Running Cloudmesh OpenAPI Servers

None
```

## 9. Uninstallation (Optional)

After running this tutorial, you may uninstall all cloudmesh-related things as follows:

First, deactivate the virtual environment.

```
(ENV3) ~/cm/cloudmesh-openapi $ deactivate

~/cm/cloudmesh-openapi $ cd ~
```

Then, we remove the `~/cm` directory.

```
~ $ rm -r -f ~/cm
```

We also remove the cloudmesh hidden files:

```
~ $ rm -r -f ~/.cloudmesh
```

Lastly, we delete our virtual environment.

```
~ $ rm -r -f ~/ENV3
```

Cloudmesh is now succesfully uninstalled.

## 10. References

* [Scikit-learn Web Page](https://scikit-learn.org)

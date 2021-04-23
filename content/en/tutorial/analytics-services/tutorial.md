---
title: "Live Tutorial"
linkTitle: "Live Tutorial"
weight: 100
description: >-
     This includes information pertaining to our live tutorial.
---

## Live Tutorial Specific Information

(Gregor)

* Meeting location is  https://meet.google.com/qpb-ugoc-oyr
* Friday 9am EST

Idea

     function -> cms openapi -> openapi specification + server code
              
What the scientist does

(Richie)

* [https://github.com/cloudmesh/cloudmesh-openapi/blob/main/tests/Scikitlearn-experimental/sklearn_svm.py](https://github.com/cloudmesh/cloudmesh-openapi/blob/main/tests/Scikitlearn-experimental/sklearn_svm.py)

## 1. Collect public keys to be granted access.

(Gregor, presents, Anthony collect and let us know when we are ready)

We need to collect your public rsa key to grant you access to the cluster.

On windows:
```
type C:\Users\username\.ssh\id_rsa.pub
```

On Mac or Linux:
```
you@yourlaptop:~$ cat ~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3dyfqZ6F/FWrj7d5CTCUbxJt64dxQ5PdGJtci+scAT2B5kXmUB+rBW4tSEy/Lcdg+T3x9Rola0kTYaCwP+7UbxVaPlXWF5Ss+9XzOC24JN//fUn8hnCvKh9jFoKF6NIxP8DJJ94r1aU3+P0c6UKkQZU2W91BXAL4FWqO9zdWtPYkR//HWJzZy6sqoUzAVAOY+y7xtX0ybJ9qg767Gx4xpu0kcbvgphOxkNRdNPXFB5EsrRPB1rw/vblNF9Y65ahAtmcHJB9kxj0JBtor3DK+b6i+zrIbNYPAV2b6iI30tbxcEk0ovnEZiuRz0dxDslPrziMSPWnFFFY5pQxZOnGG7 you@yourlaptop
```

If you do not have an ssh key pair, you can generate one on Mac or Windows with the command below. It is best to use a password and save the key with the default name of id_rsa to ~/.ssh/:

```
you@yourlaptop:~$  ssh-keygen
```

Please paste and copy your public key content into our google doc.

https://docs.google.com/document/d/1Zuv13G2yEvZ5EjDjwxizyaMIf75Rnjky7mDfRd4Ggjo/edit?usp=sharing

## 2. Assign Pis.

(Anthony explains whogets what PI)

You will be assigned a Pi to access on which to run the demo.

**XX.XX.XX.XX is 68.50.12.18**

**red**

`ssh pi@XX.XX.XX.XX`

http://XX.XX.XX.XX:8080/cloudmesh/ui

**red01 (WO)**

`ssh pi@XX.XX.XX.XX -p 8000`

http://XX.XX.XX.XX:8001/cloudmesh/ui

**red02 (Mark)**

`ssh pi@XX.XX.XX.XX -p 8002`

http://XX.XX.XX.XX:8003/cloudmesh/ui

**red03 (Russel)**

`ssh pi@XX.XX.XX.XX -p 8004`

http://XX.XX.XX.XX:8005/cloudmesh/ui

**red04 (Gary)**

`ssh pi@XX.XX.XX.XX -p 8006`

http://XX.XX.XX.XX:8007/cloudmesh/ui

**red05 (PW)**

`ssh pi@XX.XX.XX.XX -p 8008`

http://XX.XX.XX.XX:8009/cloudmesh/ui

**red06 (Michele)**

`ssh pi@XX.XX.XX.XX -p 8010`

http://XX.XX.XX.XX:8011/cloudmesh/ui

**red07 (Richie)**

`ssh pi@XX.XX.XX.XX -p 8012`

http://XX.XX.XX.XX:8013/cloudmesh/ui

**red08 (DK)**

`ssh pi@XX.XX.XX.XX -p 8014`

http://XX.XX.XX.XX:8015/cloudmesh/ui

**red09 (Gregor)**

`ssh pi@XX.XX.XX.XX -p 8016`

http://XX.XX.XX.XX:8017/cloudmesh/ui

**red10 (Anthony)**

`ssh pi@XX.XX.XX.XX -p 8018`

http://XX.XX.XX.XX:8019/cloudmesh/ui



## 3. Download training data.

(Richie)

The training data is a copy of the famous iris data set. You can download it from this link (save as `iris.data`) so we can demonstrate how to upload data, otherwise the data is pre-uploaded.

[iris data](https://drive.google.com/uc?export=download&id=1VSAut8Q_jNVC7arSkQp7twzYwHkTJmRk)

```bash
laptop$ curl -L -o iris.data "https://raw.githubusercontent.com/cloudmesh/cloudmesh-openapi/main/tests/Scikitlearn-experimental/iris.data"
```

or

```bash
laptop$ wget -O iris.data "https://raw.githubusercontent.com/cloudmesh/cloudmesh-openapi/main/tests/Scikitlearn-experimental/iris.data"
```

(Verification if data is ok)

```bash
laptop$ head -3 iris.data

5.1,3.5,1.4,0.2,Iris-setosa
4.9,3.0,1.4,0.2,Iris-setosa
4.7,3.2,1.3,0.2,Iris-setosa
```

## 4. Live Demo

(Richie)

In this tutorial, we will create a REST service based on a simple [SciKit Learn Example](https://scikit-learn.org/stable/auto_examples/feature_selection/plot_feature_selection_pipeline.html).

This example implements a Pipeline Anova SVM for the purposes of data classification.

A
[Pipeline](https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html)
is a *pipeline* of transformations to apply with a final
estimator. Analysis of variance
([ANOVA](https://en.wikipedia.org/wiki/Analysis_of_variance)) is used
for feature selection. A Support vector machine
[SVM](https://en.wikipedia.org/wiki/Support_vector_machine) is used as
the actual learning model on the features.

We will reference the python file [https://github.com/cloudmesh/cloudmesh-openapi/blob/main/tests/Scikitlearn-experimental/sklearn_svm.py](https://github.com/cloudmesh/cloudmesh-openapi/blob/main/tests/Scikitlearn-experimental/sklearn_svm.py)

Let us take a look at the code on the server. SSH into your assigned pi and take a look at the code with your favorite editor. We have provided emacs as an option.

```
pi$ cd ./cm/cloudmesh-openapi
pi$ emacs ./tests/Scikitlearn-experimental/sklearn_svm.py
```

Next we will generate the service yaml file, provided here for easy viewing. [https://github.com/cloudmesh/cloudmesh-openapi/blob/main/tests/Scikitlearn-experimental/sklearn_svm.yaml](https://github.com/cloudmesh/cloudmesh-openapi/blob/main/tests/Scikitlearn-experimental/sklearn_svm.yaml)

This is generated on the Pi with the command below.

```
pi$  cms openapi generate PipelineAnovaSVM \
    --filename=./tests/Scikitlearn-experimental/sklearn_svm.py \
    --import_class \
    --enable_upload
```

When starting our server we will need to add a `--host=0.0.0.0` option to expose the service to the internet. We will use this command.

```
pi$ cms openapi server start ./tests/Scikitlearn-experimental/sklearn_svm.yaml --host=0.0.0.0
```

## 5. We can now follow the standard tutorial starting with section 6

(Anthony)

[openapi tutorial](https://cloudmesh.github.io/pi/tutorial/analytics-services/#6-starting-the-server)

## 6. Running from commandline

(Anthony)

```bash
laptop$ cd ~/Downloads # or wherever you put iris.data

laptop$ export CMSIP=68.50.12.xx:800X

laptop$ curl -X POST "http://$CMSIP/cloudmesh/upload" -H  "accept: text/plain" -H  "Content-Type: multipart/form-data" -F "upload=@iris.data"

laptop$ curl -X GET "http://$CMSIP/cloudmesh/PipelineAnovaSVM/train?filename=iris.data" -H  "accept: text/plain"

laptop$ curl -X GET "http://$CMSIP/cloudmesh/PipelineAnovaSVM/make_prediction?model_name=iris&params=5.1%2C%203.5%2C%201.4%2C%200.2" -H  "accept: */*"
```
```
ADD request based customer.py
```

This will result in 

```
CLASSIFICATION_REPORT: 
              precision    recall  f1-score   support

           0       1.00      1.00      1.00        12
           1       1.00      0.92      0.96        13
           2       0.93      1.00      0.96        13

    accuracy                           0.97        38
   macro avg       0.98      0.97      0.97        38
weighted avg       0.98      0.97      0.97        38

$ curl -X GET "http://$CMSIP/cloudmesh/PipelineAnovaSVM/make_prediction?model_name=iris&params=5.1%2C%203.5%2C%201.4%2C%200.2" -H  "accept: */*"
"Classification: ['Iris-setosa']"
```

## 7. Server ps command

(Anthony)

```bash
pi$ .....   CTRL-C
pi$ cms openapi server ps
```

## 8. Killing the server

```bash
pi$ .....   CTRL-C
pi$ cms openapi server stop sklearn_svm
```

## 9. Add container

add container distribution


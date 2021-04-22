---
title: "Live Tutorial"
linkTitle: "Live Tutorial"
weight: 100
description: >-
     This includes information pertaining to our live tutorial.
---

## Live Tutorial Specific Information

## 1. Collect public keys to be granted access.

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

## 2. Assign Pis.

You will be assigned a Pi to access on which to run the demo.

**red**

`ssh pi@XX.XX.XX.XX`

http://XX.XX.XX.XX:8080/cloudmesh/ui

**red01**

`ssh pi@XX.XX.XX.XX -p 8000`

http://XX.XX.XX.XX:8001/cloudmesh/ui

**red02**

`ssh pi@XX.XX.XX.XX -p 8002`

http://XX.XX.XX.XX:8003/cloudmesh/ui

**red03**

`ssh pi@XX.XX.XX.XX -p 8004`

http://XX.XX.XX.XX:8005/cloudmesh/ui

**red04**

`ssh pi@XX.XX.XX.XX -p 8006`

http://XX.XX.XX.XX:8007/cloudmesh/ui

**red05**

`ssh pi@XX.XX.XX.XX -p 8008`

http://XX.XX.XX.XX:8009/cloudmesh/ui

**red06**

`ssh pi@XX.XX.XX.XX -p 8010`

http://XX.XX.XX.XX:8011/cloudmesh/ui

## 3. Download training data.

The training data is a copy of the famous iris data set. You can download it from this link (save as `iris.data`) so we can demonstrate how to upload data, otherwise the data is pre-uploaded.

[iris data](https://drive.google.com/drive/u/0/folders/17LlCE2AtWLJxbDh62AYN0efoNR5wrSDl)

```bash
$ wget https://drive.google.com/file/d/1VSAut8Q_jNVC7arSkQp7twzYwHkTJmRk/view?usp=sharing -o iris.data
```

## 4. Take note of live demo tutorial differences.

When starting our server we will need to add a `--host=0.0.0.0` option to expose the service to the internet. We will use this command.

```
cms openapi server start ./tests/Scikitlearn-experimental/sklearn_svm.yaml --host=0.0.0.0
```

## 5. We can now follow the standard tutorial starting from section 3 (post install)

[openapi tutorial](https://cloudmesh.github.io/pi/tutorial/analytics-services/#3-the-python-code)

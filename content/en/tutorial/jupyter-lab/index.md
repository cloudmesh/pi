## Introduction

Instructions in this tutorial are directly from [Jupyter Lab on Raspberry Pi][], which I have walked through and added in updates where necessary. 

[Jupyter Lab on Raspberry Pi]: "https://medium.com/analytics-vidhya/jupyter-lab-on-raspberry-pi-22876591b227"

## Installation


Run the following commands to install Jupyter Lab:  

```
$ sudo apt-get update  
$ sudo apt-get install python3-pip  
$ sudo pip3 install setuptools  
$ sudo apt install libffi-dev  
$ sudo pip3 install cffi  
$ pip3 install jupyterlab
```

After completion, try starting a Jupyter Lab instance:  

```$ jupyter-lab```

If you run into an ```ImportError``` for the ```jupyter_core_paths``` module, upgrade your ```jupyter_core_paths``` module using the following command:  

```$ pip3 install --upgrade jupyter_client```

## Jupyter Lab as a Service

Follow the steps in the **Setup Jupyter lab as a service** and **Add password** sections of [Jupyter Lab on Raspberry Pi]

## SSL Setup

From Jupyter Notebook Docs on [SSL Setup][]

[SSL Setup]: "https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#using-ssl-for-encrypted-communication"

Create a self-signed certificate:

```
$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykey.key -out mycert.pem
```

Set your notebook to run in a secure protocol mode using the certificate you made:

```
$ jupyter notebook --certfile=mycert.pem --keyfile mykey.key
```

Open the ```jupyter_notebook_config.py``` and ```jupyter_notebook_config.json``` files:

```
$ sudo nano /home/pi/.jupyter/jupyter_notebook_config.py   
$ sudo nano /home/pi/.jupyter/jupyter_notebook_config.json

```
Copy the password value from the .json file. In the .py file, scroll through and uncomment the following fields and add the following values. They should be in order. You can use the ```$realpath filename.extension``` command get absolute paths to your files in bash.

```
c.NotebookApp.certfile = u'/absolute/path/to/your/certificate/mycert.pem'
c.NotebookApp.ip = '*'
c.NotebookApp.keyfile = u'/absolute/path/to/your/certificate/mykey.key'
c.NotebookApp.open_browser = False
c.NotebookApp.password = u'PASSWORD COPIED FROM .JSON FILE'
c.NotebookApp.port = 9999

```

## Configure Firewall





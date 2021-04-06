---
layout: default
title: Ejecución simple de contenedores
nav_order: 4
parent: Introducción
---
# Ejecución simple de contenedores

Con el comando `run` vamos a crear un contenedor donde vamos a ejecutar un comando, en este caso vamos a crear el contenedor a partir de una imagen ubuntu. Como todavía no hemos descargado ninguna imagen del registro docker hub, es necesario que se descargue la  imagen. Si la tenemos ya en nuestro ordenador no será necesario la descarga. 

```bash
$ docker run ubuntu echo 'Hello world' 
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
8387d9ff0016: Pull complete 
...
Status: Downloaded newer image for ubuntu:latest
Hello world
```

Comprobamos que el contenedor ha ejecutado el comando que hemos indicado y se ha parado:

```bash
$ docker ps -a
CONTAINER ID        IMAGE              COMMAND                  CREATED               STATUS                      PORTS               NAMES
3bbf39d0ec26        ubuntu              "echo 'Hello wo…"   31 seconds ago      Exited     (0) 29 seconds ago                       wizardly_edison
```

Con el comando `docker images` podemos visualizar las imágenes que ya tenemos descargadas en nuestro registro local:

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID           CREATED             SIZE
ubuntu              latest              f63181f19b2f        7 days ago          72.9MB
hello-world         latest              bf756fb1ae65        13 months ago       13.3kB
```


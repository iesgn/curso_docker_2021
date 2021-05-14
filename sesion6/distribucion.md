---
layout: default
title: Distribución de imágenes
nav_order: 3
parent: Creación de imágenes
---

# Distribución de imágenes

Una vez que hemos creado nuestra imagen personalizada, es la hora de destribuirla para desplegarla en el entorno de producción. Para ello vamos a tener varias posibilidades:


1. Utilizar la secuencia de órdenes `docker commit` /` docker save` / `docker load`. En este caso la distribución se producirá a partir de un fichero.
2. Utilizar la pareja de órdenes `docker commit` / `docker push`. En este caso la distribución se producirá a través de DockerHub.
3. Utilizar la pareja de órdenes `docker export` / `docker import`. En este caso la distribución de producirá a través de un fichero.

En este curso nos vamos a ocupar  únicamente de las dos primeras ya que la tercera se limita a copiar el sistema de ficheros sin tener en cuenta la información de las imágenes de las que deriva el contenedor (capas, imagen de origen, autor etc..) y además si tenemos volúmenes o bind mounts montados los obviará.

## Distribución a partir de un fichero

1. Guardar esa imagen en un archivo .tar usando el comando `docker save`:

    ```bash    
    $ docker save josedom24/myapache2:v1 > myapache2.tar
    ```

2. Distribuir el fichero `.tar`.

3. Si me llega un fichero .tar puedo añadir la imagen a mi repositorio local:

    ```bash
    $ docker load -i myapache2.tar          
    6a30654d94bc: Loading layer [=============================================>]  132.4MB/132.4MB
    Loaded image: josedom24/myapache2:v1
    ```

## Distribución usando Docker Hub

1. Autentificarme en Docker Hub usando el comando `docker login`.

    ```bash
    $ docker login 
    Login with your Docker ID to push and pull images from Docker Hub...
    Username: josedom24
    Password: 
    ...
    Login Succeeded
    ```

2. Distribuir ese fichero subiendo la nueva imagen a DockerHub mediante `docker push`. Nota: El nombre de la imagen tiene que tener como primera parte el nombre del usuario de DockerHub que estamos usando.

    ```bash
    $ docker push josedom24/myapache2:v2
    The push refers to repository [docker.io/josedom24/myapache2:v2]
    6a30654d94bc: Pushed 
    4762552ad7d8: Mounted from library/debian 
    latest: digest: sha256:25b34b8342ac8b73058aa07ec935dcf5d33db7544da9a216050e1d2077a size: 741
    ```

3. Ya cualquier persona puede bajar la imagen usando `docker pull`.

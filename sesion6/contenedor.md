---
layout: default
title: Creación de imágenes a partir de un contenedor
nav_order: 1
parent: Creación de imágenes
---
# Creación de una nueva imagen a partir de un contenedor

La primera forma para personalizar las imágenes es partiendo de un contenedor en ejecución. 

1. Arranca un contenedor a a partir de una imagen base

    ```bash
    $ docker  run -it --name contenedor debian bash
    ```

2. Realizar modificaciones en el contenedor (instalaciones, modificación de archivos,...)

    ```bash
    root@2df2bf1488c5:/# apt update && apt install apache2 -y
    ```

3. Crear una nueva imagen partiendo de ese contenedor usando `docker commit`. Con esta instrucción se creará una nueva imagen con las capas de la imagen base más la capa propia del contenedor. Al creala no voy a poner etiqueta, por lo que será `latest`.

    ```bash
    $ docker commit contenedor josedom24/myapache2
    sha256:017a4489735f91f68366f505e4976c111129699785e1ef609aefb51615f98fc4

    $ docker images
    REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
    josedom24/myapache2       latest              017a4489735f        44 seconds ago      243MB
    ...
    ```



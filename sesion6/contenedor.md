---
layout: default
title: Creación de imágenes a partir de un contenedor
nav_order: 1
parent: Creación de imágenes
---
# Creación de una nueva imagen a partir de un contenedor

La primera forma para personalizar las imágenes es partiendo de un contenedor que hayamos modificado. 

1. Arranca un contenedor a partir de una imagen base.

    ```bash
    $ docker  run -it --name contenedor debian bash
    ```

2. Realizar modificaciones en el contenedor (instalaciones, modificación de archivos,...).

    ```bash
    root@2df2bf1488c5:/# apt update && apt install apache2 -y
    root@75f87f84a091:/# echo "<h1>Curso Docker</h1>" > /var/www/html/index.html
    root@75f87f84a091:/# exit
    ```

3. Crear una nueva imagen partiendo de ese contenedor usando `docker commit`. Con esta instrucción se creará una nueva imagen con las capas de la imagen base más la capa propia del contenedor. Si no indico etiqueta en el nombre, se pondrá la etiqueta `latest`.

    ```bash
    $ docker commit contenedor josedom24/myapache2:v1
    sha256:017a4489735f91f68366f505e4976c111129699785e1ef609aefb51615f98fc4

    $ docker images
    REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
    josedom24/myapache2       v1              017a4489735f        44 seconds ago      243MB
    ...
    ```

4. Podríamos crear un nuevo contenedor a partir de esta nueva imagen, pero al crear una imagen con este método **no podemos configurar el proceso que se va a ejecutar por defecto al crear el contenedor** (el proceso por defecto que se ejecuta sería el de la imagen base). Por lo tanto en la creación del nuevo contenedor tendríamos que indicar el proceso que queremos ejecutar. En este caso para ejecutar el servidor web apache2 tendremos que ejecutar el comando `apache2ctl -D FOREGROUND`:

```bash
$ docker run -d -p 8080:80 \
             --name servidor_web \
             josedom24/myapache2:v1 \
             bash -c "apache2ctl -D FOREGROUND"
```

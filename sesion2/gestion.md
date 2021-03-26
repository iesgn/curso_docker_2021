---
layout: default
title: Gestión de imágenes
nav_order: 3
parent: Imágenes
---
# Gestión de imágenes

Para crear un contenedor es necesario usar una imagen que tengamos descargado en nuestro registro local. Por lo tanto al ejecutar `docker run` se comprueba si tenemos la versión indicada de la imagen y si no es así, se precede a su descarga.

Las principales instrucciones para trabajar con imágenes son:

* `docker images`: Muestra las imágenes que tenemos en el registro local.
* `docker pull`: Nos permite descargar la última versión de la imagen indicada.
* `docker rmi`: Nos permite eliminar imágenes. No podemos eliminar una imágen si tenemos algún contenedor creada a partir de ella.
* `docker search`: Busca imágenes en Docker Hub.
* `docker inspect`: nos da información sobre la imágen indicada:
    * El id y el checksum de la imagen.
    * Los puertos abiertos.
    * La arquitectura y el sistema operativo de la imagen.
    * El tamaño de la imagen.
    * Los volúmenes.
    * El ENTRYPOINT que es lo que se ejecuta al hacer `docker run`.
    * Las capas.
    * Y muchas más cosas....


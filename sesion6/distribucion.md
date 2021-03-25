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
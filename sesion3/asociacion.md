---
layout: default
title: "Asociando almacenamiento a los contenedores"
nav_order: 3
parent: Almacenamiento
---

# Asociando almacenamiento a los contenedores

Veamos como puedo usar los volúmenes y los bind mounts en los contenedores. Para cualquiera de los dos casos lo haremos mediante el uso de dos flags de la orden `docker run`:

* El flag `--volume` o `-v`
* El flag `--mount`

Es importante que tengamos en cuenta algunas cosas a la hora de realizar estas operaciones:

* Al usar tanto volúmenes como bind mount, el contenido de lo que tenemos sobreescribirá la carpeta destino en el sistema de ficheros del contenedor en caso de que exista.
* Si al montar un volumen, ese volumen no lo hemos creado anteriormente, se creará.
* Si nuestra carpeta origen no existe y hacemos un bind mount esa carpeta se creará pero lo que tendremos en el contenedor es una carpeta vacía. 
* Si usamos imágenes de DockerHub, debemos leer la información que cada imagen nos proporciona en su página ya que esa información suele indicar cómo persistir los datos de esa imagen, ya sea con volúmenes o bind mounts, y cuáles son las carpetas importantes en caso de ser imágenes que contengan ciertos servicios (web, base de datos etc...)
---
layout: default
title: Creando un contenedor con un servidor web
nav_order: 7
parent: Introducción
---
# Creando un contenedor con un servidor web

Tenemos muchas imágenes en el registro público **docker hub**, por ejemplo podemos crear un servidor web con apache 2.4:

```bash
$ docker run -d --name my-apache-app -p 8080:80 httpd:2.4
```

Vemos que el contenedor se está ejecutando, además con la opción `-p` mapeamos un puerto del equipo donde tenemos instalado el docker, con un puerto del contenedor.  Para probarlo accede desde un navegador a la ip del servidor con docker y al puerto 8080.

Para acceder al log del contenedor podemos ejecutar:

```bash
$ docker logs my-apache-app
```

Con la opción `logs -f` seguimos visualizando los logs en tiempo real.

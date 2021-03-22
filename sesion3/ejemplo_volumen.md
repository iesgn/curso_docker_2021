---
layout: default
title: "Ejemplo usando volúmenes docker"
nav_order: 5
parent: "Almacenamiento"
---

## Ejemplo usando volúmenes docker

```bash
$ docker volume create miweb
miweb

$ docker run -d --name my-apache-app --mount type=volume,src=miweb,dst=/usr/local/apache2/htdocs -p 8080:80 httpd:2.4
b51f89eb21701362279489c5b52a06b1a44c10194c00291de895b404ab347b80

$ docker exec my-apache-app bash -c 'echo "<h1>Hola</h1>" > htdocs/index.html'

$ curl http://localhost:8080
<h1>Hola</h1>

$ docker rm -f my-apache-app 
my-apache-app

$ docker run -d --name my-apache-app -v miweb:/usr/local/apache2/htdocs -p 8080:80 httpd:2.4
baa3511ca2227e30d90fa2b4b225e209889be4badff583ce58ac1feaa73d5d77

$ curl http://localhost:8080
<h1>Hola</h1>
```

Una aclaración, si hubiéramos ejecutado:

```bash
$ docker run -d --name my-apache-app --mount type=volume,dst=/usr/local/apache2/htdocs -p 8080:80 httpd:2.4
```

Al no indicar el volumen, se creará un nuevo volumen.

Otra aclaración, si usamos el flag `-v` e indicamos un nombre, se creará un volumen docker nuevo.

```bash
$ docker run -d --name my-apache-app -v wwwroot:/usr/local/apache2/htdocs -p 8080:80 httpd:2.4

$ docker volume list
DRIVER              VOLUME NAME
...
local               wwwroot
```

# Ejercicios

Vamos a trabajar con volúmenes docker:
#. Crea un volumen docker que se llame `miweb`.
#. Crea un contenedor desde la imagen `php:7.4-apache` donde montes en el directorio `/var/www/html` (que sabemos que es el docuemntroot del servidor que nos ofrece esa imagen) el volumen docker que has creado.
#. Utiliza el comando `docker cp` para copiar un fichero `info.php` en el directorio `/var/www/html`.
#. Accede al contenedor desde el navegador para ver la información ofrecida por el fichero `info.php`.
#. Borra el contenedor
#. Crea un nuevo contenedor y monta el mismo volumen como en el ejercicio anterior.
#. Accede al contenedor desde el navegador para ver la información ofrecida por el fichero `info.php`. ¿Seguía existiendo ese fichero?
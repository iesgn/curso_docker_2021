---
layout: default
title: "Ejemplo usando volúmenes docker"
nav_order: 4
parent: Almacenamiento
---

## Ejemplo usando volúmenes docker

Lo primero que vamos a hacer es crear un volumen docker:

```bash
$ docker volume create miweb
miweb

A continuación creamos un contenedor con el volumen asociado, usando `--mount`, y creamos un fichero `index.html`:

$ docker run -d --name my-apache-app --mount type=volume,src=miweb,dst=/usr/local/apache2/htdocs -p 8080:80 httpd:2.4
b51f89eb21701362279489c5b52a06b1a44c10194c00291de895b404ab347b80

$ docker exec my-apache-app bash -c 'echo "<h1>Hola</h1>" > /usr/local/apache2/htdocs/index.html'

$ curl http://localhost:8080
<h1>Hola</h1>

$ docker rm -f my-apache-app 
my-apache-app

Después de borrar el contenedor, volvemos a crear otro contenedor con el volumen asociado, pero en esta ocasión usamos el parámetro `-v`:

$ docker run -d --name my-apache-app -v miweb:/usr/local/apache2/htdocs -p 8080:80 httpd:2.4
baa3511ca2227e30d90fa2b4b225e209889be4badff583ce58ac1feaa73d5d77

Y podemos comprobar que no no se ha perdido la información (el fichero `index.html`):

$ curl http://localhost:8080
<h1>Hola</h1>
```

Algunas aclaraciones:

1. Al no indicar el volumen, se creará un nuevo volumen.

```bash
$ docker run -d --name my-apache-app --mount type=volume,dst=/usr/local/apache2/htdocs -p 8080:80 httpd:2.4

docker volume list
DRIVER              VOLUME NAME
local               67a8c067f4de273db5f0cc3096ad87dc1658b56ca8388b108ea00b8641494c93
```

2. Si usamos el flag `-v` e indicamos un nombre, se creará un volumen docker nuevo.

```bash
$ docker run -d --name my-apache-app -v wwwroot:/usr/local/apache2/htdocs -p 8080:80 httpd:2.4

$ docker volume list
DRIVER              VOLUME NAME
...
local               wwwroot
```
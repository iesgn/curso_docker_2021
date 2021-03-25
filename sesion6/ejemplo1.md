---
layout: default
title: "Ejemplo 1: Construcción de imágenes con una página estática"
nav_order: 4
parent: Creación de imágenes
---
# Ejemplo 1: Construcción de imágenes con una página estática





docker run -d -p 80:80 --name ejemplo1 josedom24/ejemplo1:v1










Los siguientes ejemplos lo puedes encontrar en el siguiente [repositorio](https://github.com/josedom24/ejemplos_dockerfile).

## Ejemplo 1: Creación de una imagen desde una imagen base

En este caso es necesario instalar los paquetes necesarios, copiar los ficheros de la aplicación en el directorio correspondiente e indicar el comando que se va a ejecutar al crear el contenedor.

En este ejemplo vamos a crear una imágen con una página estática, el `Dockerfile` sería:

```Dockerfile
FROM debian
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

RUN apt-get update && apt-get install -y apache2 && apt-get lean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
ADD ["index.html","/var/www/html/"]

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

## Ejemplo 2: Creación de una imagen desde una imagen con la aplicación

En este caso vamos a usar la imágen `httpd:2.4`, y lo único que tendremos que hacer será copiar los ficheros de la aplicación en el directorio correspondiente. no es necesario indicar el comando que ejecutará el contenedor ya que lo heredará de la imagen inicial. En este caso el `Dockerfile` quedaría:

```Dockerfile
FROM httpd:2.4
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

EXPOSE 80
ADD public_html/index.html /usr/local/apache2/htdocs/
```

## Ejemplo 3: Creación de una imagen configurable con variables de entorno (1ª opción)

En este ejemplo queremos configurar algún parámetro del servicio de la imagen utilizando variables de entorno, en este caso vamos a crear una variable de entorno con el valor predeterminado. Cuando creamos el contenedor podremos cambiar este valor redifiniendo la variable de entorno. Además crearemos un script en bash, que será el que se ejecutará al crear el contenedor y será el responsable de editar los ficheros de configuración según el valor de las variables de entorno e iniciar el servicio.

El fichero `script.sh` será:

```bash
#!/bin/bash

sed -i "s/#ServerName www.example.com/ServerName $SERVER_NAME/g" /etc/apache2/sites-available/000-default.conf 
apache2ctl -D FOREGROUND
```

Y el `Dockerfile`:

```Dockerfile
FROM debian
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
ADD public_html/index.html /var/www/html/
ADD script.sh /usr/local/bin/

ENV SERVER_NAME www.example.com
CMD ["script.sh"]
```

## Ejemplo 4: Creación de una imagen configurable con variables de entorno (2ª opción)

En esta segunda opción lo que vamos a hacer es copiar el fichero de configuración con las variables de entorno que vamos a usar en el directorio correspondiente. En este caso, si no tengo que hacer ninguna otra acción sobre el sistema no necesito el fichero `script.sh`.

En este caso tendremos el fichero `000-default.conf` en el contexto con este contenido:

```bash
<VirtualHost *:80>
        ...
        ServerName ${SERVER_NAME}
        ...
```

Y el `Dockerfile` sería:

```Dockerfile
FROM debian
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"

RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80
ADD public_html/index.html /var/www/html/
ADD 000-default.conf /etc/apache2/sites-available/

ENV SERVER_NAME www.example.com

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

## Ejemplo 5: docker-compose que construyen imágenes

En muchas ocasiones la imagen que se utiliza en docker-compose se genera antes con un `Dockerfile`, podemos configurar en nuestro `docker-compose.yml` que cuando levante el escenario genere la imagen usada a partir de un `Dockerfile`, utilizando el parámetro `buiild` en ves del parámetro `image`.

Además puede ser buena idea estructurar en direcotrios distintos la construcción de la imagen (directorio `build`) y el docker-compose (directorio `deploy`).

En este caso, el fichero `docker-compose.yml` del directorio `deploy` quedaría:

```yaml
version: '3.1'

services:
  apache:
    container_name: servidor_apache
    build: ../build
    restart: always
    environment:
      SERVER_NAME: www.prueba.com
    ports:
      - 8080:80
```

Al ejecutar `docker-compose up -d` se creará la imagen a partir del `Dockerfile` del directorio `build`. si posteriormente queremos regenerar la imagen tendremos que ejecutar `docker-compose build` o `docker-compose up --build -d`.

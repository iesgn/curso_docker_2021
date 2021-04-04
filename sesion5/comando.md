---
layout: default
title: "El comando docker-compose"
nav_order: 4
parent: Escenarios multicontenedor
---

# El comando docker-compose

Una vez hemos creado el archivo `docker-compose.yml` tenemos que empezar a trabajar con él, es decir a crear los contenedores que describe su contenido. 

Esto lo haremos mediante el ejecutable [`docker-compose`](https://docs.docker.com/compose/reference/). **Es importante destacar que debemos invocarla desde el directorio en el que se encuentra el fichero `docker-compose.yml`**.

Los subcomandos más usados son:

* `docker-compose up`: Crear los contenedores (servicios) que están descritos en el `docker-compose.yml`.
* `docker-compose up -d`: Crear en modo detach los contenedores (servicios) que están descritos en el `docker-compose.yml`. Eso significa que no muestran mensajes de log en el terminal y que se  nos vuelve a mostrar un prompt.
* `docker-compose stop`: Detiene los contenedores que previamente se han lanzado con `docker-compose up`.
* `docker-compose run`: Inicia los contenedores descritos en el `docker-compose.yml` que estén parados.
* `docker-compose rm`: Borra los contenedores parados del escenario. Con las opción `-f` elimina también los contenedores en ejecución.
* `docker-compose pause`: Pausa los contenedores que previamente se han lanzado con `docker-compose up`.
* `docker-compose unpause`: Reanuda los contenedores que previamente se han pausado.
* `docker-compose restart`: Reinicia los contenedores. Orden ideal para reiniciar servicios con nuevas configuraciones.
* `docker-compose down`:  Para los contenedores, los borra  y también borra las redes que se han creado con `docker-compose up` (en caso de haberse creado).
* `docker-compose down -v`: Para los contenedores y borra contenedores, redes y volúmenes
* `docker-compose logs servicio1`: Muestra los logs del servicio llamado servicio1 que estaba descrito en el `docker-compose.yml`.
* `docker-compose exec servicio1 /bin/bash`: Ejecuta una orden, en este caso /bin/bash en un contenedor llamado servicio1 que estaba descrito en el `docker-compose.yml`
* `docker-compose build`: Ejecuta, si está indicado, el proceso de construcción de una imagen que va a ser usado en el `docker-compose.yml`  a partir de los  ficheros `Dockerfile` que se indican.
* `docker-compose top`: Muestra  los procesos que están ejecutándose en cada uno de los contenedores de los servicios.

## Despliegue de Let's Chat

Para desplegar la aplicación Let's Chat que vimos en el punto anterior, ejecutamos la siguiente instrucción en el directorio donde tengamos el fichero `docker-compose.yml`:

```bash
$ docker-compose up -d
Creating network "letschat_default" with the default driver
Creating mongo ... done
Creating letschat ... done
```

Podemos ver los contenedores que se están ejecutando:

```bash
$ docker-compose ps
  Name               Command             State               Ports             
-------------------------------------------------------------------------------
letschat   npm start                     Up      5222/tcp, 0.0.0.0:80->8080/tcp
mongo     docker-entrypoint.sh mongod   Up      27017/tcp                   
```

Podemos acceder desde el navegador a la aplicación:

![letschat](img/letschat.png)

Finalmente podemos destruir el escenario:

```bash
$ docker-compose down 
Stopping letschat ... done
Stopping mongo   ... done
Removing letschat ... done
Removing mongo   ... done
Removing network letschat_default
```

## Ejemplos reales de despliegues usando docker-compose

En la actualidad la mayoría de los despliegues reales que se hacen con docker, se realizan usando la herramienta *docker-compose*, veamos algunos ejemplos:

* **Despliegue de jitsi**: [Jitsi](https://meet.jit.si/) es una aplicación de videoconferencia, VoIP, y mensajería instantánea con aplicaciones nativas para iOS y Android, y con soporte para Windows, Linux y Mac OS X a través de la web.​ Es compatible con varios protocolos populares de mensajería instantánea y de telefonía, y se distribuye bajo los términos de la licencia Apache, por lo que es software libre y de código abierto. Podemos encontar las instrucciones para desplegarlo con docker en esta [página](https://github.com/jitsi/docker-jitsi-meet) y podemos acceder al fichero [docker-compose.yml](https://github.com/jitsi/docker-jitsi-meet/blob/master/docker-compose.yml).
* **Despliegue de las aplicaciones de Bitnami**: [Bitnami](https://bitnami.com/) es una empresa que nois proporciona distinta formas de despliegues de aplicaciones web en la nube. Una de estas formas es la utilización de docker, y podemos ver que [todas las aplicaciones](https://bitnami.com/stacks/containers) que nos ofrece Bitnami tienen el fichero `docker-compose.yml` para realizar el despliegue, por ejemplo podemos ver el [fichero](https://github.com/bitnami/bitnami-docker-prestashop/blob/master/docker-compose.yml) de la aplicación PrestaShop de Bitnami.
* **Despliegue de Guacamole**: [Apache Guacamole](https://guacamole.apache.org/) es un cliente (aplicación web HTML5) capaz de ofrecerte funcionalidades para acceso remoto a servidores y otros equipos remotos desde cualquier parte solo con la ayuda de una conexión y un navegador web. Podemos instalar [Guacamole con docker](https://guacamole.apache.org/doc/gug/guacamole-docker.html) y aunque en esa página no tenemos el fichero `docker-compse-yml` podemos encontrar ejemplos de muchos usuarios en [GitHub](https://github.com/boschkundendienst/guacamole-docker-compose/blob/master/docker-compose.yml).
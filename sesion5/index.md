---
layout: default
title: docker-compose
nav_order: 6
---
# Creando escenarios multicontenedor con docker-compose
{: .no_toc }

## Contenido
{: .no_toc .text-delta }

1. TOC
{:toc}

* [Presentación](https://raw.githubusercontent.com/josedom24/presentaciones/main/iaw/docker-compose.pdf)

Como visto hasta ahora en muchas ocasiones necesitamos correr varios contenedores para que nuestra aplicación funcione. En cualquiera de estos casos es necesario tener varios contenedores:

* Necesitamos varios servicios para que la aplicación funciones: Partiendo del principio de que cada contenedor ejecuta un sólo proceso, sii necesitamos que la aplicación use varios servicios (web, base de datos, proxy inverso, ...) cada uno de ellos se implementará en un contenedor.
* Si tenemos construida nuestra aplicación con microservicios, además cada microservicios se podrá implementar en un contenedor independiente.

Cuando trabajamos con escenarios donde necesitamos correr varios contenedores podemos utilizar [docker-compose](https://docs.docker.com/compose/) para gestionarlos.

Vamos a definir el escenario en un fichero llamado `docker-compose.yaml` y vamos a gestionar el ciclo de vida de la aplicaciones y de todos los contenedores que necesitamos con la utilidad `docker-compose`.

## Ventajas de usar docker-compose

* Hacer todo de manera **declarativa** para que no tenga que repetir todo el proceso cada vez que construyo el escenario.
* Poner en funcionamiento todos los contenedores que necesita mi aplicación de una sola vez y debidamente configurados.
* Garantizar que los contenedores **se arrancan en el orden adecuado**. Por ejemplo: Mi aplicación no podrá funcionar debidamente hasta que no esté el servidor de bases de datos funcionando en marcha.
* Asegurarnos de que hay **comunicación** entre los contenedores que pertenecen a la aplicación.

## Instalación de docker-compose

```bash
apt install docker-compose
```

También se puede con `pip` en un entorno virtual:

```bash
python3 -m venv docker-compose
source docker-compose/bin/activate
(docker-compose) ~# pip install docker-compose
```
## El fichero docker-compose.yml

En el fichero `docker-compose.yml` vamos a definir el escenario. El programa `docker-compose` se debe ejecutar en el directorio donde este ese fichero. Por ejemplo para la ejecución de wordpress persistente podríamos tener un fichero con el siguiente contenido:

```yaml
version: '3.1'

services:

  wordpress:
    container_name: servidor_wp
    image: wordpress
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: user_wp
      WORDPRESS_DB_PASSWORD: asdasd
      WORDPRESS_DB_NAME: bd_wp
    ports:
      - 80:80
    volumes:
      - /opt/wordpress:/var/www/html/wp-content
  db:
    container_name: servidor_mysql
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: bd_wp
      MYSQL_USER: user_wp
      MYSQL_PASSWORD: asdasd
      MYSQL_ROOT_PASSWORD: asdasd
    volumes:
      - /opt/mysql_wp:/var/lib/mysql
```

Puedes encontrar todos los parámetros que podemos definir en la [documentación oficial](https://docs.docker.com/compose/compose-file/compose-file-v3/).

Algunos parámetros interesantes:

* `restart: always`: Indicamos la política de reinicio del contenedor si por cualquier condición se para. [Más información](restart: always).
* `depend on`: Indica la dependencia entre contenedores. No se va a iniciar un contenedor hasta que otro este funcionando. [Más información](https://docs.docker.com/compose/compose-file/compose-file-v3/#depends_on).

Cuando creamos un escenario con `docker-compose` se crea una **nueva red definida por el usuario docker** donde se conectan los contenedores, por lo tanto, se pueden tenemos resolución por dns que resuelve tanto el nombre del contenedor (por ejemplo, `servidor_mysql`) como el alias (por ejemplo, `db`).

Para crear el escenario:

```bash
$ docker-compose up -d
Creating network "dc_default" with the default driver
Creating servidor_wp    ... done
Creating servidor_mysql ... done
```

Para listar los contenedores:

```bash
$ docker-compose ps
     Name                   Command               tate         Ports       
---------------------------------------------------------------------------
servidor_mysql   docker-entrypoint.sh mysqld      Up      306/tcp          
servidor_wp      docker-entrypoint.sh apach ...   Up      0.0..0:80-* `0/tcp`
```

Para parar los contenedores:

```bash
$ docker-compose stop 
Stopping servidor_wp    ... done
Stopping servidor_mysql ... done
```

Para borrar los contenedores:

```bash
$ docker-compose rm
Going to remove servidor_wp, servidor_mysql
Are you sure? [yN] y
Removing servidor_wp    ... done
Removing servidor_mysql ... done
```

## El comando docker-compose

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


## Ejercicios
{: .fs-9 }

1. Instala docker-compose en tu ordenador. Copia el fichero `docker-compose.yml` de la documentación de la imagen oficial de wordpress.
2. Modifica el `docker-compose.yml` para que use el puerto 8001.
3. Modifica el `docker-compose.yml`, para que la base de datos se llame db_wordpress.
4. Modifica el `docker-compose.yml` para usar bind mount en vez de volúmenes.
5. Levanta el escenario con `docker-compose`.
6. Muestra los contenedores con `docker-compose`.
7. Accede a la aplicación y comprueba que funciona.
8. Comprueba el almacenamiento que has definido y que se ha creado una nueva red de tipo bridge.
9. Borra el escenario con `docker-compose`.

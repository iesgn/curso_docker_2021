---
layout: default
title: "Ejemplo 1: Despliegue de la aplicación guestbook"
nav_order: 3
parent: Escenarios multicontenedor
---
# Ejemplo 1: Despliegue de la aplicación guestbook

En este ejemplo vamos a desplegar una aplicación web que requiere de dos servicios (servicio web y servicio de base de datos) para su ejecución. La aplicación se llama GuestBook y necesita los dos siguientes servicios:

    La aplicación guestbook es una aplicación web desarrollada en python que es servida por el puerto 5000/tcp. Utilizaremos la imagen `iesgn/guestbook`.
    Esta aplicación guarda la información en una base de datos no relacional redis, que utiliza el puerto 6379/tcp para conectarnos. Usaremos la imagen `redis`.


En el fichero `docker-compose.yml` vamos a definir el escenario. El programa `docker-compose` se debe ejecutar en el directorio donde este ese fichero. 

```yaml
version: '3.1'
services:
  app:
    container_name: guestbook
    image: iesgn/guestbook
    restart: always
    ports:
      - 80:5000
  db:
    container_name: redis
    image: redis
    restart: always
```

Puedes encontrar todos los parámetros que podemos definir en la [documentación oficial](https://docs.docker.com/compose/compose-file/compose-file-v3/).

Algunos parámetros interesantes:

* `restart: always`: Indicamos la política de reinicio del contenedor si por cualquier condición se para. [Más información](restart: always).

Cuando creamos un escenario con `docker-compose` se crea una **nueva red definida por el usuario docker** donde se conectan los contenedores, por lo tanto, se pueden tenemos resolución por dns que resuelve tanto el nombre del contenedor (por ejemplo, `redis`) como el alias (por ejemplo, `db`).

Para crear el escenario:

```bash
$ docker-compose up -d
Creating network "ubuntu_default" with the default driver
Creating guestbook ... done
Creating redis     ... done
```

Para listar los contenedores:

```bash
$ docker-compose ps
  Name                 Command               State          Ports        
-------------------------------------------------------------------------
guestbook   python3 app.py                   Up      0.0.0.0:80->5000/tcp
redis       docker-entrypoint.sh redis ...   Up      6379/tcp            
```

Para parar los contenedores:

```bash
$ docker-compose stop 
Stopping guestbook    ... done
Stopping redis ... done
```






Por ejemplo para la ejecución de wordpress persistente podríamos tener un fichero con el siguiente contenido:

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
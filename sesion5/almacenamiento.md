---
layout: default
title: "Almacenamiento con docker-compose"
nav_order: 5
parent: Escenarios multicontenedor
---

# Almacenamiento con docker-compose

## Definiendo volúmenes docker con docker-compose

Además de definir los `services`, con docker-compose podemos definir los volúmenes que vamos a necesitar en nuestra infraestructura. Además, como hemos visto, podremos indicar que volúmen va a utilizar cada contenedor.

Veamos un ejemplo:

```yaml
version: '3.1'
services:
  db:
    container_name: contenedor_mariadb
    image: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: asdasd
    volumes:
      - mariadb_data:/var/lib/mysql
volumes:
    mariadb_data:
```

Y podemos iniciar el escenario:

```bash
$ docker-compose up -d
Creating network "docker-compose_default" with the default driver
Creating volume "docker-compose_mariadb_data" with default driver
Creating contenedor_mariadb ... done

$ docker-compose ps
       Name                    Command             State    Ports  
-------------------------------------------------------------------
contenedor_mariadb   docker-entrypoint.sh mysqld   Up      3306/tcp
```

Y comprobamos que se ha creado un nuevo volumen:

```bash
$ docker volume ls
DRIVER    VOLUME NAME
local     docker-compose_mariadb_data
...
```

En la definición del servicio `db` hemos indicado que el contenedor montará el volumen en un directorio determinado con el parámetro `volumes`. Podemos comprobar que efectivamente se ha realizado el montaje:

```bash
$ docker inspect contenedor_mariadb
...
"Mounts": [
    {
        "Type": "volume",
        "Name": "docker-compose_mariadb_data",
        "Source": "/var/lib/docker/volumes/docker-compose_mariadb_data/_data",
        "Destination": "/var/lib/mysql",
        "Driver": "local",
        "Mode": "rw",
        "RW": true,
        "Propagation": ""
    }
],
...
```

Recuerda que si necesitas iniciar el escenario desde 0, debes eliminar el volumen:

```bash
$ docker-compose down -v
Stopping contenedor_mariadb ... done
Removing contenedor_mariadb ... done
Removing network docker-compose_default
Removing volume docker-compose_mariadb_data
```

## Utilización de bind mount con docker-compose

De forma similar podemos indicar que un contenedor va a utilizar bind mount como almacenamiento. En este caso sería:

```yaml
version: '3.1'
services:
  db:
    container_name: contenedor_mariadb
    image: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: asdasd
    volumes:
      - ./data:/var/lib/mysql
```

Y después de iniciar el escenario podemos ver cómo se ha creado el directorio `data`:

```bash
$ cd data/
/data$ ls
aria_log.00000001  aria_log_control  ibdata1  ib_logfile0  ibtmp1  mysql
```
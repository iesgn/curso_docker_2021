---
layout: default
title: "Uso de la red bridge por defecto"
nav_order: 5
parent: Redes
---
# Uso de la red bridge por defecto

Esta manera en enlazar contenedores no está recomendada y esta obsoleta. Además el uso de contenedores conectados a la red por defecto no está recomendado en entornos de producción. Para realizar este tipo de enlace vamos a usar el flag `--link`. **Si hemos comentado que no se suele usar. ¿Por qué lo vamos a explicar?**: La razón es que en la documentación de las imágenes en DockerHub se suele explicar el enlazado de contenedores usando esta opción.

Veamos un ejemplo, primero creamos un contenedor de mariadb:

```bash
$ docker run -d --name servidor_mariadb \
                -e MYSQL_DATABASE=mi_basededatos \
                -e MYSQL_USER=usuario \
                -e MYSQL_PASSWORD=asdasd \
                -e MYSQL_ROOT_PASSWORD=asdasd \
                mariadb
```

A continuación vamos a crear un nuevo contenedor, enlazado con el contenedor anterior:

```bash
$ docker run -d --name servidor_web --link servidor_mariadb:mariadb nginx
```

Para realizar la asociación entre contenedores (realmente estamos enlazando el contenedor `servidor_web` al `servidor_mariadb`) hemos utilizado el parámetro `--link`, donde se indica el nombre del contenedor enlazado y un alias por el que nos podemos referir a él. Normalmente las aplicaciones utilizan el nombre del alias que hemos indicado para conectarse al otro contenedor. En este tipo de enlace tenemos dos características:

* El contenedor al que hemos enlazado es conocido por resolución estática

El contenedor modifica el fichero `/etc/hosts` para que tengamos resolución estática del contenedor enlazado. Podemos comprobarlo:

```bash
$ docker exec servidor_web cat /etc/hosts
...
172.17.0.2	mariadb c76089892798 servidor_mariadb
```
Podemos comprobar que el servidor DNS del contenedor, es el mismo que tiene nuestro host, por lo tanto la resolución no se hace desde un servidor DNS:

```bash
$ docker exec servidor_web cat /etc/resolv.conf
...
nameserver 192.168.121.1
```

El servidor DNS `192.168.121.1` es el que tiene configurado mi ordenador donde tengo instalado docker.

 * Se comparten las variables de entorno

Las variables de entorno del contenedor enlazado son accesibles desde el contenedor. Por cada asociación de contenedores, docker crea una serie de variables de entorno, en este caso, en el contenedor servidor, se crearán las siguientes variables, donde se utiliza el nombre del alias indicada en el parámetro `--link`:

```bash
$ docker exec servidor_web env
...
MARIADB_PORT=tcp://172.17.0.2:3306
MARIADB_PORT_3306_TCP=tcp://172.17.0.2:3306
MARIADB_PORT_3306_TCP_ADDR=172.17.0.2
MARIADB_PORT_3306_TCP_PORT=3306
MARIADB_PORT_3306_TCP_PROTO=tcp
MARIADB_NAME=/servidor/mariadb
MARIADB_ENV_MYSQL_USER=usuario
MARIADB_ENV_MYSQL_PASSWORD=asdasd
MARIADB_ENV_MYSQL_ROOT_PASSWORD=asdasd
MARIADB_ENV_MYSQL_DATABASE=mi_basededatos
MARIADB_ENV_GOSU_VERSION=1.10
MARIADB_ENV_GPG_KEYS=177F4010FE56CA3336300305F1656F24C74CD1D8
MARIADB_ENV_MARIADB_MAJOR=10.4
MARIADB_ENV_MARIADB_VERSION=1:10.4.11+maria~bionic
```


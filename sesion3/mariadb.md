---
layout: default
title: "Ejemplo 2: Contenedor mariadb con almacenamiento persistente"
nav_order: 7
parent: Almacenamiento
---

# Contenedor mariadb con almacenamiento persistente

Si estudiamos la documentación de la [imagen mariadb](https://hub.docker.com/_/mariadb) en Docker Hub, nos indica que podemos crear un contenedor con información persistente de mariadb, de la siguiente forma:

```bash
$ docker run --name some-mariadb -v /home/vagrant/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
```

Es decir se va a crear un directorio `/home/usuario/datadir` en el host, donde se va a guardar la información de la base de datos. Si tenemos que crear de nuevo el contenedor indicaremos ese directorio como bind mount y volveremos a tener accesible la información.

```bash
$ cd datadir/
~/datadir$ ls
aria_log.00000001  aria_log_control  ib_buffer_pool  ib_logfile0  ibdata1  ibtmp1  multi-master.info  mysql  performance_schema

$ docker exec -it some-mariadb bash -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD'
...
MariaDB [(none)]> create database prueba;
MariaDB [(none)]> quit

$ docker rm -f some-mariadb 
some-mariadb

$ docker run --name some-mariadb -v /home/vagrant/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
f36589090dd33b116da87e599850b1f25c9ae40e4b28c036c23e602d7bde4cc5

$ docker exec -it some-mariadb bash -c 'mysql -uroot -p$MYSQL_ROOT_PASSWORD'
...
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| prueba             |
+--------------------+
4 rows in set (0.003 sec)
```

## ¿Qué información tenemos que guardar?

Para terminar: ¿Qué debemos guardar de forma persistente en un contenedor?

* Los datos de la aplicación
* Los logs del servicio
* La configuración del servicio: En este caso podemos añadirla a la imagen, pero será necesaria la creación de una nueva imagen si cambiamos la configuración. Si la guardamos en un volumen hay que tener en cuanta que ese fichero lo tenemos que tener en el entorno de producción (puede ser bueno, porque las configuraciones de los distintos entornos puede variar).

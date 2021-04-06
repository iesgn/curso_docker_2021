---
layout: default
title: Configuración de contenedores con variables de entorno
nav_order: 8
parent: Introducción
---

# Configuración de contenedores con variables de entorno

Más adelante veremos que al crear un contenedor que necesita alguna configuración específica, lo que vamos a hacer es crear variables de entorno en el contenedor, para que el proceso que inicializa el contenedor pueda realizar dicha configuración.

Para crear una variable de entorno al crear un contenedor usamos el flag `-e` o `--env`:

```bash
$ docker run -it --name prueba -e USUARIO=prueba ubuntu bash
root@91e81200c633:/# echo $USUARIO
prueba
```

## Configuración de un contenedor con la imagen mariadb

En ocasiones es obligatorio el inicializar alguna variable de entorno para que el contenedor pueda ser ejecutado. Si miramos la [documentación](https://hub.docker.com/_/mariadb) en Docker Hub de la imagen mariadb, observamos que podemos definir algunas variables de entorno para la creación y configuración del contenedor (por ejemplo: `MYSQL_DATABASE`,`MYSQL_USER`, `MYSQL_PASSWORD`,...). Pero hay una que la tenemos que indicar de forma obligatoria, la contraseña del usuario `root` (`MYSQL_ROOT_PASSWORD`), por lo tanto:

```bash
$ docker run -d --name some-mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw mariadb
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED                STATUS              PORTS               NAMES
9c3effd891e3        mariadb             "docker-entrypoint.s…"   8 seconds ago       Up 7   seconds        3306/tcp            some-mariadb
```

Podemos ver que se ha creado una variable de entorno:

```bash
$ docker exec -it some-mariadb env
...
MYSQL_ROOT_PASSWORD=my-secret-pw
...
```

Y para acceder podemos ejecutar:

```bash
$ docker exec -it some-mariadb bash                                  
root@9c3effd891e3:/# mysql -u root -p"$MYSQL_ROOT_PASSWORD" 
...

MariaDB [(none)]> 
```
Otra forma de hacerlo sería:

```bash
$ docker exec -it some-mariadb mysql -u root -p
Enter password: 
...
MariaDB [(none)]> 
```

### Accediendo a servidor de base de datos desde el exterior

En el ejemplo anterior hemos accedido a la base de datos de dos formas: 

1. Ejecutado un comando `bash` para acceder al contenedor y desde dentro hemos utilizado el cliente de mariadb para acceder a la base de datos.
2. Ejecutando directamente en el contenedor el cliente de mariadb.

En esta ocasión vamos a mapear los puertos para acceder desde el exterior a la base de datos:

Lo primero que vamos a hacer es eliminar el contenedor anterior:

```bash 
$ docker rm -f some-mariadb
```

Y a continuación vamos a crear otro contenedor, pero en esta ocasión vamos a mapear el puerto 3306 del anfitrión con el puerto 3306 del contenedor:

```bash 
docker run -d -p 3306:3306 --name some-mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw mariadb
```

Comprobamos que los puertos se han mapeado y que el contenedor está ejecutándose:

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
816ea7df5c41        mariadb             "docker-entrypoint.s…"   3 seconds ago       Up 2 seconds        0.0.0.0:3306->3306/tcp   some-mariadb
```

Ahora desde nuestro equipo (donde hemos instalado un cliente de mysql) nos conectamos  que tiene la ip `192.168.121.54` vamos a conectarnos a la base de datos (hay que tener instalado el cliente de mariadb):

```bash
$ mysql -u root -p -h 192.168.121.54
Enter password: 
...
MariaDB [(none)]> 
```

También nos podemos conectar usando la dirección `127.0.0.1`:

```bash
$ mysql -u root -p -h 127.0.0.1
Enter password: 
...
MariaDB [(none)]> 
```

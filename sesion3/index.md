---
layout: default
title: Almacenamiento
nav_order: 3
---
# Almacenamiento en docker
{: .no_toc }

## Contenido
{: .no_toc .text-delta }

1. TOC
{:toc}

* [Presentación](https://raw.githubusercontent.com/josedom24/presentaciones/main/iaw/almacenamiento_docker.pdf)

## Los contenedores son efímeros

**Los contenedores son efímeros**, es decir, los ficheros, datos y configuraciones que creamos en los contenedores sobreviven a las paradas de los mismos pero, sin embargo, son destruidos si el contenedor es destruido. 

Veamos un ejemplo:

```bash
$ docker run -d --name my-apache-app -p 8080:80 httpd:2.4
ac50cc24ef71ae0263be7794278600d5cc4f085b88cebbf97b7b268212f2a82f
    
$ docker exec my-apache-app bash -c 'echo "<h1>Hola</h1>" > htdocs/index.html'
    
$ curl http://localhost:8080
<h1>Hola</h1>
    
$ docker rm -f my-apache-app
my-apache-app
    
$ docker run -d --name my-apache-app -p 8080:80 httpd:2.4
bb94716205c780ec4a3a2695722fb35ac616ae4cea573308d9446208afb164dc
    
$ curl http://localhost:8080
<html><body><h1>It works!</h1></body></html>
```

Vemos como al eliminar el contenedor, la información que habíamos guardado en el fichero `index.html` se pierde, y al crear un nuevo contenedor ese fichero tendrá el contenido original.

> NOTA: En la instrucción `docker exec` hemos ejecutado el comando con `bash -c` qie nos permite ejecutar uno o mas comandos en el contenedor de forma más compleja (por ejemplo, indicando ficheros dentro del contenedor).

## Los datos en los contenedores

![docker](img/types-of-mounts.png)

Ante la situación anteriormente descrita Docker nos proporciona varias soluciones para persistir los datos de los contenedores. En este curso nos vamos a centrar en las dos que considero que son más importantes:

* Los **volumenes docker**.
* Los **bind mount**
* Loa **tmpfs mounts**: Almacenan en memoria la información. (No lo vamos a ver ene este curso)

## Volúmenes docker y bind mount

* **Volúmenes docker**: Si elegimos conseguir la persistencia usando volúmenes estamos haciendo que los datos de los contenedores que nosotros decidamos se almacenen en una parte del sistema de ficheros que es gestionada por docker y a la que, debido a sus permisos, sólo docker tendrá acceso. En linux se guardan en `/var/lib/docker/volumes`. Este tipo de volúmenes se suele usar en los siguiente casos:

    * Para compartir datos entre contenedores. Simplemente tendrán que usar el mismo volumen.
    * Para copias de seguridad ya sea para que sean usadas posteriormente por otros contenedores o para mover esos volúmenes a otros hosts.
    * Cuando quiero almacenar los datos de mi contenedor no localmente si no en un proveedor cloud.

* **Bind mounts**: Si elegimos conseguir la persistencia de los datos de los contenedores usando bind mount lo que estamos haciendo es "mapear" (montar) una parte de mi sistema de ficheros, de la que yo normalmente tengo el control, con una parte del sistema de ficheros del contenedor. De esta manera conseguimos:
    * Compartir ficheros entre el host y los containers.
    * Que otras aplicaciones que no sean docker tengan acceso a esos ficheros, ya sean código, ficheros etc...

## Gestionando volúmenes

Algunos comando útiles para trabajar con volúmenes docker:

* **docker volumen create**: Crea un volumen con el nombre indicado.
* **docker volume rm**: Elimina el volumen indicado.
* **docker volumen prune**: Para eliminar los volúmenes que no están siendo usados por ningún contenedor.
* **docker volume ls**: Nos proporciona una lista de los volúmenes creados y algo de información adicional.
* **docker volume inspect**: Nos dará una información mucho más detallada de el volumen que hayamos elegido.

## Asociando almacenamiento a los contenedores

Veamos como puedo usar los volúmenes y los bind mounts en los contenedores. Para cualquiera de los dos casos lo haremos mediante el uso de dos flags de la orden `docker run`:

* El flag `--volume` o `-v`
* El flag `--mount`

Es importante que tengamos en cuenta dos cosas importantes a la hora de realizar estas operaciones:

* Al usar tanto volúmenes como bind mount, el contenido de lo que tenemos sobreescribirá la carpeta destino en el sistema de ficheros del contenedor en caso de que exista.
* Si nuestra carpeta origen no existe y hacemos un bind mount esa carpeta se creará pero lo que tendremos en el contenedor es una carpeta vacía. 
* Si usamos imágenes de DockerHub, debemos leer la información que cada imagen nos proporciona en su página ya que esa información suele indicar cómo persistir los datos de esa imagen, ya sea con volúmenes o bind mounts, y cuáles son las carpetas importantes en caso de ser imágenes que contengan ciertos servicios (web, base de datos etc...)

### Ejemplo usando volúmenes docker

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

### Ejemplo usando bind mount

En este caso vamos a crear un directorio en el sistema de archivo del host, donde vamos a crear un fichero `index.html`:

```bash
$ mkdir web
$ cd web
/web$ echo "<h1>Hola</h1>" > index.html

$ docker run -d --name my-apache-app -v /home/usuario/web:/usr/local/apache2/htdocs -p 8080:80 httpd:2.4
8de025f6ff4d4b8a5a57d10a9cbb283b103209f358c43148a4716a33a404e208

$ curl http://localhost:8080
<h1>Hola</h1>

$ docker rm -f my-apache-app 
my-apache-app

$ docker run -d --name my-apache-app --mount type=bind,src=/home/usuario/web,dst=/usr/local/apache2/htdocs -p 8080:80 httpd:2.4
1751b04b0548217d7faa628fd69c10e84c695b0e5cc33b482df2c04a6af83292

$ curl http://localhost:8080
<h1>Hola</h1>
```

Además podemos comprobar que podemos modificar el contenido del fichero aunque este montado en el contenedor:

```bash
$ echo "<h1>Adios</h1>" > web/index.html 
$ curl http://localhost:8080
<h1>Adios</h1>
```

## Ejercicio: Contenedor mariadb con almacenamiento persistente

Si estudiamos la documentación de la [imagen mariadb](https://hub.docker.com/_/mariadb) en Docker Hub, nos indica que podemos crear un contenedor con información persistente de maridb, de la siguiente forma:

```bash
$ docker run --name some-mariadb -v /home/usuario/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
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

## Ejercicios
{: .fs-9 }

1. Vamos a trabajar con volúmenes docker:
    * Crea un volumen docker que se llame `miweb`.
    * Crea un contenedor desde la imagen `php:7.4-apache` donde montes en el directorio `/var/www/html` (que sabemos que es el docuemntroot del servidor que nos ofrece esa imagen) el volumen docker que has creado.
    * Utiliza el comando `docker cp` para copiar un fichero `info.php` en el directorio `/var/www/html`.
    * Accede al contenedor desde el navegador para ver la información ofrecida por el fichero `info.php`.
    * Borra el contenedor
    * Crea un nuevo contenedor y monta el mismo volumen como en el ejercicio anterior.
    * Accede al contenedor desde el navegador para ver la información ofrecida por el fichero `info.php`. ¿Seguía existiendo ese fichero?
2. Vamos a trabajar con bind mount:
    * Crea un directorio en tu host y dentro crea un fichero `index.html`.
    * Crea un contenedor desde la imagen `php:7.4-apache` donde montes en el directorio `/var/www/html` el directorio que has creado por medio de `bind mount`.
    * Accede al contenedor desde el navegador para ver la información ofrecida por el fichero `index.html`.
    * Modifica el contenido del fichero `index.html` en tu host y comprueba que al refrescar la página ofrecida por el contenedor, el contenido ha cambiado.
    * Borra el contenedor
    * Crea un nuevo contenedor y monta el mismo directorio como en el ejercicio anterior.
    * Accede al contenedor desde el navegador para ver la información ofrecida por el fichero `index.html`. ¿Se sigue viendo el mismo contenido?
3. Contenedores con almacenamiento persistente
    * Crea un contenedor desde la imagen `nextcloud` (usando sqlite) configurando el almacenamiento como nos muestra la documentación de la imagen en Docker Hub (pero utilizando bind mount). Sube algún fichero.
    * Elimina el contenedor.
    * Crea un contenedor nuevo con la misma configuración de volúmenes. Comprueba que la información que teníamos (ficheros, usuario, ...), sigue existiendo.
    * Comprueba el contenido de directorio que se ha creado en el host.


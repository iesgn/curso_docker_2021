---
layout: default
title: Introducción
nav_order: 2
has_children: true
---

# Introducción a los contenedores y a Docker
{: .no_toc }

## Contenido
{: .no_toc .text-delta }

1. TOC
{:toc}


* [Presentación](https://raw.githubusercontent.com/josedom24/presentaciones/main/iaw/introduccion_docker.pdf)

## Introducción a docker

Docker es una tecnología de virtualización "ligera" cuyo elemento básico es la utilización de contenedores en vez de máquinas virtuales y cuyo objetivo principal es el despliegue de aplicaciones encapsuladas en dichos contenedores.

Docker está formado por varios componentes:

* **Docker Engine**: Es un demonio que corre sobre cualquier distribución de Linux y que expone una API externa para la gestión de imágenes y contenedores. Con ella podemos crear imágenes, subirlas y bajarla de un registro de docker y ejecutar y gestionar contenedores.
* **Docker Client**: Es el cliente de línea de comandos (CLI) que nos permite gestionar el Docker Engine. El cliente docker se puede configurar para trabajar con con un Docker Engine local o remoto, permitiendo gestionar tanto nuestro entorno de desarrollo local, como nuestro entorno de producción.
* **Docker Registry**: La finalidad de este componente es almacenar las imágenes generadas por el Docker Engine. Puede estar instalada en un servidor independiente y es un componente fundamental, ya que nos permite distribuir nuestras aplicaciones. Es un proyecto open source que puede ser instalado gratuitamente en cualquier servidor, pero, como hemos comentado, el proyecto nos ofrece **Docker Hub**.



## El "Hola Mundo" de docker

Vamos a comprobar que todo funciona creando nuestro primer contenedor desde la imagen `hello-world`:

```bash
$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete 
Digest:     sha256:31b9c7d48790f0d8c50ab433d9c3b7e17666d6993084c002c2ff1ca09b96391d
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working     correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs    the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which  sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

Pero, ¿qué es lo que está sucediendo al ejecutar esa orden?:

* Al ser la primera vez que ejecuto un contenedor basado en esa imagen, la imagen `hello-word` se descarga desde el repositorio que se encuentra en el registro que vayamos a utilizar, en nuestro caso DockerHub.
* Muestra el mensaje de bienvenida que es la consecuencia de crear y arrancar un contenedor basado en esa imagen.

Si listamos los contenedores que se están ejecutando (`docker ps`):

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
Comprobamos que este contenedor no se está ejecutando. **Un contenedor ejecuta un proceso y cuando termina la ejecución, el contenedor se para.**

Para ver los contenedores que no se están ejecutando:

```bash
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
372ca4634d53        hello-world         "/hello"            8 minutes ago       Exited (0) 8 minutes ago                       elastic_johnson
```

Para eliminar el contenedor podemos identificarlo con su `id`:

```bash
$ docker rm 372ca4634d53
```

o con su nombre:

```bash
$ docker rm elastic_johnson
```

Otro ejemplo:

```bash
$ docker run ubuntu /bin/echo 'Hello world' 
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
8387d9ff0016: Pull complete 
...
Status: Downloaded newer image for ubuntu:latest
Hello world
```

Con el comando `run` vamos a crear un contenedor donde vamos a ejecutar un comando, en este caso vamos a crear el contenedor a partir de una imagen ubuntu. Como todavía no hemos descargado ninguna imagen del registro docker hub, es necesario que se descargue la  imagen. Si la tenemos ya en nuestro ordenador no será necesario la descarga. 

Comprobamos que el contenedor ha ejecutado el comando que hemos indicado y se parado:

```bash
$ docker ps -a
CONTAINER ID        IMAGE              COMMAND                  CREATED               STATUS                      PORTS               NAMES
3bbf39d0ec26        ubuntu              "/bin/echo 'Hello wo…"   31 seconds ago      Exited     (0) 29 seconds ago                       wizardly_edison
```

Con el comando `docker images` podemos visualizar las imágenes que ya tenemos descargadas en nuestro registro local:

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID           CREATED             SIZE
ubuntu              latest              f63181f19b2f        7 days ago          72.9MB
hello-world         latest              bf756fb1ae65        13 months ago       13.3kB
```

## Ejecutando un contenedor interactivo

En este caso usamos la opción `-i` para abrir una sesión interactiva, `-t` nos permite crear un pseudo-terminal que nos va a permitir interaccionar con el contenedor, indicamos un nombre del contenedor con la opción `--name`, y la imagen que vamos a utilizar para crearlo, en este caso `ubuntu`,  y por último el comando que vamos a ejecutar, en este caso `/bin/bash`, que lanzará una sesión bash en el contenedor:

```bash
$  docker run -it --name contenedor1 ubuntu /bin/bash 
root@2bfa404bace0:/#
```

El contenedor se para cuando salimos de él. Para volver a conectarnos a él:

```bash
$ docker start contendor1
contendor1
$ docker attach contendor1
root@2bfa404bace0:/#
```

Si el contenedor se está ejecutando podemos ejecutar comando en él con el subcomando `exec`:

```bash
$ docker start contendor1
contendor1
$ docker exec contenedor1 ls -al
```

Con la orden `docker restart` reiniciamos el contendor, lo paramos y lo iniciamos.

Para mostrar información de un contenedor ejecutamos `docker inspect`:

```bash
$ docker inspect contenedor1 
[
    {
        "Id": "178871769ac2fcbc1c73ce378066af01436b52a15894685b7321088468a25db7",
        "Created": "2021-01-28T19:12:21.764255155Z",
        "Path": "/bin/bash",
        "Args": [],
        "State": {
            "Status": "exited",
            "Running": false,
            "Paused": false,
            ...
```

Nos muestra mucha información, está en formato JSON (JavaScript Object Notation) y nos da datos sobre aspectos como:

* El id del contenedor.
* Los puertos abiertos y sus redirecciones
* Los *bind mounts* y volúmenes usados.
* El tamaño del contenedor
* La configuración de red del contenedor.
* El *ENTRYPOINT* que es lo que se ejecuta al hacer docker run.
* El valor de las variables de entorno.
* Y muchas más cosas....

En realidad, todas las imágenes tienen definidas un proceso que se ejecuta, en concreto la imagen `ubuntu` tiene definida por defecto el proceso `bash`, por lo que podríamos haber ejecutado:

```bash
$ docker run -it --name contenedor1 ubuntu
```

## Creando un contenedor demonio

En esta ocasión hemos utilizado la opción `-d` del comando `run`, para que la ejecución del comando en el contenedor se haga en segundo plano.

```bash
$ docker run -d --name contenedor2 ubuntu /bin/sh -c "while true; do echo hello world; sleep 1; done"
7b6c3b1c0d650445b35a1107ac54610b65a03eda7e4b730ae33bf240982bba08
```

* Comprueba que el contenedor se está ejecutando
* Comprueba lo que está haciendo el contenedor (`docker logs contenedor2`)

Por último podemos parar el contenedor y borrarlo con las siguientes instrucciones:

```bash
$ docker stop contenedor2
$ docker rm contenedor2
```

Hay que tener en cuenta que un contenedor que esta ejecutándose no puede ser eliminado. Tendríamos que para el contenedor y posteriormente borrarlo. Otra opción es borrarlo a la fuerza:

```bash
$ docker rm -f contenedor2
```

## Creando un contenedor con un servidor web

Tenemos muchas imágenes en el registro público **docker hub**, por ejemplo podemos crear un servidor web con apache 2.4:

```bash
$ docker run -d --name my-apache-app -p 8080:80 httpd:2.4
```

Vemos que el contenedor se está ejecutando, además con la opción `-p` mapeamos un puerto del equipo donde tenemos instalado el docker, con un puerto del contenedor.  Para probarlo accede desde un navegador a la ip del servidor con docker y al puerto 8080.

Para acceder al log del contenedor podemos ejecutar:

```bash
$ docker logs my-apache-app
```

Con la opción `logs -f` seguimos visualizando los logs en tiempo real.

## Configuración de contenedores con variables de entorno

Más adelante veremos que al crear un contenedor que necesita alguna configuración específica, lo que vamos a hacer es crear variables de entorno en el contenedor, para que el proceso que inicializa el contenedor pueda realizar dicha configuración.

Para crear una variable de entorno al crear un contenedor usamos el flag `-e` o `--env`:

```bash
$ docker run -it --name prueba -e USUARIO=prueba ubuntu bash
root@91e81200c633:/# echo $USUARIO
prueba
```

En ocasiones es obligatorio el inicializar alguna variable de entorno para que el contenedor pueda ser ejecutado. si miramos la [documentación](https://hub.docker.com/_/mariadb) en Docker Hub de la imagen mariadb, observamos que podemos definir algunas variables de entorno para la creación del contenedor (por ejemplo: `MYSQL_DATABASE`,`MYSQL_USER`, `MYSQL_PASSWORD`,...). Pero hay una que la tenemos que indicar de forma obligatoria, la contraseña del usuario `root` (`MYSQL_ROOT_PASSWORD`), por lo tanto:

```bash
$ docker run --name some-mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb
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
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 21
Server version: 10.5.8-MariaDB-1:10.5.8+maria~focal mariadb.org binary distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> 
```

## Ejercicios
{: .fs-9 }

1. Instala docker en una máquina y configuralo para que se pueda usar con un usuario sin privilegios.
2. Crea un contenedor interactivo desde una imagen debian. Instala un paquete (por ejemplo `nano`). Sal de la terminal, ¿sigue el contenedor corriendo? ¿Por qué?. Vuelve a iniciar el contenedor y accede de nuevo a él de forma interactiva. ¿Sigue instalado el `nano`?. Sal del contenedor, y borralo. Crea un nuevo contenedor interactivo desde la misma imagen. ¿Tiene el `nano` instalado?
3. Crea un contenedor demonio con un servidor nginx, usando la imagen oficial de nginx. Al crear el contenedor, ¿has tenido que indicar algún comando para que lo ejecute? Accede al navegador web y comprueba que el servidor esta funcionando. Muestra los logs del contenedor.
4. Crea un contenedor con la aplicación Nextcloud, mirando la documentación en docker Hub, para personalizar el nombre de la base de datos sqlite que va a utilizar.




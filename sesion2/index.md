---
layout: default
title: Imágenes
nav_order: 3
---
# Imágenes docker
{: .no_toc }

## Contenido
{: .no_toc .text-delta }

1. TOC
{:toc}


* [Presentación](https://raw.githubusercontent.com/josedom24/presentaciones/main/iaw/imagenes_docker.pdf)

## Registros de imágenes: Docker Hub

![docker](img/docker2.png)

Las imágenes de Docker son plantillas de solo lectura, es decir, una imagen puede contener el sistema de archivo de un sistema operativo como Debian, pero esto solo nos permitirá crear los contenedores basados en esta configuración. Si hacemos cambios en el contenedor ya lanzado, al detenerlo esto no se verá reflejado en la imagen.

El **Registro docker** es un componente donde se almacena las imágenes generadas por el Docker Engine. Puede estar instalada en un servidor independiente y es un componente fundamental, ya que nos permite distribuir nuestras aplicaciones. Es un proyecto open source que puede ser instalado gratuitamente en cualquier servidor, pero, como hemos comentado, el proyecto nos ofrece Docker Hub.

El nombre de una imagen suele estar formado por tres partes:

    usuario/nombre:etiqueta

* `usuario`: El nombre del usuario que la ha generado. Si la subimos a Docker Hub debe ser el mismo usuario que tenemos dado de alta en nuestra cuenta. Las **imáges oficiales** en Docker Hub no tienen nombre de usuario.
* `nombre`: Nombre significativo de la imagen.
* `etiqueta`: Nos permite versionar las imágenes. De esta manera controlamos los cambios que se van produciendo en ella. Si no indicamos etiqueta, por defecto se usa la etiqueta `latest`, por lo que la mayoría de las imágenes tienen una versión con este nombre.


## Gestión de imágenes

Para crear un contenedor es necesario usar una imagen que tengamos descargado en nuestro registro local. Por lo tanto al ejecutar `docker run` se comprueba si tenemos la versión indicada de la imagen y si no es así, se precede a su descarga.

Las principales instrucciones para trabajar con imágenes son:

* `docker images`: Muestra las imágenes que tenemos en el registro local.
* `docker pull`: Nos permite descargar la última versión de la imagen indicada.
* `docker rmi`: Nos permite eliminar imágenes. No podemos eliminar una imágen si tenemos algún contenedor creada a partir de ella.
* `docker search`: Busca imágenes en Docker Hub.
* `docker inspect`: nos da información sobre la imágen indicada:
    * El id y el checksum de la imagen.
    * Los puertos abiertos.
    * La arquitectura y el sistema operativo de la imagen.
    * El tamaño de la imagen.
    * Los volúmenes.
    * El ENTRYPOINT que es lo que se ejecuta al hacer `docker run`.
    * Las capas.
    * Y muchas más cosas....


## ¿Cómo se organizan las imágenes?

Las imágenes están hechas de **capas ordenadas**. Puedes pensar en una capa como un conjunto de cambios en el sistema de archivos. Cuando tomas todas las capas y las apilas, obtienes una nueva imagen que contiene todos los cambios acumulados. 

Si tienes muchas imágenes basadas en capas similares, como Sistema Operativo base o paquetes comunes, entonces todas éstas capas comunes será almacenadas solo una vez.

![docker](img/container-layers.jpg)

Cuando un nuevo contenedor es creado desde una imagen, todas las capas de la imagen son únicamente de lectura y una delgada capa lectura-escritura es agregada arriba. Todos los cambios efectuados al contenedor específico son almacenados en esa capa. 

El contenedor no puede modificar los archivos desde su capa de imagen (que es sólo lectura). Creará una copia del fichero en su capa superior, y desde ese punto en adelante, cualquiera que trate de acceder al archivo obtendrá la copia de la capa superior. 

![docker](img/sharing-layers.jpg)

Por lo tanto cuando creamos un contenedor ocupa muy poco de disco duro, porque las capas de la imagen desde la que se ha creado se comparten con el contenedor:

Veamos el tamaño de nuestra imagen `ubuntu`:

    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    ubuntu              latest              f63181f19b2f        7 days ago          72.9MB

Si creamos un contenedor interactivo:

    $ docker run -it --name contenedor1 ubuntu /bin/bash 

Nos salimos, y a continuación visualizamos los contenedores con la opción `-s` (size):

    $ docker ps -a -s
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                       PORTS               NAMES               SIZE
    a2d1ce6990d8        ubuntu              "/bin/bash"              8 seconds ago       Exited (130) 5 seconds ago                       contenedor1         0B (virtual 72.9MB)

Nos damos cuenta que el tamaño real del contenedor es 0B y el virtual, el que comparte con la imagen son los 72,9MB que es el tamaño de la imagen ubuntu.

Si a continuación volvemos a acceder al contenedor y creamos un fichero:

    $ docker start contenedor1
    contenedor1
    $ docker attach contenedor1
    root@a2d1ce6990d8:/# echo "00000000000000000">file.txt

Y volvemos a ver el tamaño, vemos que ha crecido con la creación del fichero:

    $ docker ps -a -s
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES               SIZE
    a2d1ce6990d8        ubuntu              "/bin/bash"              56 seconds ago      Exited (0) 2 seconds ago                        contenedor1         52B (virtual 72.9MB)

Por todo lo que hemos explicado, ahora se entiende  que **no podemos eliminar una imágen cuando tenemos contendores creados a aprtir de ella**.

Por último al solicitar información de la imágen, podemos ver información sobre las capas:

    $ docker inspect ubuntu:latest
    ...
    "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:9f32931c9d28f10104a8eb1330954ba90e76d92b02c5256521ba864feec14009",
                "sha256:dbf2c0f42a39b60301f6d3936f7f8adb59bb97d31ec11cc4a049ce81155fef89",
                "sha256:02473afd360bd5391fa51b6e7849ce88732ae29f50f3630c3551f528eba66d1e"
            ]
    ...

## Creación de instancias desde imágenes

Si navegas un poco por las distintas imágenes que encuentras en el registro de Docker Hub, te darás cuenta, que existen dos tipos de imágenes según la utilidad que nos ofrecen.

* Ejecutaremos contenedores de distintos sistemas operativos (Ubuntu, CentOs, Debian, Fedora....).
* Ejecutaremos contenedores que tengan servicios asociados (Apache, MySQL, Tomcat....).

Todas las imágenes tiene definidas un proceso que se ejecuta por defecto, pero en la mayoría de los casos podemos indicar un proceso al crear un contenedor.

Por ejemplo en la imagen `ubuntu` el proceso pode defecto es `bash`, por lo tanto podemos ejecutar:

    $  docker run -it --name contenedor1 ubuntu 

Pero podemos indicar el comando a ejecutar en la creación del contenedor:

    $ docker run ubuntu /bin/echo 'Hello world'

Otro ejemplo: la imagen `httpd:2.4` ejecuta un servidor web por defecto, por lo tanto al crear el contenedor:

    $ docker run -d --name my-apache-app -p 8080:80 httpd:2.4


## Ejercicios
{: .fs-9 }

1. Descarga las siguientes imágenes: `ubuntu:18.04`, `httpd`, `tomcat:9.0.39-jdk11`, `jenkins/jenkins:lts`, `php:7.4-apache`.
2. Muestras las imágenes que tienes descargadas.
3. Crea un contenedor demonio con la imagen php:7.4-apache.
4. Comprueba el tamaño del contenedor en el disco duro.
5. Con la instrucción `docker cp` podemos copiar ficheros a o desde un contenedor. Copia un fichero `info.php` al directorio `/var/www/html` del contenedor.
6. Vuelve a comprobar el espacio ocupado por el contenedor.
7. Accede al fichero `info.php` desde un navegador web.



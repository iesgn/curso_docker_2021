---
layout: default
title: ¿Cómo se organizan las imágenes?
nav_order: 4
parent: Imágenes
---

# ¿Cómo se organizan las imágenes?

Las imágenes están hechas de **capas ordenadas**. Puedes pensar en una capa como un conjunto de cambios en el sistema de archivos. Cuando tomas todas las capas y las apilas, obtienes una nueva imagen que contiene todos los cambios acumulados. 

Si tienes muchas imágenes basadas en capas similares, como Sistema Operativo base o paquetes comunes, entonces todas éstas capas comunes será almacenadas solo una vez.

![docker](img/container-layers.jpg)

Cuando un nuevo contenedor es creado desde una imagen, todas las capas de la imagen son únicamente de lectura y una delgada capa lectura-escritura es agregada arriba. Todos los cambios efectuados al contenedor específico son almacenados en esa capa. 

El contenedor no puede modificar los archivos desde su capa de imagen (que es sólo lectura). Creará una copia del fichero en su capa superior, y desde ese punto en adelante, cualquiera que trate de acceder al archivo obtendrá la copia de la capa superior. 

![docker](img/sharing-layers.jpg)

Por lo tanto cuando creamos un contenedor ocupa muy poco de disco duro, porque las capas de la imagen desde la que se ha creado se comparten con el contenedor:

Veamos el tamaño de nuestra imagen `ubuntu`:

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              f63181f19b2f        7 days ago          72.9MB
```

Si creamos un contenedor interactivo:

```bash
$ docker run -it --name contenedor1 ubuntu /bin/bash 
```

Nos salimos, y a continuación visualizamos los contenedores con la opción `-s` (size):

```bash
$ docker ps -a -s
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                       PORTS               NAMES               SIZE
a2d1ce6990d8        ubuntu              "/bin/bash"              8 seconds ago       Exited (130) 5 seconds ago                       contenedor1         0B (virtual 72.9MB)
```

Nos damos cuenta que el tamaño real del contenedor es 0B y el virtual, el que comparte con la imagen son los 72,9MB que es el tamaño de la imagen ubuntu.

Si a continuación volvemos a acceder al contenedor y creamos un fichero:

```bash
$ docker start contenedor1
contenedor1
$ docker attach contenedor1
root@a2d1ce6990d8:/# echo "00000000000000000">file.txt
```

Y volvemos a ver el tamaño, vemos que ha crecido con la creación del fichero:

```bash
$ docker ps -a -s
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES               SIZE
a2d1ce6990d8        ubuntu              "/bin/bash"              56 seconds ago      Exited (0) 2 seconds ago                        contenedor1         52B (virtual 72.9MB)
```

Por todo lo que hemos explicado, ahora se entiende  que **no podemos eliminar una imágen cuando tenemos contenedores creados a a partir de ella**.

Por último al solicitar información de la imágen, podemos ver información sobre las capas:

```bash
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
```

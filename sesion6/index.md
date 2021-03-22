---
layout: default
title: Creación de imágenes
nav_order: 7
has_children: true
---
# Creación de imágenes en docker

# Creación de una nueva imagen a partir de un contenedor
{: .no_toc }

Hasta ahora hemos creado contenedores a partir de las imágenes que encontramos en Docker Hub. Estas imágenes las han creado otras personas.

Para crea un contenedor que sirva nuestra aplicación, tendremos que crear una imagen personaliza, es lo que llamamos "dockerizar" una aplicación.

![docker](img/build.png)

* [Creación de una nueva imagen a partir de un contenedor](contenedor.html)
* [Creación de imágenes con fichero Dockerfile](dockerfile.html)
* [Creación automática de imágenes en Docker Hub](dockerhub.html)

Veamos algunos ejemplos de ficheros `Dockerfile`:

* [Ejemplos de ficheros Dockerfile](ejemplos_dockerfile.html)

Una vez que hemos visto cómo crear imágenes docker, podemos estudiar el proceso de puesta en producción de aplicaciones web usando docker:

* [Ciclo de vida de nuestras aplicaciones con docker](ciclo_vida.html)

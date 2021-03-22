---
layout: default
title: Introducción
nav_order: 2
has_children: true
---

# Introducción a los contenedores y a Docker

* [Presentación](https://raw.githubusercontent.com/josedom24/presentaciones/main/iaw/introduccion_docker.pdf)


Docker es una tecnología de virtualización "ligera" cuyo elemento básico es la utilización de contenedores en vez de máquinas virtuales y cuyo objetivo principal es el despliegue de aplicaciones encapsuladas en dichos contenedores.

Docker está formado por varios componentes:

* **Docker Engine**: Es un demonio que corre sobre cualquier distribución de Linux y que expone una API externa para la gestión de imágenes y contenedores. Con ella podemos crear imágenes, subirlas y bajarla de un registro de docker y ejecutar y gestionar contenedores.
* **Docker Client**: Es el cliente de línea de comandos (CLI) que nos permite gestionar el Docker Engine. El cliente docker se puede configurar para trabajar con con un Docker Engine local o remoto, permitiendo gestionar tanto nuestro entorno de desarrollo local, como nuestro entorno de producción.
* **Docker Registry**: La finalidad de este componente es almacenar las imágenes generadas por el Docker Engine. Puede estar instalada en un servidor independiente y es un componente fundamental, ya que nos permite distribuir nuestras aplicaciones. Es un proyecto open source que puede ser instalado gratuitamente en cualquier servidor, pero, como hemos comentado, el proyecto nos ofrece **Docker Hub**.

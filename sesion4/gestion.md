---
layout: default
title: "Gestionando las redes en docker"
nav_order: 4
parent: Redes
---

# Gestionando las redes en docker

Tenemos que hacer una diferenciación entre dos tipos de redes **bridge**: 

* La red creada por defecto por docker para que funcionen todos los contenedores.
* Y las redes "bridge" definidas por el usuario.

Esta red "bridge" por defecto, que es la usada por defecto por los contenedores, se diferencia en varios aspectos de las redes "bridge" que creamos nosotros. Estos aspectos son los siguientes:

* Las redes que nosotros definamos proporcionan **resolución DNS** entre los contenedores, cosa que la red por defecto no hace a no ser que usemos opciones que ya se consideran obsoletas ("deprectated") (`--link`).
* Puedo **conectar en caliente** a los contenedores redes "bridge" definidas por el usuario. Si uso la red por defecto tengo que parar previamente el contenedor.
* Me permite gestionar de manera más segura el **aislamiento** de los contenedores, ya que si no indico una red al arrancar un contenedor éste se incluye en la red por defecto donde pueden convivir servicios que no tengan nada que ver.
* Tengo más **control** sobre la configuración de las redes si las defino yo. Los contenedores de la red por defecto comparten todos la misma configuración de red (MTU, reglas ip tables etc...).
* Los contenedores dentro de la red "bridge" por defecto comparten todos ciertas variables de entorno lo que puede provocar ciertos conflictos.

En definitiva: **Es importante que nuestro contenedores en producción se estén ejecutando sobre una red definida por el usuario.**

Para gestionar las redes creadas por el usuario:

* **docker network ls**: Listado de las redes.
* **docker network create**: Creación de redes. Ejemplos:
    * `docker network create red1`
    * `docker network create -d bridge --subnet 172.24.0.0/16 --gateway 172.24.0.1 red2`
* **docker network rm/prune**: Borrar redes. Teniendo en cuenta que no puedo borrar una red que tenga contenedores que la estén usando. deberé primero borrar los contenedores o desconectar la red.
* **docker network inspect**: Nos da información de la red.

Nota: **Cada red docker que creo crea un puente de red específico para cada red que podemos ver con `ip a`**:

![docker](img/bridge2.png)

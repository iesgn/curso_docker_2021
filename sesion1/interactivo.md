---
layout: default
title: Ejecutando un contenedor interactivo
nav_order: 5
parent: Introducción
---

# Ejecutando un contenedor interactivo

En este caso usamos la opción `-i` para abrir una sesión interactiva, `-t` nos permite crear un pseudo-terminal que nos va a permitir interaccionar con el contenedor, indicamos un nombre del contenedor con la opción `--name`, y la imagen que vamos a utilizar para crearlo, en este caso `ubuntu`,  y por último el comando que vamos a ejecutar, en este caso `bash`, que lanzará una sesión bash en el contenedor:

```bash
$  docker run -it --name contenedor1 ubuntu bash 
root@2bfa404bace0:/#
```

El contenedor se para cuando salimos de él. Para volver a conectarnos a él:

```bash
$ docker start contendor1
contendor1
$ docker attach contendor1
root@2bfa404bace0:/#
```

Si el contenedor se está ejecutando podemos ejecutar comandos en él con el subcomando `exec`:

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
        "Path": "bash",
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

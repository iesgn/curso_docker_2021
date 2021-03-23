---
layout: default
title: Creando un contenedor demonio
nav_order: 6
parent: Introducción
---

# Creando un contenedor demonio

En esta ocasión hemos utilizado la opción `-d` del comando `run`, para que la ejecución del comando en el contenedor se haga en segundo plano.

```bash
$ docker run -d --name contenedor2 ubuntu bash -c "while true; do echo hello world; sleep 1; done"
7b6c3b1c0d650445b35a1107ac54610b65a03eda7e4b730ae33bf240982bba08
```

> NOTA: En la instrucción `docker run` hemos ejecutado el comando con `bash -c` que nos permite ejecutar uno o mas comandos en el contenedor de forma más compleja (por ejemplo, indicando ficheros dentro del contenedor).

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

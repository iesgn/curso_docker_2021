---
layout: default
title: Instalación de docker
nav_order: 2
parent: Introducción
---
# Instalación de docker

En debian vamos a instalar la versión de la comunidad:

```bash
apt install docker.io
```

Si queremos usar el cliente de docker con un usuario sin privilegios:

```bash
usermod -aG docker usuario
```

Volvemos acceder con el usuario al sistema, y comprobamos que ya podemos usar el cliente docker con el usuario sin privilegios, por ejemplo, podemos comprobar la versión que hemos instalado:

```bash
$ docker --version
Docker version 18.09.1, build 4c52b90
```

Si queréis instala la versión de Docker ofrecida por la empresa (`docker-ce`) podéis ver las instrucciones de instalación en vuestro sistema operativo en la siguiente [página](https://docs.docker.com/get-docker/).

## Ejercicios

1. Instala docker en una máquina y configuralo para que se pueda usar con un usuario sin privilegios.
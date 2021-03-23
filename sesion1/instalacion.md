---
layout: default
title: Instalación de docker
nav_order: 2
parent: Introducción
---
# Instalación de docker

## Instalación de la versión oficial de docker

Siguiendo la documentación para la instalación de [Debian](https://docs.docker.com/engine/install/debian/) y de [Ubuntu](https://docs.docker.com/engine/install/ubuntu/), nos damos cuenta que son similares y que podemos resumir los pasos en los siguientes:

Instalamos los paquetes necesarios:

```bash
 sudo apt-get update

 sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

Añadimos las claves GPG del repositorio:

```bash
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Añadimos el repositorio a nuestra lista de repositorios:

```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Finalmente, hacemos la instalación de docker:

```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
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

Si queréis instala la versión de Docker para otro sistema operativo podéis ver las instrucciones de instalación en la siguiente [página](https://docs.docker.com/get-docker/).

## Instalación de la versión de la comunidad de docker moby

Si usamos debian vamos a instalar la versión de la comunidad:

```bash
apt install docker.io
```

## Ejercicios

1. Instala docker en una máquina y configuralo para que se pueda usar con un usuario sin privilegios.
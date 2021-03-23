---
layout: default
title: Instalación de docker
nav_order: 2
parent: Introducción
---
# Instalación de docker

## Instalación de la versión oficial de docker para Debian

Siguiendo la documentación para la instalación en [Debian](https://docs.docker.com/engine/install/debian/), podemos resumir los pasos en los siguientes:

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
Docker version 20.10.5, build 55c4c88
```

## Instalación de la versión oficial de docker para Ubuntu

Siguiendo la documentación para la instalación en [Ubuntu](https://docs.docker.com/engine/install/ubuntu/), podemos resumir los pasos en los siguientes:

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
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Añadimos el repositorio a nuestra lista de repositorios:

```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
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
Docker version 20.10.5, build 55c4c88
```


Si queréis instala la versión de Docker para otro sistema operativo podéis ver las instrucciones de instalación en la siguiente [página](https://docs.docker.com/get-docker/).

## Instalación de la versión de la comunidad de docker moby

Si usamos debian vamos a instalar la versión de la comunidad:

```bash
apt install docker.io
```

El caso de Debian 10 la versión de la comunidad es la siguiente:

```bash
$ docker --version
Docker version 18.09.1, build 4c52b90
```
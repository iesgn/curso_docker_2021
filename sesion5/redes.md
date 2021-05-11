---
layout: default
title: "Redes con docker-compose"
nav_order: 6
parent: Escenarios multicontenedor
---

# Redes con docker-compose

Como hemos indicado anteriormente, cuando creamos un escenario con `docker-compose` **se crea una nueva red definida por el usuario donde se conectan los contenedores**, por lo tanto, obtenemos resolución por dns que resuelve tanto el nombre del contenedor, como el nombre del servicio.

Sin embargo en el fichero `docker-compose.yaml` podemos definir y configurar las redes que necesitemos en nuestro escenario, así como la conexión de los distintos contenedores a dichas redes.

Veamos un ejemplo:

```yaml
version: '3.1'
services:
  app:
    container_name: servidor_web
    image: httpd:2.4
    restart: always
    ports:
      - 8080:80
    networks:
      red_web:
        ipv4_address: 192.168.10.10
      red_interna:
        ipv4_address: 192.168.20.10
    hostname: servidor_web

  db:
    container_name: servidor_mariadb
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: asdasd
    restart: always
    networks:
      red_interna:
        ipv4_address: 192.168.20.20
    hostname: servidor_mariadb
networks:
    red_web:
        ipam:
            config:
              - subnet: 192.168.10.0/24
    red_interna:
        ipam:
            config:
              - subnet: 192.168.20.0/24
```

Iniciamos el escenario:

```bash
$ docker-compose up -d
Creating network "docker-compose_red_web" with the default driver
Creating network "docker-compose_red_interna" with the default driver
Creating servidor_mariadb ... done
Creating servidor_web     ... done
```

Comprobamos que los dos contenedores se están ejecutando:

```bash
$ docker-compose ps
      Name                   Command             State                  Ports                
---------------------------------------------------------------------------------------------
servidor_mariadb   docker-entrypoint.sh mysqld   Up      3306/tcp                            
servidor_web       httpd-foreground              Up      0.0.0.0:8080->80/tcp,:::8080->80/tcp
```

Accedemos al servidor web e instalamos los paquetes necesarios para hacer las comprobaciones de configuración de la red:

```bash
$ docker-compose exec app bash
root@servidor_web::/usr/local/apache2# apt-get update && apt-get install -y inetutils-ping \
   iproute2 \
   dnsutils
```

Comprobamos que el hostname se ha configurado de manera adecuada:

```bash
root@servidor_web:/usr/local/apache2# cat /etc/hostname
servidor_web
```

Comprobamos que el contenedor está conectado a las dos redes y tiene las direcciones que hemos indicado:

```bash
root@servidor_web:/usr/local/apache2# ip a
...
401: eth0@if402: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc 
...
    inet 192.168.20.10/24 brd 192.168.20.255 scope global eth0
...
403: eth1@if404: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc 
...
    inet 192.168.10.10/24 brd 192.168.10.255 scope global eth1
```

Comprobamos que tenemos resolución DNS tanto con el nombre del servicio como con el nombre del contenedor:

```bash
root@servidor_web:/usr/local/apache2# dig servidor_mariadb

...
;; ANSWER SECTION:
servidor_mariadb.	600	IN	A	192.168.20.20
...

root@servidor_web:/usr/local/apache2# dig db

...
;; ANSWER SECTION:
db.			600	IN	A	192.168.20.20
...
```

Y por últimos comprobamos que hay conectividad:

```bash
root@servidor_web:/usr/local/apache2# ping servidor_mariadb
PING servidor_mariadb (192.168.20.20): 56 data bytes
64 bytes from 192.168.20.20: icmp_seq=0 ttl=64 time=0.195 ms
...
```
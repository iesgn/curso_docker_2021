---
layout: default
title: "Trabajando con la redes bridge definidas por el usuario"
nav_order: 6
parent: Redes
---

# Trabajando con la redes bridge definidas por el usuario

Imaginemos que he creados dos redes definidas por el usuario:

```bash
$ docker network create --subnet 172.28.0.0/16 --gateway 172.28.0.1 red1
$ docker network create red2
```

Vamos a trabajar en un primer momento con la `red1`. Vamos a crear dos contenedores conectados a dicha red:

```bash
$ docker run -d --name my-apache-app --network red1 -p 8080:80 httpd:2.4
```
Lo primero que vamos a comprobar es la resolución DNS:

```bash
$ docker run -it --name contenedor1 --network red1 debian bash
root@98ab5a0c2f0c:/# apt update && apt install dnsutils -y
...
root@98ab5a0c2f0c:/# dig my-apache-app
...
;; ANSWER SECTION:
my-apache-app.		600	IN	A	172.28.0.2
...
;; SERVER: 127.0.0.11#53(127.0.0.11)
...
```

Ahora podemos probar como podemos conectar un contenedor a una red. Para conectar usaremos `docker network connect` y para desconectarla usaremos `docker network disconnect`.

```bash
$ docker network connect red2 contenedor1 

$ docker start contenedor1
contenedor1
    
$ docker attach contenedor1
root@98ab5a0c2f0c:/# ip a
...
46: eth0@if47: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    ...
    inet 172.28.0.4/16 brd 172.28.255.255 scope global eth0
...
48: eth1@if49: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
...    
    inet 172.18.0.3/16 brd 172.18.255.255 scope global eth1
...
```

Tanto al crear un contenedor con el flag `--network`, como con la instrucción `docker network connect`, podemos usar algunos otros flags:

* `--dns`: para establecer unos servidores DNS predeterminados.
* `--ip6`: para establecer la dirección de red ipv6
* `--hostname` o `-h`: para establecer el nombre de host del contenedor. Si no lo establezco será el ID del mismo.

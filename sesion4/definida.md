---
layout: default
title: "Uso de las redes bridge definidas por el usuario"
nav_order: 6
parent: Redes
---

# Uso de las redes bridge definidas por el usuario

Vamos a crear una red tipo bridge definida por el usuario con la instrucción `docker network create`:

```bash
$ docker network create red1

```

Como no hemos indicado ninguna configuración en la red que hemos creado, docker asigna un direccionamiento a la red:

```bash
$ docker network inspect red1
[
    {
        "Name": "red1",
        ...
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        ...
]
```

Vamos a crear dos contenedores conectados a dicha red:

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
my-apache-app.		600	IN	A	172.18.0.2
...
;; SERVER: 127.0.0.11#53(127.0.0.11)
...
```

Evidentemente desde los dos contenedores se pueden resolver los dos nombres:

```bash
root@98ab5a0c2f0c:/# dig contenedor1
...
;; ANSWER SECTION:
contenedor1.		600	IN	A	172.18.0.3
...
;; SERVER: 127.0.0.11#53(127.0.0.11)
...
```

## Conectando los contenedores a otras redes

A continuación vamos a crear otra red bridge, pero vamos a indicar el direccionamiento:

```bash
$ docker network create red2 --subnet 192.168.100.0/24 --gateway 192.168.100.1
```

Creamos un contenedor conectado a esta nueva red y comprobamos que no hay conectividad con los dos anteriores:

```bash
$ docker run -it --name contenedor2 --network red2 debian bash
root@f9c7ac830a18:/# ip a
...
    inet 192.168.100.2/24 brd 192.168.100.255 scope global eth0
...
root@f9c7ac830a18:/# ping contenedor1
ping: contenedor1: Name or service not known
```

Ahora podemos probar como podemos conectar un contenedor a una red. Para conectar usaremos `docker network connect` y para desconectarla usaremos `docker network disconnect`.

```bash
$ docker network connect red2 contenedor1 

$ docker start contenedor1
contenedor1
    
$ docker start contenedor2
contenedor2

$ docker attach contenedor1
root@98ab5a0c2f0c:/# ip a
...
46: eth0@if47: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    ...
    inet 172.18.0.3/16 brd 172.18.255.255 scope global eth0
...
48: eth1@if49: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
...    
    inet 192.168.100.2/24 brd 192.168.100.255 scope global eth1
...
root@98ab5a0c2f0c:/# ping contenedor2
PING contenedor2 (192.168.100.3) 56(84) bytes of data.
64 bytes from contenedor2.red2 (192.168.100.3): icmp_seq=1 ttl=64 time=0.082 ms
...
```

Tanto al crear un contenedor con el flag `--network`, como con la instrucción `docker network connect`, podemos usar algunos otros flags:

* `--dns`: para establecer unos servidores DNS predeterminados.
* `--ip6`: para establecer la dirección de red ipv6
* `--hostname` o `-h`: para establecer el nombre de host del contenedor. Si no lo establezco será el ID del mismo.

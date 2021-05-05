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

Podemos comprobar la configuración DNS del contenedor:

```bash
root@98ab5a0c2f0c:/# cat /etc/resolv.conf 
nameserver 127.0.0.11
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

Evidentemente desde el `contenedor2` también tenemos conectividad a contenedor1, pero evidentemente no al contenedor `my-apache-app`:

```bash
$ docker attach contenedor2
root@f9c7ac830a18:/# ping contenedor1
PING contenedor1 (192.168.100.2) 56(84) bytes of data.
64 bytes from contenedor1.red2 (192.168.100.2): icmp_seq=1 ttl=64 time=0.072 ms
...
root@f9c7ac830a18:/# ping my-apache-app
ping: my-apache-app: Name or service not known
```

## Más opciones al trabajar con redes en docker

Tanto al crear un contenedor con el flag `--network`, como con la instrucción `docker network connect`, podemos usar algunos otros flags:

* `--dns`: para establecer unos servidores DNS predeterminados.
* `--ip`: Para establecer una ip fija en el contenedor.
* `--ip6`: para establecer la dirección de red ipv6
* `--hostname` o `-h`: para establecer el nombre de host del contenedor. Si no lo establezco será el ID del mismo.
* `--add-host`: añade entradas de nuevos hosts en el fichero `/etc/hosts`

Veamos un ejemplo:

Primero creamos una red:

```bash
$ docker network create --subnet 192.168.100.0/24 red3
```

Y creamos un contenedor conectado a esta red con algunos parámetros extras:

```bash
$ docker run -it --name contenedor --network red3 \
                                   --ip 192.168.100.10 \
                                   --add-host=testing.example.com:192.168.100.20 \
                                   --dns 8.8.8.8 \
                                   --hostname servidor1 \
                                   debian
```

Como hemos comentado anteriormente estos parámetros también lo podemos usar al conectar un contenedor a una red con `docker network connect`. Veamos con detenimiento cada uno de los parámetros:


* `--hostname servidor1`: Indicamos el nombre de la máquina. Lo comprobamos:

```bash
root@servidor1:/# cat /etc/hostname 
servidor1
```

* `--ip 192.168.100.10`: Nos permite poner una ip fija en el contenedor. Vamos a comprobarlo:

```bash
root@servidor1:/# ip a
...
25: eth0@if26: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    ...
    inet 192.168.100.10/24 brd 192.168.100.255 scope global eth0
    ...
```
* `--add-host=testing.example.com:192.168.100.20`: Añadimos un nuevos host como resolución estática. Lo comprobamos:

```bash
root@servidor1:/# cat /etc/hosts
...
192.168.100.20	testing.example.com
192.168.100.10	servidor1

root@servidor1:/# ping testing.example.com
PING testing.example.com (192.168.100.20) 56(84) bytes of data.
...
```

* `--dns 8.8.8.8`: Hemos configurado como DNS el servidor `8.8.8.8`. Veamos esto con detenimiento, como hemos visto anteriormente al conectar el contenedor a una red bridge definida por el usuario se crea un servidor DNS que nos permite la resolución por el nombre del contenedor (parámetro `--name`, no se resuelve el nombre que hayamos indicado con el parámetro `--hostname`), veamos el servidor DNS:

```bash
root@servidor1:/# cat /etc/resolv.conf 
nameserver 127.0.0.11
...
```

  Por defecto este servidor hace forward con el servidor DNS que tenga configurado el anfitrión (es decir usa el DNS del anfitrión para resolver los nombre que no conoce). Con la opción `--dns 8.8.8.8`, estamos cambiando el DNS al que hacemos forwarding, por lo tanto ese cambio no se visualizar en el fichero `/etc/resolv.conf`.

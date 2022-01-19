---
layout: default
title: "Introducción a las redes en docker"
nav_order: 2
parent: Redes
---

# Introducción a las redes en docker

Aunque hasta ahora no lo hemos tenido en cuenta, cada vez que creamos un contenedor, esté se conecta a una red virtual y docker hace una configuración del sistema (usando bridges e iptables) para que la máquina tenga una ip interna, tenga acceso al exterior, podamos mapear (DNAT) puertos,...

Vamos a crear un contenedor interactivos con la imagen `debian`:

```bash
$ docker run -it --name contenedor1 --rm debian bash
```
**Nota: Hemos usado la opción `--rm` para al finalizar de ejecutar el proceso, el contenedor se elimina.**

En otra pestaña, podemos ejecutar esta instrucción para obtener la ip que se le ha asignado:
{% raw %}
```
$ docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' contenedor1
172.17.0.2
```
{% endraw %}
Obtenemos información del contenedor filtrando el json de salida para obtener la IPv4 que se le ha asignado.

Observamos que el contenedor tiene una ip en la red `172.17.0.0/16`. Además podemos comprobar que se ha creado un `bridge` en el host, al que se conectan los contenedores:

```bash
$ ip a
...
5: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:be:71:11:9e brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:beff:fe71:119e/64 scope link 
       valid_lft forever preferred_lft forever
...
```

Además podemos comprobar que se han creado distintas cadenas en el cortafuegos para gestionar la comunicación de los contenedores. Podemos ejecutar como administrador: `iptables -L -n` y `iptables -L -n - t nat` y comprobarlo.
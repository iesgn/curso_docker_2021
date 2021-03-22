---
layout: default
title: Redes
nav_order: 5
has_children: true
---
# Redes en docker

Aunque hasta ahora no lo hemos tenido en cuenta, cada vez que creamos un contenedor, esté se conecta a una red virtual y docker hace una configuración del sistema (usando interfaces puente e iptables) para que la máquina tenga una ip interna, tenga acceso al exterior, podamos mapear (DNAT) puertos,...)

Cuando instalamos docker tenemos las siguientes redes predefinidas:

* Red de tipo bridge
* Red de tipo host
* Red de  tipo none


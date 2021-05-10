---
layout: default
title: "Redes con docker-compose"
nav_order: 6
parent: Escenarios multicontenedor
---

# Redes con docker-compose

Como indicado anteriormente, cuando creamos un escenario con `docker-compose` **se crea una nueva red definida por el usuario docker donde se conectan los contenedores**, por lo tanto, obtenemos resolución por dns que resuelve tanto el nombre del contenedor, como el nombre del servicio.

Sin embargo en el fichero `docker-compose.yaml` podemos definir y configurar las redes que necesitemos en nuestro escenario, así como la conexión de los distintos contenedores a dichas redes.

Veamos un ejemplo:

```yaml
version: '3.1'
services:
  app:
    container_name: servidor_web
    image: nginx
    restart: always
    ports:
      - 8080:80
    networks:
      red_nginx:
        ipv4_address: 192.168.10.10
      red_interna:
        ipv4_address: 192.168.20.10

  db:
    container_name: servidor_mariadb
    image: mariadb
    restart: always
    networks:
      red_interna:
        ipv4_address: 192.168.20.20
networks:
    red_nginx:
        ipam:
            config:
              - subnet: 192.168.10.0/24
    red_interna:
        ipam:
            config:
              - subnet: 192.168.20.0/24
```
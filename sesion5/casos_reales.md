---
layout: default
title: "Ejemplos reales de despliegues usando docker-compose"
nav_order: 11
parent: Escenarios multicontenedor
---

# Ejemplos reales de despliegues usando docker-compose

En la actualidad la mayoría de los despliegues reales que se hacen con docker, se realizan usando la herramienta *docker-compose*, veamos algunos ejemplos:

* **Despliegue de jitsi**: [Jitsi](https://meet.jit.si/) es una aplicación de videoconferencia, VoIP, y mensajería instantánea con aplicaciones nativas para iOS y Android, y con soporte para Windows, Linux y Mac OS X a través de la web.​ Es compatible con varios protocolos populares de mensajería instantánea y de telefonía, y se distribuye bajo los términos de la licencia Apache, por lo que es software libre y de código abierto. Podemos encontar las instrucciones para desplegarlo con docker en esta [página](https://github.com/jitsi/docker-jitsi-meet) y podemos acceder al fichero [docker-compose.yml](https://github.com/jitsi/docker-jitsi-meet/blob/master/docker-compose.yml).
* **Despliegue de las aplicaciones de Bitnami**: [Bitnami](https://bitnami.com/) es una empresa que nois proporciona distinta formas de despliegues de aplicaciones web en la nube. Una de estas formas es la utilización de docker, y podemos ver que [todas las aplicaciones](https://bitnami.com/stacks/containers) que nos ofrece Bitnami tienen el fichero `docker-compose.yml` para realizar el despliegue, por ejemplo podemos ver el [fichero](https://github.com/bitnami/bitnami-docker-prestashop/blob/master/docker-compose.yml) de la aplicación PrestaShop de Bitnami.
* **Despliegue de Guacamole**: [Apache Guacamole](https://guacamole.apache.org/) es un cliente (aplicación web HTML5) capaz de ofrecerte funcionalidades para acceso remoto a servidores y otros equipos remotos desde cualquier parte solo con la ayuda de una conexión y un navegador web. Podemos instalar [Guacamole con docker](https://guacamole.apache.org/doc/gug/guacamole-docker.html) y aunque en esa página no tenemos el fichero `docker-compse-yml` podemos encontrar ejemplos de muchos usuarios en [GitHub](https://github.com/boschkundendienst/guacamole-docker-compose/blob/master/docker-compose.yml).
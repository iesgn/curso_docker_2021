---
layout: default
title: "El fichero docker-compose.yml"
nav_order: 3
parent: Escenarios multicontenedor
---

# El fichero docker-compose.yml

En el fichero `docker-compose.yml` vamos a definir el escenario. **El programa docker-compose se debe ejecutar en el directorio donde este ese fichero**. Por lo tanto tenderemos un directorio con un fichero `docker-compose.yml` para cada una las aplicaciones que queremos desplegar. Por ejemplo para la ejecución de la aplicación [Let's Chat](https://github.com/sdelements/lets-chat) podríamos tener un fichero `docker-compose.yml`, dentro de una carpeta, con el siguiente contenido:

```yaml
version: '3.1'
services:
  app:
    container_name: letschat
    image: sdelements/lets-chat
    restart: always
    environment:
      LCB_DATABASE_URI: mongodb://mongo/letschat
    ports:
      - 80:8080
    depends_on:
      - db
  db:
    container_name: mongo
    image: mongo
    restart: always
    volumes:
      - /opt/mongo:/data/db
```


Puedes encontrar todos los parámetros que podemos definir en la [documentación oficial](https://docs.docker.com/compose/compose-file/compose-file-v3/).

Algunos parámetros interesantes:

* Es escenario está formado por `services`. Cada uno ello va a crear un contenedor.
* `restart: always`: Indicamos la política de reinicio del contenedor si por cualquier condición se para. [Más información](https://docs.docker.com/compose/compose-file/compose-file-v3/#restart).
* `depend on`: Indica la dependencia entre contenedores. No se va a iniciar un contenedor hasta que otro este funcionando. [Más información](https://docs.docker.com/compose/compose-file/compose-file-v3/#depends_on).

Cuando creamos un escenario con `docker-compose` se crea una **nueva red definida por el usuario** donde se conectan los contenedores, por lo tanto, obtenemos resolución por dns que resuelve tanto el nombre del contenedor (por ejemplo, `mongo`) como el nombre del servicio (por ejemplo, `db`).


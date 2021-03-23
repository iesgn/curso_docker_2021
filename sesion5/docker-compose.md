---
layout: default
title: "El fichero docker-compose.yml"
nav_order: 4
parent: Escenarios multicontenedor
---

# El fichero docker-compose.yml

En el fichero `docker-compose.yml` vamos a definir el escenario. El programa docker-compose se debe ejecutar en el directorio donde este ese fichero. Por ejemplo para la ejecución de mediawiki persistente podríamos tener un fichero con el siguiente contenido:

...


Puedes encontrar todos los parámetros que podemos definir en la [documentación oficial](https://docs.docker.com/compose/compose-file/compose-file-v3/).

Algunos parámetros interesantes:

* `restart: always`: Indicamos la política de reinicio del contenedor si por cualquier condición se para. [Más información](restart: always).
* `depend on`: Indica la dependencia entre contenedores. No se va a iniciar un contenedor hasta que otro este funcionando. [Más información](https://docs.docker.com/compose/compose-file/compose-file-v3/#depends_on).

Cuando creamos un escenario con `docker-compose` se crea una **nueva red definida por el usuario docker** donde se conectan los contenedores, por lo tanto, se pueden tenemos resolución por dns que resuelve tanto el nombre del contenedor (por ejemplo, `redis`) como el alias (por ejemplo, `db`).
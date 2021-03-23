---
layout: default
title: "Ejercicios"
nav_order: 8
parent: Escenarios multicontenedor
---

# Ejercicios 

nextcloud


## Ejercicios

1. Instala docker-compose en tu ordenador. Copia el fichero `docker-compose.yml` de la documentación de la imagen oficial de wordpress.
2. Modifica el `docker-compose.yml` para que use el puerto 8001.
3. Modifica el `docker-compose.yml`, para que la base de datos se llame db_wordpress.
4. Modifica el `docker-compose.yml` para usar bind mount en vez de volúmenes.
5. Levanta el escenario con `docker-compose`.
6. Muestra los contenedores con `docker-compose`.
7. Accede a la aplicación y comprueba que funciona.
8. Comprueba el almacenamiento que has definido y que se ha creado una nueva red de tipo bridge.
9. Borra el escenario con `docker-compose`.
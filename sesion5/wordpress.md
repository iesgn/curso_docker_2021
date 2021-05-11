---
layout: default
title: "Ejemplo 3: Despliegue de WordPress + Mariadb"
nav_order: 9
parent: Escenarios multicontenedor
---

# Ejemplo 3: Despliegue de WordPress + Mariadb

En este ejemplo vamos a desplegar con docker-compose la aplicación WordPress + MariaDB, que estudiamos en el módulo de redes: [Ejemplo 3: Despliegue de Wordpress + mariadb ](../sesion4/wordpress.html).

Puedes encontrar los ficheros `docker-compose.yml` en este [directorio](https://github.com/iesgn/curso_docker_2021/tree/main/ejemplos/sesion5/ejemplo3) del repositorio. 


## Utilizando volúmenes docker

Por ejemplo para la ejecución de wordpress persistente con volúmenes docker podríamos tener un fichero `docker-compose.yml` con el siguiente contenido:

```yaml
version: '3.1'
services:
  wordpress:
    container_name: servidor_wp
    image: wordpress
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: user_wp
      WORDPRESS_DB_PASSWORD: asdasd
      WORDPRESS_DB_NAME: bd_wp
    ports:
      - 80:80
    volumes:
      - wordpress_data:/var/www/html/wp-content
  db:
    container_name: servidor_mysql
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: bd_wp
      MYSQL_USER: user_wp
      MYSQL_PASSWORD: asdasd
      MYSQL_ROOT_PASSWORD: asdasd
    volumes:
      - mariadb_data:/var/lib/mysql
volumes:
    wordpress_data:
    mariadb_data:
```

Para crear el escenario:

```bash
$ docker-compose up -d
Creating network "wp_default" with the default driver
Creating servidor_wp    ... done
Creating servidor_mysql ... done
```

Para listar los contenedores:

```bash
$ docker-compose ps
     Name                   Command               tate         Ports       
---------------------------------------------------------------------------
servidor_mysql   docker-entrypoint.sh mysqld      Up      306/tcp          
servidor_wp      docker-entrypoint.sh apach ...   Up      0.0.0.0:80->80/tcp
```

Para parar los contenedores:

```bash
$ docker-compose stop 
Stopping servidor_wp    ... done
Stopping servidor_mysql ... done
```

Para borrar los contenedores:

```bash
$ docker-compose rm
Going to remove servidor_wp, servidor_mysql
Are you sure? [yN] y
Removing servidor_wp    ... done
Removing servidor_mysql ... done
```

Para eliminar el escenario (contenedores, red y volúmenes):

```bash
$ docker-compose down -v
Stopping servidor_mysql ... done
Stopping servidor_wp    ... done
Removing servidor_mysql ... done
Removing servidor_wp    ... done
Removing network volumen_default
Removing volume volumen_wordpress_data
Removing volume volumen_mariadb_data
```

## Utilizando bind-mount

Por ejemplo para la ejecución de wordpress persistente con bind mount podríamos tener un fichero `docker-compose.yml` con el siguiente contenido:

```yaml
version: '3.1'
services:
  wordpress:
    container_name: servidor_wp
    image: wordpress
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: user_wp
      WORDPRESS_DB_PASSWORD: asdasd
      WORDPRESS_DB_NAME: bd_wp
    ports:
      - 80:80
    volumes:
      - ./wordpress:/var/www/html/wp-content
  db:
    container_name: servidor_mysql
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: bd_wp
      MYSQL_USER: user_wp
      MYSQL_PASSWORD: asdasd
      MYSQL_ROOT_PASSWORD: asdasd
    volumes:
      - ./mysql:/var/lib/mysql
```

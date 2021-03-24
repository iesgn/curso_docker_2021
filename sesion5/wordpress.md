---
layout: default
title: "Ejemplo 3: Despliegue de la aplicación WordPress + Mariadb"
nav_order: 7
parent: Escenarios multicontenedor
---

# Ejemplo 3: Despliegue de la aplicación WordPress + Mariadb
....

Por ejemplo para la ejecución de wordpress persistente podríamos tener un fichero con el siguiente contenido:

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
      - /opt/wordpress:/var/www/html/wp-content
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
      - /opt/mysql_wp:/var/lib/mysql
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
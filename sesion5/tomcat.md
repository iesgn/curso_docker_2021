---
layout: default
title: "Ejemplo 4: Despliegue de tomcat + nginx "
nav_order: 10
parent: Escenarios multicontenedor
---

# Ejemplo 4: Despliegue de tomcat + nginx 

En este ejemplo vamos a desplegar con docker-compose la aplicación Java con Tomcat y nginx como proxy inverso que vimos en la sesión anterior en el [Ejemplo 4: Despliegue de tomcat + nginx ](../sesion4/tomcat.html).

Puedes encontrar el fichero `docker-compose.yml` en en este [directorio](https://github.com/iesgn/curso_docker_2021/tree/main/ejemplos/sesion5/ejemplo4) del repositorio. 

El fichero `docker-compose.yaml` sería:

```yaml
version: '3.1'
services:
  aplicacionjava:
    container_name: tomcat
    image: tomcat:9.0
    restart: always
    volumes:
      - ./sample.war:/usr/local/tomcat/webapps/sample.war:ro
  proxy:
    container_name: nginx
    image: nginx
    ports:
      - 80:80
    volumes:
      - ./default.conf:/etc/nginx/conf.d/default.conf:ro
```

Como podemos ver en el directorio donde tenemos guardado el `docker-compose.yaml`, tenemos los dos ficheros necesarios para la configuración: `sample.war` y `default.conf`.

Creamos el escenario:

```bash
$ docker-compose up -d
Creating network "ejemplo4_default" with the default driver
Creating nginx  ... done
Creating tomcat ... done
```

Comprobar que los contenedores están funcionando:

```bash
$ docker-compose ps
 Name               Command               State         Ports       
--------------------------------------------------------------------
nginx    /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp
tomcat   catalina.sh run                  Up      8080/tcp          
```

Y acceder al puerto 80 de nuestra IP para ver la aplicación.
---
layout: default
#title: "Ejemplo 4: Construcción de imágenes configurable con variables de entorno"
title:
nav_order: 7
parent: Creación de imágenes
nav_exclude: true
---

# Ejemplo 4: Construcción de imágenes configurable con variables de entorno

En este último ejemplo vamos a construir una imagen de una aplicación PHP que necesita conectarse a una base de datos mariadb para guardar información. Por lo tanto, vamos a construir la imagen para que podamos indicar variables de entorno para configurar las credenciales de acceso a la base de datos. Puedes encontrar los ficheros en este [directorio](https://github.com/iesgn/curso_docker_2021/tree/main/ejemplos/sesion6/ejemplo4) del repositorio.

## Aplicación bookmedik

Como ejemplo vamos a "dockerizar" una aplicación PHP para gestionar las citas de una consulta médica. La aplicación la podemos encontrar en [este repositorio de GitHub](https://github.com/evilnapsis/bookmedik.git).

Algunas cosas que hay que tener en cuenta:

* La aplicación tiene la configuración de acceso en la base de datos en el fichero `/core/controller/Database.php`, en la siguiente función:

```php
function Database(){
		$this->user="root";$this->pass="";$this->host="localhost";$this->ddbb="bookmedik";
    }
```
  A continuación veremos que será necesario cambiar los valores fijos que están definidos por los valores guardados en las variables de entorno de configuración.

* En el fichero `schema.sql` encontramos las instrucciones sql necesarias para inicializar la base de datos.

## Configurar nuestra aplicación con variables de entorno

En los casos en que necesitamos modificar algo en la aplicación o hacer algún proceso en el momento de crear el contenedor, lo que hacemos es crear un script en bash que meteremos en la imagen y que será la instrucción que indiquemos en el `CMD`. Este script en concreto hará las siguiente operaciones:

1. Modificará el fichero `/core/controller/Database.php` para poner los datos de acceso a la base de datos que tengamos guardados en las variables de entorno.
2. Utilizando el fichero `schema.sql` (que también guardaremos en la imagen) inicializará la base de datos.
3. Ejecutar el servidor web en segundo plano.

En el directorio de trabajo encontramos dos directorios:

* `build`: Será el contexto necesario para crear la imagen de la aplicación.
* `deploy`: Es el directorio donde tendremos el fichero `docker-compose.yml`.

## El contexto (directorio build)

En el directorio de contexto tendremos tres ficheros:

### Fichero script.sh

El fichero `script.sh` que se guardará en la imagen y se ejecutará con al iniciar el contenedor. Su contenido es el siguiente:

```bash
#!/bin/bash
sed -i 's/$this->user="root";/$this->user="'${MARIADB_USER}'";/g' /var/www/html/core/controller/Database.php
sed -i 's/$this->pass="";/$this->pass="'${MARIADB_PASS}'";/g' /var/www/html/core/controller/Database.php
sed -i 's/$this->host="localhost";/$this->host="'${MARIADB_HOST}'";/g' /var/www/html/core/controller/Database.php
sleep 5
mysql -u ${MARIADB_USER} -p${MARIADB_PASS} -h ${MARIADB_HOST} bookmedik < /opt/schema.sql
apache2ctl -D FOREGROUND
```
Con la instrucción `sed` se van modificando los parámetros de acceso con los valores de las variables de entorno. Hemos incluido un `sleep 5` para que de tiempo que el contenedor de la base de datos este disponible. Y finalmente se ejecuta el servidor web.

### Fichero schema.sql

Son las instrucciones sql que nos permiten crear las tablas necesarias en la base de datos.
Aunque está dentro del repositorio, lo hemos incluido aquí porque hemos eliminado la primera línea del fichero original donde se creaba la base de datos y daba un fallo.

### Fichero Dockerfile

El fichero`Dockerfile` sería el siguiente:

```Dockerfile
FROM debian
RUN apt-get update && apt-get install -y apache2 libapache2-mod-php7.3 php7.3 php7.3-mysql git mariadb-client && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN rm /var/www/html/index.html
ENV MARIADB_USER bookmedik
ENV MARIADB_PASS bookmedik
ENV MARIADB_NAME bookmedik
ENV MARIADB_HOST servidor_mysql

EXPOSE 80
RUN git clone https://github.com/evilnapsis/bookmedik.git /var/www/html
ADD script.sh /usr/local/bin/script.sh
ADD schema.sql /opt
RUN chmod +x /usr/local/bin/script.sh
CMD ["/usr/local/bin/script.sh"]
```

Algunas observaciones:

1. Creamos la imagen desde una imagen base, e instalamos los paquetes necesarios. Hemos instalado git, porque vamos a clonar el repositorio de la aplicación en el *DocumentRoot*, y hemos instalado un cliente de mariadb para que podamos inicializar la base de datos desde nuestro contenedor de la aplicación.
* Creamos las variables de entorno y le damos valores por defecto, por si no se indican en la creación del contenedor.
* Clonamos el repositorio al *DocumentRoot*.
* Copiamos los ficheros del script y del esquema de la base de datos a la imagen. Y le damos permisos de ejecución a `script.sh`.
* finalmente indicamos con `CMD` el comando que se va a ejecutar al iniciar el contenedor. En este caso ejecutaremos el script.

### Creación de la imagen

Ejecutamos dentro del directorio de contexto:

```bash
$ docker build -t josedom24/bookmedik .
```

## Despliegue de la aplicación (directorio deploy)

En este directorio tenemos un fichero `docker-compose.yml`:

```yaml
version: "3.1"
services:
  db:
    container_name: servidor_mysql
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: bookmedik
      MYSQL_USER: user_bookmedik
      MYSQL_PASSWORD: pass_bookmedik
      MYSQL_ROOT_PASSWORD: passwd
    volumes:
      - /opt/mysql_bookmedik:/var/lib/mysql

  bookmedik:
    container_name: bookmedik
    image: josedom24/bookmedik
    environment:
      MARIADB_USER: user_bookmedik
      MARIADB_PASS: pass_bookmedik
      MARIADB_NAME: bookmedik
      MARIADB_HOST: servidor_mysql
    restart: always
    ports:
      - 80:80
    depends_on:
      - db
```

Y ya podemos levantar el escenario, ejecutando:

```bash
$ docker-compose up -d
```

Y finalmente podemos acceder a la aplicación y comprobar que funciona. Para acceder a la aplicación usamos el usario `admin` con contraseña `admin`.
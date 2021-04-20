---
layout: default
title: Ejercicios
nav_order: 7
parent: Imágenes
---
# Ejercicios

## Ejercicios para repasar

1. Descarga las siguientes imágenes: `ubuntu:18.04`, `httpd`, `tomcat:9.0.39-jdk11`, `jenkins/jenkins:lts`, `php:7.4-apache`.
2. Muestras las imágenes que tienes descargadas.
3. Crea un contenedor demonio con la imagen `php:7.4-apache`.
4. Comprueba el tamaño del contenedor en el disco duro.
5. Con la instrucción `docker cp` podemos copiar ficheros a o desde un contenedor. Puedes encontrar información es esta [página](https://docs.docker.com/engine/reference/commandline/cp/). 
    Crea un fichero en tu ordenador, con el siguiente contenido:

    ```php
    <?php
    echo phpinfo();
    ?>
    ```
    Copia un fichero `info.php` al directorio `/var/www/html` del contenedor con `docker cp`.
6. Vuelve a comprobar el espacio ocupado por el contenedor.
7. Accede al fichero `info.php` desde un navegador web.

## Ejercicio para entregar

### Servidor web

* Arranca un contenedor que ejecute una instancia de la imagen `php:7.4-apache`, que se llame `web` y que sea accesible desde tu equipo en el puerto 8000.
* Colocar en el directorio raíz del servicio web (`/var/www/html`) de dicho contenedor un fichero llamado `index.html` con el siguiente contenido:

```html
<h1>HOLA SOY XXXXXXXXXXXXXXX</h1>
```
Deberás sustituir XXXXXXXXXXX por tu nombre y tus apellidos.

* Colocar en ese mismo directorio raíz un archivo llamado `index.php` con el siguiente contenido:
```php
<?php echo phpinfo(); ?>
```
* Para crear los ficheros tienes tres alternativas:
    * Ejecutando bash de forma interactiva en el contenedor y creando los ficheros.
    * Ejecutando un comando `echo` en el contenedor con `docker exec`.
    * Usando `docker cp` como hemos visto en el ejercicio 5.

### Servidor de base de datos

* Arrancar un contenedor que se llame `bbdd` y que ejecute una instancia de la imagen mariadb para que sea accesible desde el puerto 3336.
* Antes de arrancarlo visitar la página del contenedor en [Docker Hub](https://hub.docker.com/_/mariadb) y establecer las variables de entorno necesarias para que:

    * La contraseña de root sea `root`.
    * Crear una base de datos automáticamente al arrancar que se llame `prueba`.
    * Crear el usuario `invitado` con las contraseña `invitado`.

Deberás entregar los siguientes pantallazos comprimidos en un zip o en un documento pdf:

* Pantallazo que desde el navegador muestre el fichero `index.html`.
* Pantallazo que desde el navegador muestre el fichero `index.php`.
* Pantallazo donde se vea el tamaño del contenedor `web` después de crear los dos ficheros.
* Pantallazo donde desde un cliente de base de datos (instalado en tu ordenador) se pueda observar que hemos podido conectarnos al servidor de base de datos con el usuario creado y que se ha creado la base de datos prueba (`show databases`). El acceso se debe realizar desde el ordenador que tenéis instalado docker, no hay que acceder desde dentro del contenedor, es decir, no usar `docker exec`.
* Pantallazo donde se comprueba que no se puede borrar la imagen `mariadb` mientras el contenedor `bbdd` está creado.


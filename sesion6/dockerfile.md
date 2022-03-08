---
layout: default
title: Creación de imágenes a partir de un Dockerfile
nav_order: 2
parent: Creación de imágenes
---
# Creación de imágenes con fichero Dockerfile

El método anterior tiene algunos inconvenientes:

* **No se puede reproducir la imagen**. Si la perdemos tenemos que recordar toda la secuencia de órdenes que habíamos ejecutado desde que arrancamos el contenedor hasta que teníamos una versión definitiva e hicimos `docker commit`.
* **No podemos configurar el proceso que se ejecutará en el contenedor creado desde la imagen**. Los contenedores creados a partir de la nueva imagen ejecutaran por defecto el proceso que estaba configurado en la imagen base.
* **No podemos cambiar la imagen de base**. Si ha habido alguna actualización, problemas de seguridad, etc. con la imagen de base tenemos que descargar la nueva versión, volver a crear un nuevo contenedor basado en ella y ejecutar de nuevo toda la secuencia de órdenes.

Por todas estas razones, el método preferido para la creación de imágenes es el uso de ficheros `Dockerfile` y el comando `docker build`. Con este método vamos a tener las siguientes ventajas:

* **Podremos reproducir la imagen fácilmente** ya que en el fichero `Dockerfile` tenemos todas y cada una de las órdenes necesarias para la construcción de la imagen. Si además ese `Dockerfile` está guardado en un sistema de control de versiones como git podremos, no sólo reproducir la imagen si no asociar los cambios en el `Dockerfile` a los cambios en las versiones de las imágenes creadas.
* **Podremos configurar el proceso que se ejecutará por defecto en los contenedores creados a partir de la nueva imagen**.
* Si queremos cambiar la imagen de base esto es extremadamente sencillo con un `Dockerfile`, únicamente tendremos que modificar la primera línea de ese fichero tal y como explicaremos posteriormente.

## El fichero Dockerfile

Un fichero `Dockerfile` es un conjunto de instrucciones que serán ejecutadas de forma secuencial para construir una nueva imagen docker. Cada una de estas instrucciones crea una nueva capa en la imagen que estamos creando. 

Hay varias instrucción que podemos usar en la construcción de un `Dockerfile`, pero la estructura fundamental del fichero es:

* Indicamos imagen base: FROM
* Metadatos: LABEL
* Instrucciones de construcción: RUN, COPY, ADD, WORKDIR
* Configuración: Variable de entornos, usuarios, puertos: USER, EXPOSE, ENV
* Instrucciones de arranque: CMD, ENTRYPOINT

Veamos las principales instrucciones que podemos usar:

* **FROM**: Sirve para especificar la imagen sobre la que voy a construir la mía. Ejemplo: `FROM php:7.4-apache`.
* **LABEL**: Sirve para añadir metadatos a la imagen mediante clave=valor. Ejemplo: `LABEL company=iesalixar`.
* **COPY**: Para copiar ficheros desde mi equipo a la imagen. Esos ficheros deben estar en el mismo contexto (carpeta o repositorio). Su sintaxis es `COPY [--chown=<usuario>:<grupo>] src dest`. Por ejemplo: `COPY --chown=www-data:www-data myapp /var/www/html`.
* **ADD**: Es similar a COPY pero tiene funcionalidades adicionales como especificar URLs  y tratar archivos comprimidos.
* **RUN**: Ejecuta una orden creando una nueva capa. Su sintaxis es `RUN orden` / `RUN ["orden","param1","param2"]`. Ejemplo: `RUN apt update && apt install -y git`. En este caso es muy importante que pongamos la opción `-y` porque en el proceso de construcción no puede haber interacción con el usuario.
* **WORKDIR**: Establece el directorio de trabajo dentro de la imagen que estoy creando para posteriormente usar las órdenes RUN,COPY,ADD,CMD o ENTRYPOINT. Ejemplo: `WORKDIR /usr/local/apache/htdocs`.
* **EXPOSE**: Nos da información acerca de qué puertos tendrá abiertos el contenedor cuando se cree uno en base a la imagen que estamos creando. Es meramente informativo.  Ejemplo: `EXPOSE 80`.
* **USER**: Para especificar (por nombre o UID/GID) el usuario de trabajo para todas las órdenes RUN,CMD Y ENTRYPOINT posteriores. Ejemplos: `USER jenkins` / `USER 1001:10001`.
* **ARG**: Para definir variables para las cuales los usuarios pueden especificar valores a la hora de hacer el proceso de build mediante el flag `--build-arg`. Su sintaxis es `ARG nombre_variable` o `ARG nombre_variable=valor_por_defecto`. Posteriormente esa variable se puede usar en el resto de la órdenes de la siguiente manera `$nombre_variable`. Ejemplo: `ARG usuario=www-data`. No se puede usar con ENTRYPOINT Y CMD.
* **ENV**: Para establecer variables de entorno dentro del contenedor. Puede ser usado posteriormente en las órdenes RUN añadiendo $ delante de el nombre de la variable de entorno. Ejemplo: `ENV WEB_DOCUMENT_ROOT=/var/www/html`. No se puede usar con ENTRYPOINT Y CMD.
* **ENTRYPOINT**: Para establecer el ejecutable que se lanza siempre  cuando se crea el contenedor  con `docker run`, salvo que se especifique expresamente algo diferente con el flag `--entrypoint`. Su síntaxis es la siguiente: `ENTRYPOINT <command>` / `ENTRYPOINT ["executable","param1","param2"]`. Ejemplo: `ENTRYPOINT ["/usr/sbin/apache2ctl","-D","FOREGROUND"]`.
* **CMD**: Para establecer el ejecutable por defecto (salvo que se sobreescriba desde la orden `docker run`) o para especificar parámetros para un `ENTRYPOINT`. Si tengo varios sólo se ejecuta el último. Su sintaxis es `CMD param1 param2` / `CMD ["param1","param2"]` / `CMD["command","param1"]`. Ejemplo: `CMD [“-c” “/etc/nginx.conf”]`  / `ENTRYPOINT [“nginx”]`. 

Para una descripción completa sobre el fichero `Dockerfile`, puedes acceder a la [documentación oficial](https://docs.docker.com/engine/reference/builder/).

## Construyendo imágenes con docker build

El comando `docker build` construye la nueva imagen leyendo las instrucciones del fichero `Dockerfile` y la información de un **entorno**, que para nosotros va a ser un directorio (aunque también podemos guardar información, por ejemplo, en un repositorio git).

La creación de la imagen es ejecutada por el *docker engine*, que recibe toda la información del entorno, por lo tanto es recomendable guardar el `Dockerfile` en un directorio vacío y añadir los ficheros necesarios para la creación de la imagen. El comando `docker build` ejecuta las instrucciones de un `Dockerfile` línea por línea y va mostrando los resultados en pantalla.

Tenemos que tener en cuenta que cada instrucción ejecutada crea una imagen intermedia, una vez finalizada la construcción de la imagen nos devuelve su id. Algunas imágenes intermedias se guardan en **caché**, otras se borran. Por lo tanto, si por ejemplo, en un comando ejecutamos `cd /scripts/` y en otra linea le mandamos a ejecutar un script (`./install.sh`) no va a funcionar, ya que ha lanzado otra imagen intermedia. Teniendo esto en cuenta, la manera correcta de hacerlo sería:

```bash
cd /scripts/;./install.sh
```

Para terminar indicar que la creación de imágenes intermedias generadas por la ejecución de cada instrucción del `Dockerfile`, es un mecanismo de caché, es decir, si en algún momento falla la creación de la imagen, al corregir el `Dockerfile` y volver a construir la imagen, los pasos que habían funcionado anteriormente no se repiten ya que tenemos a nuestra disposición las imágenes intermedias, y el proceso continúa por la instrucción que causó el fallo.

## Ejemplo de  Dockerfile

Vamos a crear un directorio (**nuestro entorno**) donde vamos a crear un `Dockerfile` y un fichero `index.html`:

```bash
cd build
~/build$ ls
Dockerfile  index.html
```

El contenido de `Dockerfile` es:

```Dockerfile
FROM debian:buster-slim
MAINTAINER José Domingo Muñoz "josedom24@gmail.com"
RUN apt-get update  && apt-get install -y  apache2 
COPY index.html /var/www/html/
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

Para crear la imagen uso el comando `docker build`, indicando el nombre de la nueva imagen (opción `-t`) y indicando el directorio contexto.

```bash
$ docker build -t josedom24/myapache2:v2 .
...
```
> Nota: Pongo como directorio el `.` poruqe estoy ejecutando esta instrucción dentro del directorio donde está el `Dockerfile`.


Una vez terminado, podríamos ver que hemos generado una nueva imagen:

```bash
$ docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
josedom24/myapache2       v2                  3bd28de7ae88        43 seconds ago      195MB
...
```

Si usamos el parámetro `--no-cache` en `docker build` haríamos la construcción de una imagen sin usar las capas cacheadas por haber realizado anteriormente imágenes con capas similares.

En este caso al crear el contenedor a partir de esta imagen no hay que indicar el proceso que se va a ejecutar, porque ya se ha indicando en el fichero `Dockerfile`:

```bash
$ docker run -d -p 8080:80 --name servidor_web josedom24/myapache2:v2 
```            

## Buenas prácticas al crear Dockerfile

* **Los contenedores deber ser "efímeros"**: Cuando decimos "efímeros" queremos decir que la creación, parada, despliegue de los contenedores creados a partir de la imagen que vamos a generar con nuestro `Dockerfile` debe tener una mínima configuración.
* **Uso de ficheros `.dockerignore`**: Como hemos indicado anteriormente, todos los ficheros del contexto se envían al *docker engine*, es recomendable usar un directorio vacío donde vamos creando los ficheros que vamos a enviar. Además, para aumentar el rendimiento, y no enviar al daemon ficheros innecesarios podemos hacer uso de un fichero `.dockerignore`, para excluir ficheros y directorios.
* **No instalar paquetes innecesarios**: Para reducir la complejidad, dependencias, tiempo de creación y tamaño de la imagen resultante, se debe evitar instalar paquetes extras o innecesarios. Si algún paquete no es necesario durante la creación de la imagen, lo mejor es desinstalarlo durante el proceso.
* **Minimizar el número de capas**: Debemos encontrar el balance entre la legibilidad del Dockerfile y minimizar el número de capa que utiliza.
* **Indicar las instrucciones a ejecutar en múltiples líneas**: Cada vez que sea posible y para hacer más fácil futuros cambios, hay que organizar los argumentos de las instrucciones que contengan múltiples líneas, esto evitará la duplicación de paquetes y hará que el archivo sea más fácil de leer. Por ejemplo:

    ```bash
    RUN apt-get update && apt-get install -y \
    git \
    wget \
    apache2 \
    php5
    ```

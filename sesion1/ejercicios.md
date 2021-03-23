---
layout: default
title: Ejercicios
nav_order: 9
parent: Introducción
---

# Ejercicios

1. Instala docker en una máquina y configúralo para que se pueda usar con un usuario sin privilegios.
2. Ejecuta un contenedor a partir de la imagen `hello-word`. Comprueba que nos devuelve la salida adecuada. Comprueba que no se está ejecutando. Lista los contenedores que están parado. Borra el contenedor.
3. Crea un contenedor interactivo desde una imagen debian. Instala un paquete (por ejemplo `nano`). Sal de la terminal, ¿sigue el contenedor corriendo? ¿Por qué?. Vuelve a iniciar el contenedor y accede de nuevo a él de forma interactiva. ¿Sigue instalado el `nano`?. Sal del contenedor, y bórralo. Crea un nuevo contenedor interactivo desde la misma imagen. ¿Tiene el `nano` instalado?
4. Crea un contenedor demonio con un servidor nginx, usando la imagen oficial de nginx. Al crear el contenedor, ¿has tenido que indicar algún comando para que lo ejecute? Accede al navegador web y comprueba que el servidor esta funcionando. Muestra los logs del contenedor.
5. Crea un contenedor con la aplicación Nextcloud, mirando la [documentación en docker Hub](https://hub.docker.com/_/nextcloud), para personalizar el nombre de la base de datos sqlite que va a utilizar.
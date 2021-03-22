---
layout: default
title: Almacenamiento
nav_order: 4
has_children: true
---
# Almacenamiento en docker

**Los contenedores son efímeros**, es decir, los ficheros, datos y configuraciones que creamos en los contenedores sobreviven a las paradas de los mismos pero, sin embargo, son destruidos si el contenedor es destruido. 

Ante la situación anteriormente descrita Docker nos proporciona varias soluciones para persistir los datos de los contenedores:

* Los **volumenes docker**.
* Los **bind mount**

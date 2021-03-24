---
layout: default
title: "Instalación de docker-compose"
nav_order: 2
parent: Escenarios multicontenedor
---

# Instalación de docker-compose

La manera más sencilla de realizar la instalación de esta herramienta es utilizar el paquete de nuestra distribución:

```bash
apt install docker-compose
```

También se puede con `pip` en un entorno virtual:

```bash
python3 -m venv docker-compose
source docker-compose/bin/activate
(docker-compose) ~# pip install docker-compose
```

Puedes acceder a la [documentación oficial](https://docs.docker.com/compose/install/) para ver otras posibilidades de instalación.
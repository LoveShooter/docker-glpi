# ! Forked from DiouxX/docker-glpi !

# Project to deploy GLPI with docker

![Docker Pulls](https://img.shields.io/docker/pulls/loveshooter/glpi) ![Docker Stars](https://img.shields.io/docker/stars/loveshooter/glpi) [![](https://images.microbadger.com/badges/image/loveshooter/glpi.svg)](http://microbadger.com/images/loveshooter/glpi "Get your own image badge on microbadger.com") ![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/loveshooter/glpi)


# Table of Contents
- [Project to deploy GLPI with docker](#project-to-deploy-glpi-with-docker)
- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Deploy with CLI](#deploy-with-cli)
  - [Deploy GLPI](#deploy-glpi)
  - [Deploy GLPI with existing database](#deploy-glpi-with-existing-database)
  - [Deploy GLPI with database and persistence container data](#deploy-glpi-with-database-and-persistence-container-data)
  - [Deploy a specific release of GLPI](#deploy-a-specific-release-of-glpi)
- [Deploy with docker-compose](#deploy-with-docker-compose)
  - [Deploy without persistence data ( for quickly test )](#deploy-without-persistence-data--for-quickly-test)
  - [Deploy with persistence data](#deploy-with-persistence-data)
    - [mysql.env](#mysqlenv)
    - [docker-compose .yml](#docker-compose-yml)
- [Environnment variables](#environnment-variables)
  - [TIMEZONE](#timezone)

# Introduction

Install and run an GLPI instance with docker.

# Deploy with CLI

## Deploy GLPI 
```sh
docker run --name mysql -e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=glpidb -e MYSQL_USER=glpi_user -e MYSQL_PASSWORD=glpi -d mysql:5.7.32
docker run --name glpi --link mysql:mysql -p 80:80 -d loveshooter/glpi
```

## Deploy GLPI with existing database
```sh
docker run --name glpi --link yourdatabase:mysql -p 80:80 -d loveshooter/glpi
```

## Deploy GLPI with database and persistence data

For an usage on production environnement or daily usage, it's recommanded to use container with volumes to persistent data.

* First, create MySQL container with volume

```sh
docker run --name mysql -e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=glpidb -e MYSQL_USER=glpi_user -e MYSQL_PASSWORD=glpi --volume /var/lib/mysql:/var/lib/mysql -d mysql:5.7.32
```

* Then, create GLPI container with volume and link MySQL container

```sh
docker run --name glpi --link mysql:mysql --volume /var/www/html/glpi:/var/www/html/glpi -p 80:80 -d loveshooter/glpi
```

Enjoy :)

## Deploy a specific release of GLPI
Default, docker run will use the latest release of GLPI.
For an usage on production environnement, it's recommanded to set specific release.
Here an example for release 9.1.6 :
```sh
docker run --name glpi --hostname glpi --link mysql:mysql --volume /var/www/html/glpi:/var/www/html/glpi -p 80:80 --env "VERSION_GLPI=9.1.6" -d loveshooter/glpi
```

# Deploy with docker-compose

## Deploy without persistence data ( for quickly test )
```yaml
version: '3.7'

services:
  mysql:
    image: mysql:5.7.32
    restart: always
    container_name: mysql
    hostname: mysql
    volumes:
      - /var/lib/mysql:/var/lib/mysql
    env_file:
      - ./mysql.env
    networks:
      - glpi

  glpi:
    image: loveshooter/glpi:v1
    restart: always
    container_name : glpi
    hostname: glpi
    ports:
      - "8080:80"
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - /var/www/html/glpi/:/var/www/html/glpi
    environment:
      - TIMEZONE=Europe/Moscow
    networks:
      - glpi

networks:
  glpi:
    external: true
```

## Deploy with persistence data

To deploy with docker compose, you use *docker-compose.yml* and *mysql.env* file.
You can modify **_mysql.env_** to personalize settings like :

* MySQL root password
* GLPI database
* GLPI user database
* GLPI user password


### mysql.env
```
MYSQL_ROOT_PASSWORD=admin
MYSQL_DATABASE=glpidb
MYSQL_USER=glpi_user
MYSQL_PASSWORD=glpi
```
To deploy, just run the following command on the same directory as files

```sh
docker-compose up -d
```

# Environnment variables

## TIMEZONE
If you need to set timezone for Apache and PHP

From commande line
```sh
docker run --name glpi --hostname glpi --link mysql:mysql --volumes-from glpi-data -p 80:80 --env "TIMEZONE=Europe/Moscow" -d loveshooter/glpi
```

From docker-compose

Modify this settings
```yaml
environment:
     TIMEZONE=Europe/Moscow
```


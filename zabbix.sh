#!/bin/bash
echo "***ATENÇÃO:Apenas ambiente de testes não coloque suas senhas aqui, utilize variáveis de ambiente***"

sudo apt update -y
echo "Instalando o docker"

sudo apt install curl -y
sudo curl -fsSL https://get.docker.com | bash

sudo usermod -aG docker $USER
sudo newgrp docker
sudo chown $USER /var/run/docker.sock

#Instala o docker compose
sudo curl -L https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "testando o docker"

sudo docker ps
####Criando o arquivo compose
sudo touch docker-compose.yml



echo "version: '3.1'

networks:
  network-zabbix:
    driver: bridge

services:
  mysql:
    container_name: mysql
    image: mysql:5.7
    networks:
      - network-zabbix
    ports:
      - '3306:3306'
    volumes:
      - './zabbix/mysql:/var/lib/data'
    environment:
      - MYSQL_ROOT_PASSWORD=zabbix
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix

  zabbix-server:
    container_name: zabbix-server
    image: zabbix/zabbix-server-mysql:ubuntu-5.0.1
    networks:
      - network-zabbix
    links:
      - mysql
    restart: always
    ports:
      - '10051:10051'
    volumes:
      - './zabbix/alertscripts:/usr/lib/zabbix/alertscripts'
    environment:
      - DB_SERVER_HOST=mysql
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix
    depends_on:
      - mysql

  zabbix-frontend:
    container_name: zabbix-frontend
    image: zabbix/zabbix-web-apache-mysql:ubuntu-5.0.1
    networks:
      - network-zabbix
    links:
      - mysql
    restart: always
    ports:
      - '80:8080'
      - '443:8443'
    environment:
      - DB_SERVER_HOST=mysql
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix
      - PHP_TZ=America/Sao_Paulo
    depends_on:
      - mysql

  grafana:
    container_name: grafana
    image: grafana/grafana
    networks:
      - network-zabbix
    links:
      - mysql
      - zabbix-server
    restart: always
    ports:
      - '3000:3000'
    environment:
      - GF_INSTALL_PLUGINS=alexanderzobnin-zabbix-app
    depends_on:
      - mysql
      - zabbix-server
  zabbix-agent:
    container_name: zabbix-agent
    image: zabbix/zabbix-agent2:alpine-5.0.1
    user: root
    networks:
      - network-zabbix
    links:
      - zabbix-server
    restart: always
    privileged: true
    volumes:
      - /var/run:/var/run
    ports:
      - '10050:10050'
    environment:
      - ZBX_HOSTNAME=Zabbix server
      - ZBX_SERVER_HOST=172.18.0.1" > docker-compose.yml
sudo cp docker-compose.yml /home/ubuntu/
sudo cd /home/ubuntu/ ; sudo docker-compose up -d
#!/bin/bash
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
sudo apt-get update 
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo apt-get -y install apache2
sudo apt-get install -y php libapache2-mod-php php-mysql
sudo apt-get -y install mariadb-server
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo apache2ctl configtest
sudo systemctl restart apache2
sudo mkdir -p /var/www/html
sudo chown -R ubuntu:ubuntu /var/www/html



sudo mysql -u root -e "


CREATE USER 'guest'@'localhost' IDENTIFIED BY 'guest';

CREATE DATABASE IF NOT EXISTS web;

GRANT ALL PRIVILEGES ON web.* TO 'guest'@'localhost';

USE web; CREATE TABLE board(
no int(10) unsigned NOT NULL AUTO_INCREMENT,
id int(10) unsigned NOT NULL,
title varchar(50) NOT NULL,
content longtext NOT NULL,
date int(10) unsigned NOT NULL,
PRIMARY KEY (no)
) CHARSET=utf8;

CREATE TABLE user (
  memberId varchar(50) NOT NULL,
  pw varchar(100) NOT NULL,
  PRIMARY KEY (memberID)
) CHARSET=utf8;

FLUSH PRIVILEGES;"




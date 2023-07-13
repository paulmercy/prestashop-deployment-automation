#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install mysql-server -y
sudo systemctl enable mysql

# Create PrestaShop database and user
mysql -u root <<-EOF
CREATE DATABASE prestashop;
CREATE USER 'prestashop'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON prestashop.* TO 'prestashop'@'%';
FLUSH PRIVILEGES;
EOF

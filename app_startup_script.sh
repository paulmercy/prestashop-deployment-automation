#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install apache2 -y
sudo apt-get install php libapache2-mod-php php-mysql -y
sudo systemctl enable apache2

# Download and extract PrestaShop
wget https://download.prestashop.com/download/releases/prestashop_1.7.6.4.zip
sudo apt-get install unzip -y
unzip prestashop_1.7.6.4.zip -d /var/www/html/
sudo chown -R www-data:www-data /var/www/html/prestashop
sudo chmod -R 755 /var/www/html/prestashop

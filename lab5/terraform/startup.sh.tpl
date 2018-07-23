#!/bin/bash -xe

apt-get update
apt-get install -y apache2

echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html

systemctl enable apache2
systemctl restart apache2

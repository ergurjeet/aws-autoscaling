#!/bin/bash
sudo su
yum -y install httpd
echo "<h1>My user_data script works ok</h1>" >> /var/www/html/index.html
service httpd start
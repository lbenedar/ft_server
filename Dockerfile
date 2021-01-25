# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lbenedar <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/21 13:49:02 by lbenedar          #+#    #+#              #
#    Updated: 2021/01/24 21:57:08 by lbenedar         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM 		debian:buster
MAINTAINER	Lorette Benedar <lbenedar@student.21-school.ru>
WORKDIR		/

#Install LEMP and utils
RUN			apt-get -y update
RUN 		apt-get -y upgrade
RUN			apt-get -y install nginx
RUN			apt-get -y install vim wget
RUN			apt-get -y install php php-fpm php-mysql 
RUN			apt-get -y install mariadb-server mariadb-client
RUN			apt-get -y install php-mbstring php-zip php-gd php-xml php-pear php-gettext php-cgi

#Set up main directory
RUN			mkdir -p /scripts
WORKDIR		/scripts

#Set up DB and root in mysql
RUN			service mysql start \
			&& mysql -u root \
			&& mysql --execute="CREATE DATABASE wordpress_db DEFAULT CHARACTER SET utf8; \
								GRANT ALL PRIVILEGES ON wordpress_db.* TO 'root'@'localhost'; \
								SET PASSWORD FOR 'root'@'localhost' = PASSWORD('123456'); \
								FLUSH PRIVILEGES;"

#Set up phpMyAdmin
RUN			mkdir -p /var/www/lbenedar.com/phpmyadmin
RUN			chown -R $USER:$USER /var/www/lbenedar.com
RUN			wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN			tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/lbenedar.com/phpmyadmin
RUN			chown -R $USER:$USER /tmp
RUN			rm -rf phpMyAdmin-4.9.0.1-english.tar.gz

#Set up WordPress
RUN			mkdir -p /var/www/lbenedar.com/wordpress
RUN			chmod -R 777 /var/www/lbenedar.com/wordpress
RUN			wget https://wordpress.org/latest.tar.gz
RUN			tar xzf latest.tar.gz --strip-components=1 -C /var/www/lbenedar.com/wordpress
RUN			rm -rf latest.tar.gz

#Set up nginx
RUN			rm -f /etc/nginx/sites-available/default
RUN			rm -f /etc/nginx/sites-enabled/default
RUN			ln -s /etc/nginx/sites-available/lbenedar.com /etc/nginx/sites-enabled/
RUN			cp /var/www/html/index.nginx-debian.html /var/www/lbenedar.com/

#Create file for php testing
RUN			echo "<?php phpinfo(); ?>" >> /var/www/lbenedar.com/info.php

#Copy all scripts
RUN			mkdir -p nginx_conf
COPY		./srcs/startup.sh .
COPY		./srcs/nginx_ai_on.sh .
COPY		./srcs/nginx_ai_off.sh .
COPY		./srcs/nginx_ai_on.conf nginx_conf
COPY		./srcs/nginx_ai_off.conf nginx_conf
COPY		./srcs/config.inc.php /var/www/lbenedar.com/phpmyadmin/
COPY		./srcs/nginx_ai_on.conf /etc/nginx/sites-available/lbenedar.com
COPY		./srcs/wp_config.php /var/www/lbenedar.com/wordpress/wp_config.php

#Set up SSL
COPY		./srcs/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
COPY		./srcs/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
COPY		./srcs/nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key
COPY		./srcs/generate_ssl.sh .

#Set up volumes
VOLUME 		/var/lib/mysql/
VOLUME 		/var/www/lbenedar.com/wordpress

#Ports that will be listened
EXPOSE		80 443

#EXEC
CMD			bash startup.sh
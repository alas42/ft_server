FROM debian:buster
LABEL maintainer=avogt@42.student.fr

#install utils
RUN apt-get update && apt-get upgrade
RUN apt-get install -y apt-utils
RUN apt-get -y install mariadb-server php7.3 php-mysql php-fpm php-cli php-mbstring
RUN apt-get -y install wget nginx

#download and decompress phpMyAdmin and wordpress
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
RUN wget -c https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz
RUN tar xzf phpMyAdmin-5.0.2-all-languages.tar.gz
RUN mv wordpress /var/www/html/
RUN mv phpMyAdmin-5.0.2-all-languages /var/www/html/phpmyadmin
RUN rm phpMyAdmin-5.0.2-all-languages.tar.gz
RUN rm latest.tar.gz

#copy config files and script and remove index.nginx for autoindex
COPY /srcs/start.sh /
COPY /srcs/nginx_config /etc/nginx/sites-available/localhost
COPY /srcs/phpMyAdmin_config.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY /srcs/wordpress_config.php /var/www/html/wordpress/wp-config.php
COPY /srcs/wp_db.sh /
RUN rm -f /etc/nginx/sites-enabled/default && rm -f /var/www/html/index.nginx-debian.html

#create link
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
#create a db
RUN sh wp_db.sh
#create certificates ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssl/certs/localhost.pem -keyout /etc/ssl/certs/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42/CN=avogt"
#change the rights
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

CMD ["bash", "./start.sh"]

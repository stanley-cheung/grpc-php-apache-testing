FROM debian:jessie
RUN apt-get update && apt-get install -y -q apache2 php5 php5-dev phpunit php-pear
RUN echo "deb http://ftp.us.debian.org/debian jessie-backports main" | tee -a /etc/apt/sources.list
ENV GRPC_VERSION 0.11.0.0-1~bpo8+2
RUN apt-get update && apt-get install -y -q libgrpc-dev=${GRPC_VERSION}
RUN pecl install grpc-beta
RUN echo "extension=grpc.so" >> /etc/php5/apache2/conf.d/30-grpc.ini
ADD grpc.php /var/www/html/grpc.php
ADD start.sh /var/www/html/start.sh
CMD ["/var/www/html/start.sh"]

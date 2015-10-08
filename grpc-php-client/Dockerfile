FROM debian:jessie

# install PHP and Apache
RUN apt-get update && apt-get install -y -q apache2 git php5 php5-dev phpunit php-pear unzip

# install some more dependencies: ruby, rake, ronn, nodejs, composer etc
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN /bin/bash -l -c "gem install ronn rake"
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs
RUN cd /usr/local/bin && curl -sS https://getcomposer.org/installer | php
RUN cd /usr/local/bin && mv composer.phar composer

# clone gRPC repo
RUN git clone https://github.com/grpc/grpc /var/www/grpc
RUN cd /var/www/grpc && git checkout release-0_11
RUN cd /var/www/grpc && git pull --recurse-submodules && git submodule update --init --recursive

# install protoc compiler
RUN cd /var/www/grpc/third_party/protobuf && ./autogen.sh && ./configure && make && make install

# install gRPC PHP library
RUN cd /var/www/grpc/src/php && composer install

# install protoc-gen-php plugin
RUN cd /var/www/grpc/src/php/vendor/datto/protobuf-php && /bin/bash -l -c "rake pear:package version=1.0"
RUN cd /var/www/grpc/src/php/vendor/datto/protobuf-php && pear install Protobuf-1.0.tgz

# install gRPC core library
ENV GRPC_VERSION 0.11.0.0-1~bpo8+2
RUN echo "deb http://ftp.us.debian.org/debian jessie-backports main" | tee -a /etc/apt/sources.list
RUN apt-get update && apt-get install -y -q libgrpc-dev=${GRPC_VERSION}

# install gRPC PHP extension
RUN pecl install grpc-beta
RUN echo "extension=grpc.so" >> /etc/php5/apache2/conf.d/30-grpc.ini

# generate PHP client stub from proto
RUN cd /var/www/grpc/src/php/tests/generated_code && protoc-gen-php -i . -o . ./math.proto

# install gRPC Node examples
RUN cd /var/www/grpc/src/node && npm install --unsafe-perm

# add sample scripts
ADD math_client.php /var/www/html/math_client.php
ADD start.sh /var/www/html/start.sh
CMD ["/var/www/html/start.sh"]

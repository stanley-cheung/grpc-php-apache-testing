# grpc-php-apache-testing
A docker image to debug gRPC PHP extension issue when running behind Apache

gRPC is an open source, general RPC framework library written in C
 - GitHub project: https://github.com/grpc/grpc
 - Website: http://grpc.io

We built a PHP extension on top of the core gRPC library, released in PECL:
 - PECL extension: https://pecl.php.net/package/grpc
 - Source code: https://github.com/grpc/grpc/tree/master/src/php/ext/grpc

High-level problem description:
 - We have a very simple setup that can reproduce the issue
 - We started a base docker image with debian:jessie, apache2, php5.6
 - We then install the gRPC debian package `libgrpc-dev` version 0.11 (currently beta)
 - Then we install the `Grpc` PHP extension with `pecl install`
 - At this point the `Grpc` extension is fully functional on CLI, no error is found
 - However, if we try to use the `Grpc` extension behind Apache, after hitting the script a few times, just to access a constant the extension exposed, Apache/PHP returns a `Fatal error: Undefined constant`.
 - This cannot be reproduced if the script is accessed via CLI.

Steps to reproduce:
 - Clone this repository: `git clone https://github.com/stanley-cheung/grpc-php-apache-testing.git`
 - Build the docker image: `docker build -t grpc_php_testing grpc-php-apache-testing/`
 - Run the Apache server: `docker run -it --rm --name grpc_php_instance -p 9998:80 grpc_php_testing`
 - From another terminal, try to access `grpc.php`: `curl localhost:9998/grpc.php`

The first few times the script will return fine:
```sh
docker:~$ curl localhost:9998/grpc.php
constant OP_SEND_CLOSE_FROM_CLIENT = 2. should be 2
```

After perhaps 4-6 times, it will start returning this error:
```
[Mon Oct 05 17:31:56.395267 2015] [:error] [pid 16] [client 172.17.42.1:45444] PHP Fatal error:  Undefined constant 'Grpc\\OP_SEND_CLOSE_FROM_CLIENT' in /var/www/html/grpc.php on line 2
```

You can explore the instance by:
``` sh
docker:~$ docker exec -it grpc_php_instance /bin/bash
```

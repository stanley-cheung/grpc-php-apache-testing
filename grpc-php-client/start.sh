#!/bin/bash                                                                                                                                            
apache2ctl start
nodejs /var/www/grpc/src/node/examples/math_server.js &
tail -f /var/log/apache2/error.log

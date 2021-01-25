#!/bin/bash

service nginx start
service mysql start 2> /dev/null
service php7.3-fpm start
service --status-all
bash
#!/bin/bash

cp -a /scripts/nginx_conf/nginx_ai_on.conf /etc/nginx/sites-available/lbenedar.com
service nginx reload
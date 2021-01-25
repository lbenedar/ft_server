#!/bin/bash

cp -a /scripts/nginx_conf/nginx_ai_off.conf /etc/nginx/sites-available/lbenedar.com
service nginx reload
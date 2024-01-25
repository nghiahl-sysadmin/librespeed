#!/bin/bash

cert_file="/var/www/letsencrypt/certs/live/librespeed.nghiahl.cloud/fullchain.pem"
reload_flag="/opt/healthcheck/reload_flag"

if [ -f "$cert_file" ] && [ ! -f "$reload_flag" ]; then
    service apache2 reload
    touch "$reload_flag"
    exit 0
elif [ -f "$reload_flag" ]; then
    exit 0
else
    exit 1
fi

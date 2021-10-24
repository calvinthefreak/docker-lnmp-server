#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

phpver=$(php -r "phpinfo();" | grep "php.ini" | grep -o '/etc/php/.*/' -m 1 | grep -oh '[0-9\.]' |tr -d '\n'|tr @ '\n')
find /etc/nginx/ -type f | while read -r line; do
    sed -i "/unix:\/var\/run\/php\/php/s/.*/\t\tfastcgi_pass\ unix\:\/var\/run\/php\/php${phpver}\-fpm\.sock\;/" $line && exit 0;
done

/etc/init.d/php*-fpm restart && nginx -g "daemon off;"

# docker build -t 64i.de/lnmp-server .
FROM ubuntu:latest
COPY cmd.sh /cmd.sh

RUN apt update \
    && apt install -y \
    php-fpm \
    php-bz2 \
    php-json \
    php-mysql \
    php-gd \
    php-curl \
    php-gmp \
    php-intl \
    php-mbstring \
    php-pgsql \
    php-xml \
    php-zip \
    php-imagick \
    nginx \
    nano \
    && apt clean \
    && chmod +x /cmd.sh \
    phpver=$(php -r "phpinfo();" | grep "php.ini" | grep -o '/etc/php/.*/' -m 1 | grep -oh '[0-9\.]' |tr -d '\n'|tr @ '\n') \
    find /etc/nginx/ -type f | while read -r line; do \
        sed -i "/unix:\/var\/run\/php\/php/s/.*/\t\tfastcgi_pass\ unix\:\/var\/run\/php\/php${phpver}\-fpm\.sock\;/" $line && exit 0; \
    done

EXPOSE 80

VOLUME [ "/etc/nginx", "/var/www" ]

ENTRYPOINT ["/bin/bash"]
CMD ["/cmd.sh"]

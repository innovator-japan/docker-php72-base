FROM php:7.2.10-fpm-alpine

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

RUN apk upgrade --update \
    && apk add --no-cache \
       zlib-dev libpng-dev \
       nginx \
    && docker-php-ext-install pdo_mysql zip gd opcache \
    && mkdir /run/nginx \
    && mkdir /var/www/public \
    && rm -rf /var/cache/apk/*

RUN wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-v0.6.1.tar.gz \
    && rm dockerize-alpine-linux-amd64-v0.6.1.tar.gz

COPY default.conf /etc/nginx/conf.d/default.conf
COPY run.sh /usr/local/bin/run.sh
COPY index.php /var/www/public/index.php

WORKDIR /var/www/public

CMD ["run.sh"]

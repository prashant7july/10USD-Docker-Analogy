#FROM php:7.0-cli
FROM php:7.1.9-apache

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install -y zip unzip curl git \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"
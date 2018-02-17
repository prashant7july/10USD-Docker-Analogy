FROM ubuntu:16.04

MAINTAINER Prashant Shekher

# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales
# docker ubuntu /bin/sh: 1: locale-gen: not found then set RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add Composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update \
    && apt-get install -y curl zip unzip git software-properties-common sqlite3 \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php7.0-fpm php7.0-cli php7.0-mcrypt php7.0-gd php7.0-mysql \
       php7.0-pgsql php7.0-imap php-memcached php7.0-mbstring php7.0-xml php7.0-curl \
       php7.0-sqlite3 php7.0-xdebug \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get remove -y --purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY xdebug.ini /etc/php/7.0/mods-available/xdebug.ini

COPY start-container /usr/local/bin/start-container
RUN chmod +x usr/local/bin/start-container

EXPOSE 80
CMD ["start-container"]
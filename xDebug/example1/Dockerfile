FROM ubuntu:16.04

MAINTAINER Prashant Shekher

# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales
# docker ubuntu /bin/sh: 1: locale-gen: not found then set RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

# OR
# Set the locale
# RUN apt-get clean && apt-get -y update && apt-get install -y locales && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add Composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Basic packages [https://github.com/shincoder/homestead-docker/blob/master/provision.sh]
# RUN apt-get install -y \
#     sudo \
#     software-properties-common \
#     nano \
#     curl \
#     build-essential \
#     dos2unix \
#     gcc \
#     git \
#     git-flow \
#     libmcrypt4 \
#     libpcre3-dev \
#     apt-utils \
#     make \
#     python2.7-dev \
#     python-pip \
#     re2c \
#     supervisor \
#     unattended-upgrades \
#     whois \
#     vim \
#     zip \
#     unzip

# Install Ubuntu packages
# RUN apt-get install -y \
#         build-essential \
#         curl \
#         git \
#         libcurl4-openssl-dev \
#         libicu-dev \
#         libmcrypt-dev \
#         libmysqlclient-dev \
#         libpng-dev \
#         mysql-client \
#         ruby-full \
#         software-properties-common \
#         vim \
#         zip \
#         unzip \
#         sqlite3

# Install PHP (5.6, 7.0, 7.1) on Ubuntu Using PPA
# RUN add-apt-repository -y ppa:ondrej/php \
#     && apt-get update \
#     && apt-get install -y php7.0-fpm php7.0-cli php7.0-mcrypt php7.0-gd php7.0-mysql \
#     php7.0-pgsql php7.0-imap php-memcached php7.0-mbstring php7.0-xml php7.0-curl \
#     php7.0-sqlite3 php7.0-xdebug \

# PHP 7.1
# apt-get install -y php7.1-cli php7.1-dev \
# php7.1-mysql php7.1-pgsql php7.1-sqlite3 php7.1-soap \
# php7.1-json php7.1-curl php7.1-gd \
# php7.1-gmp php7.1-imap php7.1-mcrypt php-xdebug \
# php7.1-mbstring php7.1-zip \
# php-pear php-apcu php-memcached php-redis

# Cannot add PPA: 'ppa:ondrej/php5-5.6' https://stackoverflow.com/questions/40567133/cannot-add-ppa-ppaondrej-php5-5-6
# RUN add-apt-repository ppa:ondrej/php
#     && apt-get update
#     && apt-get -y install php5.6 php5.6-mcrypt php5.6-mbstring php5.6-curl php5.6-cli php5.6-mysql php5.6-gd php5.6-intl php5.6-xsl php5.6-zip

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

# OR https://gist.github.com/mindscratch/5bfc0578feb7d5d534366c680b422f1b
# RUN echo "xdebug.idekey = PHPSTORM" >> /etc/php.d/xdebug.ini && 
# echo "xdebug.default_enable = 0" >> /etc/php.d/xdebug.ini && 
# echo "xdebug.remote_enable = 1" >> /etc/php.d/xdebug.ini && 
# echo "xdebug.remote_autostart = 0" >> /etc/php.d/xdebug.ini && 
# echo "xdebug.remote_connect_back = 0" >> /etc/php.d/xdebug.ini && 
# echo "xdebug.profiler_enable = 0" >> /etc/php.d/xdebug.ini && 
# echo "xdebug.remote_host = 10.254.254.254" >> /etc/php.d/xdebug.ini

COPY start-container /usr/local/bin/start-container
RUN chmod +x usr/local/bin/start-container

EXPOSE 80
CMD ["start-container"]

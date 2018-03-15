# Project structure:
https://gitlab.com/jorgediz/laradoc/tree/multiple-projects
``` 
myproject.
├── data -> Create a folder for storing various data of the project, such as database file, logs, (chmod -R 0777 data/ to remove issues Service 'mysql' failed to build on fresh install )
├── laradock -> git clone https://github.com/laradock/laradock.git
└── zendframework -> git clone https://github.com/zendframework/zendframework.git OR https://github.com/akrabat/zf2-tutorial
    ├── CHANGELOG.md
    ├── composer.json
    ├── CONDUCT.md
    ├── CONTRIBUTING.md
    ├── LICENSE.md
    ├── README.md
    └── resources
        └── ZendFramework-logo.png
```
```
$ cd laradock/
$ cp env-example .env
```

Then open the. Env file to modify the additional config.
 * LineNo 8 to run to our zendframework folder by adding zendframework to APPLICATION = ../zendframework
 * LineNo13 Now I change the path to the volume named data we have created. DATA_SAVE_PATH = ../data

**nginx/sites/default.conf**
change **root /var/www/public;** => **root /var/www;** (in LineNo 7)

#### 1 - Run Containers:(Make sure you are in the laradock folder before running the docker-composer commands)
docker-compose up -d nginx php-fpm mysql phpmyadmin

**Issues & their Solution**
 * Service 'mysql' failed to build on fresh install (Solution - chmod -R 755 data/)
 * ERROR: Service 'mysql' failed to build: Please provide a source image with `from` prior to commit  (Solution - https://fabianlee.org/2017/03/07/docker-installing-docker-ce-on-ubuntu-14-04-and-16-04/)

**Issues 3**
```
WARNING: Image for service nginx was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating laradock_mysql_1 ... 
Creating laradock_applications_1 ... 
Creating laradock_applications_1
Creating laradock_mysql_1 ... error

ERROR: for laradock_mysql_1  Cannot start service mysql: driver failed programming external connectivity on endpoint laradock_mysql_1 (e1becd597ccfd3e904f40709fb713cb02b7d40ed29c73efbe663ee0add5ad1ab): Error starting userland proxy: listen tcp 0.0.0.0:3306: bind: address already in use
Creating laradock_workspace_1 ... 
Creating laradock_workspace_1 ... done
Creating laradock_php-fpm_1 ... 
Creating laradock_php-fpm_1 ... done
Creating laradock_nginx_1 ... 
Creating laradock_nginx_1 ... error

ERROR: for laradock_nginx_1  Cannot start service nginx: driver failed programming external connectivity on endpoint laradock_nginx_1 (02d72d652131fd1d81379131d76afd810bcec9780301991cd542d1931101f6a5): Error starting userland proxy: listen tcp 0.0.0.0:80: listen: address already in use

ERROR: for nginx  Cannot start service nginx: driver failed programming external connectivity on endpoint laradock_nginx_1 (02d72d652131fd1d81379131d76afd810bcec9780301991cd542d1931101f6a5): Error starting userland proxy: listen tcp 0.0.0.0:80: listen: address already in use

ERROR: for mysql  Cannot start service mysql: driver failed programming external connectivity on endpoint laradock_mysql_1 (e1becd597ccfd3e904f40709fb713cb02b7d40ed29c73efbe663ee0add5ad1ab): Error starting userland proxy: listen tcp 0.0.0.0:3306: bind: address already in use
ERROR: Encountered errors while bringing up the project.
````
**Solution**
```
0.0.0.0:80
0.0.0.0:3306
bind: address already in use

you host os already run service bind port 80, 3306.
stop related service then run docker-compose up again.

### PHP MY ADMIN
Change PMA_PORT=8080 to PMA_PORT=8081

### MYSQL
Change MYSQL_PORT=3306 TO MYSQL_PORT=3307

### NGINX
Change NGINX_HOST_HTTP_PORT=8082 TO NGINX_HOST_HTTP_PORT=8083
```

And you can simply curl using curl localhost:8082

#### Issues getting 
403 Forbidden
nginx

#### Solution:

Just add index.php with phpinfo(); in zendframework directory
Then run the below command
```
docker-compose up -d --force-recreate --build nginx
```

#### My .env differences:
```
$ diff -f env-example .env
c8
APPLICATION=../zendframework
.
c23
DATA_SAVE_PATH=../data
.
c134 135
NGINX_HOST_HTTP_PORT=8082
NGINX_HOST_HTTPS_PORT=8083
.
c157
MYSQL_PORT=3307
.
c251
PMA_PORT=8081
.
```

#### Serve Site With NGINX (HTTP ONLY)
```
Go back to command line

$laradock# cd nginx
$laradock/nginx# vim laravel.conf

remove default_server
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

and add server_name (your custom domain)
    listen 81;
    listen [::]:81 ipv6only=on;
    server_name yourdomain.com;
```

#### Use custom Domain (instead of the Docker IP)

Assuming your custom domain is laravel.dev

1 - Open your /etc/hosts file and map your localhost address 127.0.0.1 to the laravel.dev domain, by adding the following:

127.0.0.1    laravel.dev
127.0.0.1    yourdomain.com
sudo sh -c 'echo "127.0.0.1 http://dockerzend.dev" >> /etc/hosts'

2 - Open your browser and visit {http://laravel.dev}{http://yourdomain.com}

Optionally you can define the server name in the nginx config file, like this:

server_name laravel.dev;
server_name yourdomain.com;

#### 2 - Enter the workspace container to execute the command like (composer etc)
```
abc@abc-To-be-filled-by-O-E-M:/var/www/html/php/dockertest/laradock$ docker-compose exec workspace bash
root@0293804886b4:/var/www# ls -l
total 308
-rw-rw-r-- 1 laradock laradock 276914 Mar  9 07:21 CHANGELOG.md
-rw-rw-r-- 1 laradock laradock   3450 Mar  9 07:21 composer.json
-rw-rw-r-- 1 laradock laradock   2378 Mar  9 07:21 CONDUCT.md
-rw-rw-r-- 1 laradock laradock   9798 Mar  9 07:21 CONTRIBUTING.md
-rw-rw-r-- 1 laradock laradock   1517 Mar  9 07:21 LICENSE.md
-rw-rw-r-- 1 laradock laradock   7935 Mar  9 07:21 README.md
drwxrwxr-x 2 laradock laradock   4096 Mar  9 07:21 resources
root@0293804886b4:/var/www# composer install
```


## https://github.com/laradock/laradock/issues/152
## To enable self-signed certificates, follow this steps:
#### 1 - add this lines to your nginx Dockerfile:

```
# install openssl
RUN apk add --no-cache openssl

# create a folder for the keys
RUN mkdir /etc/nginx/ssl 2> /dev/null

# generate the keys for your local domain
RUN openssl genrsa -out "/etc/nginx/ssl/YOURLOCALDOMAIN.key" 2048 \
    && openssl req -new -key "/etc/nginx/ssl/YOURLOCALDOMAIN.key" -out "/etc/nginx/ssl/YOURLOCALDOMAIN.csr" -subj "/CN=YOURLOCALDOMAIN/O=YOURCOMPANYNAME/C=UK" \
    && openssl x509 -req -days 365 -in "/etc/nginx/ssl/YOURLOCALDOMAIN.csr" -signkey "/etc/nginx/ssl/YOURLOCALDOMAIN.key" -out "/etc/nginx/ssl/YOURLOCALDOMAIN.crt"
```

#### 2 - update your site.conf file:

```
listen 80;
listen 443 ssl;
listen [::]:80;

ssl_certificate     /etc/nginx/ssl/YOURLOCALDOMAIN.local.crt;
ssl_certificate_key /etc/nginx/ssl/YOURLOCALDOMAIN.local.key;
```

https://github.com/laradock/laradock/issues/977
```
// folder structure
+ laradock
+ phpshop
  + public
+ phpcrm
  + public
+ nonlaravelapp
  - index.php
  
// file .env
APPLICATION=../
cp nginx/sites/project-1.conf.example nginx/sites/phpshop.conf
cp nginx/sites/project-1.conf.example nginx/sites/phpcrm.conf
cp nginx/sites/project-1.conf.example nginx/sites/nonlaravelapp.conf

// edit phpshop.conf
server {
    listen 80;
    listen [::]:80;

    server_name phpshop.dev;
    root /var/www/phpshop/public;
    index index.php index.html index.htm;

    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass php-upstream;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt/;
        log_not_found off;
    }
}

// edit phpcrm.conf
server {
    listen 80;
    listen [::]:80;

    server_name phpcrm.dev;
    root /var/www/phpcrm/public;
    index index.php index.html index.htm;

    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass php-upstream;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt/;
        log_not_found off;
    }
}

// edit nonlaravelapp.conf
server {
    listen 80;
    listen [::]:80;

    server_name nonlaravelapp.dev;
    root /var/www/nonlaravelapp;
    index index.php index.html index.htm;

    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass php-upstream;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt/;
        log_not_found off;
    }
}

// edit host os /etc/hosts and add IP/Hostname mapping
127.0.0.1  phpshop.dev
127.0.0.1  phpcrm.dev
127.0.0.1  nonlaravelapp.dev
OR
sudo sh -c 'echo "127.0.0.1 http://phpshop.dev" >> /etc/hosts'
sudo sh -c 'echo "127.0.0.1 http://phpcrm.dev" >> /etc/hosts'
sudo sh -c 'echo "127.0.0.1 http://nonlaravelapp.dev" >> /etc/hosts'
```

# Single Project Setup

```
// folder structure
+ laradock
+ zf2-tutorial
  + public
+ data

$ diff -f env-example .env

c8
APPLICATION=../
.
c23
DATA_SAVE_PATH=../data
.
c134 135
NGINX_HOST_HTTP_PORT=8082
NGINX_HOST_HTTPS_PORT=8083
.
c157
MYSQL_PORT=3307
.
c251
PMA_PORT=8081
.

// file .env
APPLICATION=../

$ cp nginx/sites/laravel.conf.example nginx/sites/zf2-tutorial.conf

server {

    listen 80;
    listen [::]:80;

    server_name zf2-tutorial.dev;
    root /var/www/zf2-tutorial/public;
    index index.php index.html index.htm;

    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass php-upstream;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        #fixes timeouts
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt/;
        log_not_found off;
    }

    error_log /var/log/nginx/zf2-tutorial_error.log;
    access_log /var/log/nginx/zf2-tutorial_access.log;
}
```

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)

docker-compose up -d nginx php-fpm mysql phpmyadmin
#### Issues
Building mysql
Step 1/10 : ARG MYSQL_VERSION=8.0
Step 2/10 : FROM mysql:${MYSQL_VERSION}
ERROR: Service 'mysql' failed to build: Get https://registry-1.docker.io/v2/: net/http: TLS handshake timeout

#### Solution
May be network issues so please try again same command 
```
docker-compose up -d nginx php-fpm mysql phpmyadmin
```

// edit host os /etc/hosts and add IP/Hostname mapping
127.0.0.1  zf2-tutorial.dev
OR
sudo sh -c 'echo "127.0.0.1 http://zf2-tutorial.dev" >> /etc/hosts'

http://localhost:8082/ OR curl localhost:8082

#### Single Project Run
```
// folder structure
+ laradock [Docker Library - git clone https://github.com/laradock/laradock.git]
+ zf2-tutorial(git clone https://github.com/akrabat/zf2-tutorial)
  + public
  - index.php [Resolving issues 403 Forbidden nginx when APPLICATION=../ in .env & root /var/www/nonlaravelapp; in nginx/sites/zf2-tutorial.conf]
+ data [Create a folder for storing various data of the project, such as database file, logs, (chmod -R 0777 data/ to remove issue - Service 'mysql' failed to build on fresh install)]
  

$ cd laradock
$ cp env-example .env [Modify As below]
$ diff -f env-example .env

c23
DATA_SAVE_PATH=../data
.
c134 135
NGINX_HOST_HTTP_PORT=8082
NGINX_HOST_HTTPS_PORT=8083
.
c157
MYSQL_PORT=3307
.
c251
PMA_PORT=8081
.


Create zf2-tutorial.conf in nginx/sites folder

server {

    listen 80;
    listen [::]:80;

    server_name zf2-tutorial.dev;
    root /var/www/zf2-tutorial;
    index index.php index.html index.htm;

    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass php-upstream;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        #fixes timeouts
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt/;
        log_not_found off;
    }

    error_log /var/log/nginx/zf2-tutorial_error.log;
    access_log /var/log/nginx/zf2-tutorial_access.log;
}

docker-compose exec workspace bash
```


# How to setup Multiple Project?
 * https://github.com/laradock/laradock/issues/425
 * https://github.com/docker/compose/issues/3729

My problem with your suggestion is that docker-compose.override.yml might not exist (it's an optional file the developer can create locally). I only want to use docker-compose.override.yml to locally customize ports, like this:

docker-compose.yml:
```
version: '2'
services:
    web:
        ports:
            - 80
            - 443
        ...
```
docker-compose.override.yml:
```
version: '2'
services:
    web:
        ports:
            - 32080:80
            - 32443:443
```

This isn't a big deal because this will only result in 80 being exposed twice, once as a random port and once as 32080. I think it would make sense in this case to only expose it as 32080 automatically (without having to specify anything in the override to remove the original config value)
```
$ docker-compose -f docker-compose.override.yml -f docker-compose.dev.yml up
$ docker-compose -f docker-compose.override.yml -f docker-compose.dev.yml up -d nginx php-fpm mysql phpmyadmin
$ docker-compose -f docker-compose.dev.yml up -d nginx php-fpm mysql phpmyadmin
```
I haven't been using the APPLICATION variable for multiple/single project, I've put mine in docker-compose.dev.yml, one line per app. The only point of docker-compose.dev.yml is to keep necessary local changes out of docker-compose.yml so when you git pull to update laradock it doesn't conflict.

#### Folder Structure
```
.
├── client1
│   ├── api1
│   └── api2
├── data
└── laradock
```

#### In docker-compose development file - docker-compose.dev.yml
```
version: "2"
services:

### Applications Code Container #############################

    applications:
      volumes:
        - ../client1/app1/:/var/www/app1
        - ../client1/app2/:/var/www/app2
```


# Under Testing Code

```
.
├── client1
│   ├── api1 (url -> api1.loc)
│   │   └── index.php
│   └── api2 (url -> api2.loc)
│       └── index.php
├── data
└── laradock

$ chmode 777 -R data/
$ cd laradock
$ git clone https://github.com/laradock/laradock.git ./
$ cp env-example .env
$ diff -f env-example .env
c23
DATA_SAVE_PATH=../data
.
c134 135
NGINX_HOST_HTTP_PORT=8082
NGINX_HOST_HTTPS_PORT=8082
.
c157
MYSQL_PORT=3307
.
c251
PMA_PORT=8081
.

Change docker-compose development file - docker-compose.dev.yml

version: "2"
services:

### Applications Code Container #############################

    applications:
      volumes:
        - ../client1/app1/:/var/www/app1
        - ../client1/app2/:/var/www/app2


$ docker-compose -f docker-compose.dev.yml -f up -d nginx php-fpm mysql phpmyadmin

```


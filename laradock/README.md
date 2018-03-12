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

## Issues getting 
403 Forbidden
nginx

## Solution:

Just add index.php with phpinfo(); in zendframework directory

```
docker-compose up -d --force-recreate --build nginx
```

```
My .env differences:

$ diff -f env-example .env
c8
APPLICATION=../test/
c23
DATA_SAVE_PATH=/volume1/docker/laradock/data
c36
DOCKER_HOST_IP=172.17.0.1
c126 127
NGINX_HOST_HTTP_PORT=8081
NGINX_HOST_HTTPS_PORT=8082
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

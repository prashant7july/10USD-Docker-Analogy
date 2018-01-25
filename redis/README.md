# Reference Link
## [LINK1](https://github.com/aprice-/redisclustercompose) 
## [LINK2](https://get-reddie.com/blog/redis4-cluster-docker-compose/)
### Redis cluster using docker compose compatible with --scale argument
## [LINK](https://github.com/Grokzen/docker-redis-cluster)
### Redis cluster using docker compose compatible with --scale argument
## [LINK](https://www.alibabacloud.com/forum/read-393)
### High-availability Redis cluster in Docker
## [LINK](https://github.com/AliyunContainerService/redis-cluster)
### Redis Cluster with Sentinel by Docker Compose
* Reference
 *[LINK](https://github.com/Zookal/DocHarris)
 *[LINK](https://cloudkul.com/blog/integrate-magento-2-varnish-cache-redis-server-ssl-termination-using-docker-compose/)
 *[LINK](https://github.com/mikechernev/redis-webui)
 *[LINKBOOK](https://github.com/mikechernev/programming-ebooks/blob/master/Cheat%20Sheets/Rails.pdf)
 *[LINK - ubuntu](https://github.com/webkul/magento2-varnish-redis-ssl-docker-compose)
 *[LINK - IMP](https://stackoverflow.com/questions/33304388/calling-redis-cli-in-docker-compose-setup?rq=1)
 *[LINK](http://kuga.me/2016/07/22/docker-redis-cluster/)
 *[LINK](https://www.snip2code.com/Snippet/1906152/Redis-Cluster-with-Docker-Compose-v3)
 *[LINK](https://o-my-chenjian.com/2017/05/24/Deploy-Redis-Cluster-By-Docker/)
 *[LINK](https://github.com/vishnudxb/docker-redis-cluster)



```
We need to adjust our Nginx image so it expects to serve a PHP application. Then we can get the two containers talking to eachother.

Test Files

First, we'll create some PHP to run and test with on our host machine:

mkdir -p application/public
echo "<?php phpinfo();" > application/public/index.php

We're going to link together a few containers and more of a full stack that we can use for a real application.

We'll run the following containers:

Nginx
PHP-FPM
MySQL
Redis
These containers will be linked together so they can communicate with eachother - something like this:

Nginx (80:80) --> PHP-FPM (--name, --link)  -> Redis/MySQL (--name, --link)
We'll start with the tail end (data containers) and work our way forward to the Nginx containers.

# Data containers. These don't link to anything 
# as they don't need to communicate externally to other containers.
docker run -d --name=redis redis:alpine

docker run -d --name=mysql \
    -e MYSQL_ROOT_PASSWORD=root \
    -e MYSQL_DATABASE=my-app \
    -e MYSQL_USER=app-user \
    -e MYSQL_PASSWORD=app-pass \
    mysql:5.7

# The PHP container links to the data containers
docker run -d --name=php \
    --link=redis:redis \
    --link=mysql:mysql \
    -v $(pwd)/application:/var/www/html \
    shippingdocker/php:0.1.0

# The Nginx container links to the PHP container
# (It only communciates to the php container, no db or redis)
docker run -d  --name=nginx \
    --link=php:php \
    -p 80:80 \
    -v $(pwd)/application:/var/www/html \
    shippingdocker/nginx:0.2.0

We can test this out with a quick PHP script that tests that it can see the IP address of the Redis container and it can connect to the MySQL container:

<?php
echo "Hostname 'redis' can be found at: " . gethostbyname('redis')."\n";

$hostname='mysql';
$username='app-user';
$password='app-pass';
$dbname='my-app';

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=$dbname", $username, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
    echo "Connected to the database at hostname 'mysql': " . gethostbyname('mysql') . "\n";
} catch(Exception $e) {
    echo $e->getMessage();
}
```

```
Use Redis
1 - First make sure you run the Redis Container (redis) with the docker-compose up command.
docker-compose up -d redis
To execute redis commands, enter the redis container first docker-compose exec redis bash then enter the redis-cli.
2 - Open your Laravel’s .env file and set the REDIS_HOST to redis
REDIS_HOST=redis
If you’re using Laravel, and you don’t find the REDIS_HOST variable in your .env file. Go to the database configuration file config/database.php and replace the default 127.0.0.1 IP with redis for Redis like this:
'redis' => [
    'cluster' => false,
    'default' => [
        'host'     => 'redis',
        'port'     => 6379,
        'database' => 0,
    ],
],
3 - To enable Redis Caching and/or for Sessions Management. Also from the .env file set CACHE_DRIVER and SESSION_DRIVER to redis instead of the default file.
CACHE_DRIVER=redis
SESSION_DRIVER=redis
4 - Finally make sure you have the predis/predis package (~1.0) installed via Composer:
composer require predis/predis:^1.0
5 - You can manually test it from Laravel with this code:
\Cache::store('redis')->put('Laradock', 'Awesome', 10);
```


```

# https://hub.docker.com/_/php/
FROM php:5.6-cli

# install php redis extension from source, composer
RUN apt-get update -q \
  && apt-get install -y zlib1g-dev \
  && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz \
  && tar xfz /tmp/redis.tar.gz \
  && rm -r /tmp/redis.tar.gz \
  && mv phpredis-2.2.7 /usr/src/php/ext/redis \
  && docker-php-ext-install redis zip \
  && mkdir -p /usr/src/firstapp \
  && cd /usr/src/firstapp \
  && curl -sS https://getcomposer.org/installer|php \
  && apt-get purge -y zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/firstapp

# use composer to install dependencies
ADD composer.json /usr/src/firstapp/composer.json
RUN ./composer.phar install

# copy the rest of the application into the image
COPY . /usr/src/firstapp
EXPOSE 80
ENTRYPOINT ["php", "-S", "0.0.0.0:80", "-t", "web/"]


Built
docker build -t currentweather-php ./

RUN
docker run --name=currentweather-redis-container -d redis

docker run --link currentweather-redis-container:redis -p 80:80 -ti --rm currentweather-php


Testing locally

To test locally before deploying to Giant Swarm, we also need a Redis server. This is very easy to be set up, since we can use a standard image here without any modification. Simply run this to start your local Redis server container:

$ docker run --name=currentweather-redis-container -d redis
Now let’s start the server container for which we just created the Docker image. Here is the command (replace yourusername with your username):

$ docker run --link currentweather-redis-container:redis -p 80:80 -ti --rm registry.giantswarm.io/yourusername/currentweather-php
It should be running. But we need proof! Let’s issue an HTTP request.

Accessing the server in a browser requires knowledge of the IP address your docker host binds to containers. This depends on the operating system.

Mac/Windows: with boot2docker you can find it out using boot2docker ip. The default here is 192.168.59.103.

Linux: the command ip addr show docker0|grep inet should print out a line containing the correct address. The default in this case is 172.17.42.1.

So one of the following two commands will likely work:

$ curl 192.168.59.103
$ curl 172.17.42.1
Your output should look something like this:

broken clouds, temperature 2 degrees, wind 7.2

```
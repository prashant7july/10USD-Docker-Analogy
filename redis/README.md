# Install PHP Redis from source install 
#### Reference Link
 * [redisclustercompose](https://github.com/aprice-/redisclustercompose) 
 * [redis4-cluster-docker-compose](https://get-reddie.com/blog/redis4-cluster-docker-compose/)
 * [docker-redis-cluster](https://github.com/Grokzen/docker-redis-cluster)
 * [LINK](https://www.alibabacloud.com/forum/read-393)
 * [redis-cluster](https://github.com/AliyunContainerService/redis-cluster)
 * [DocHarris](https://github.com/Zookal/DocHarris)
 * [LINK](https://cloudkul.com/blog/integrate-magento-2-varnish-cache-redis-server-ssl-termination-using-docker-compose/)
 * [redis-webui](https://github.com/mikechernev/redis-webui)
 * [LINKBOOK](https://github.com/mikechernev/programming-ebooks/blob/master/Cheat%20Sheets/Rails.pdf)
 * [magento2-varnish-redis-ssl-docker-compose - ubuntu](https://github.com/webkul/magento2-varnish-redis-ssl-docker-compose)
 * [calling-redis-cli-in-docker-compose-setup - IMP](https://stackoverflow.com/questions/33304388/calling-redis-cli-in-docker-compose-setup?rq=1)
 * [docker-redis-cluster/](http://kuga.me/2016/07/22/docker-redis-cluster/)
 * [Redis-Cluster-with-Docker-Compose-v3](https://www.snip2code.com/Snippet/1906152/Redis-Cluster-with-Docker-Compose-v3)
 * [Deploy-Redis-Cluster-By-Docker](https://o-my-chenjian.com/2017/05/24/Deploy-Redis-Cluster-By-Docker/)
 * [docker-redis-cluster](https://github.com/vishnudxb/docker-redis-cluster)

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

# Install composer
```
# Install composer globally
RUN echo "Install composer globally"
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
```
[php-redis-extension-using-the-official-php-docker](https://stackoverflow.com/questions/31369867/how-to-install-php-redis-extension-using-the-official-php-docker-image-approach)

**The first way is to compile redis from sources and install.**
```
RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-2.2.7 /usr/src/php/ext/redis \
    && docker-php-ext-install redis
```
docker-php-ext-install script is included in php-fpm image and can compile extensions and install them.

OR

```
# Install phpredis 2.2.7
RUN apt-get install -y unzip
WORKDIR /root
COPY ./lib/phpredis-2.2.7.zip phpredis-2.2.7.zip
RUN unzip phpredis-2.2.7.zip
WORKDIR phpredis-2.2.7
RUN phpize
RUN ./configure
RUN make && make install
RUN echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
```
OR
```
ENV PHPREDIS_VERSION 3.1.4

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz  \
    && mkdir /tmp/redis \
    && tar -xf /tmp/redis.tar.gz -C /tmp/redis \
    && rm /tmp/redis.tar.gz \
    && ( \
    cd /tmp/redis/phpredis-$PHPREDIS_VERSION \
    && phpize \
        && ./configure \
    && make -j$(nproc) \
        && make install \
    ) \
    && rm -r /tmp/redis \
    && docker-php-ext-enable redis
```

**The second way you can do it is with PECL.**
```
RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini
```

**The first way is to compile redis from sources and install.**
```
## Install Xdebug
RUN curl -fsSL 'https://xdebug.org/files/xdebug-2.5.3.tgz' -o xdebug.tar.gz \
    && mkdir -p xdebug \
    && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
    && rm xdebug.tar.gz \
    && ( \
        cd xdebug \
        && phpize \
        && ./configure --enable-xdebug \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r xdebug \
    && docker-php-ext-enable xdebug
```
**The second way you can do it is with PECL.**
```
# Install xdebug
RUN pecl install xdebug
RUN echo "zend_extenstion=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini
```

**In Dockefile start shell script**
```
# Include the start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
WORKDIR /root

CMD ["start.sh"]
```
```
RUN chmod 755 /start.sh

# Run the script departure
CMD ["/bin/bash", "/start.sh"]
```

**Dockerfile PHP7-FPM with extensions (Redis, pdo_mysql, pdo_pgsql, intl, curl, json, opcache and xml)**
```
#In Dockfile
FROM php:7-fpm

RUN apt-get update && apt-get install -y git libcurl4-gnutls-dev zlib1g-dev libicu-dev g++ libxml2-dev libpq-dev \
 && git clone -b php7 https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis \
 && docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql intl curl json opcache xml redis \
 && apt-get autoremove && apt-get autoclean \
 && rm -rf /var/lib/apt/lists/*
 ```

[Your First Service — in PHP](https://hub.docker.com/r/mehrdadkhah/php7/~/dockerfile/)
[Your First Service — in PHP](https://firstgen-docs.giantswarm.io/guides/your-first-service/php/)

#### 1. Create Composer Command
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
```

#### 2. Built

```
docker build -t currentweather-php ./
```

#### 3. RUN
```
docker run --name=currentweather-redis-container -d redis

docker run --link currentweather-redis-container:redis -p 80:80 -ti --rm currentweather-php
```

Testing locally

To test locally before deploying to Giant Swarm, we also need a Redis server. This is very easy to be set up, since we can use a standard image here without any modification. Simply run this to start your local Redis server container:
```
$ docker run --name=currentweather-redis-container -d redis
```
Now let’s start the server container for which we just created the Docker image. Here is the command (replace yourusername with your username):
```
$ docker run --link currentweather-redis-container:redis -p 80:80 -ti --rm registry.giantswarm.io/yourusername/currentweather-php
```
It should be running. But we need proof! Let’s issue an HTTP request.

Accessing the server in a browser requires knowledge of the IP address your docker host binds to containers. This depends on the operating system.

Mac/Windows: with boot2docker you can find it out using boot2docker ip. The default here is 192.168.59.103.

Linux: the command ip addr show docker0|grep inet should print out a line containing the correct address. The default in this case is 172.17.42.1.

So one of the following two commands will likely work:
```
$ curl 192.168.59.103
$ curl 172.17.42.1
```
Your output should look something like this:

broken clouds, temperature 2 degrees, wind 7.2

# PHP with redis
* [redis-introduction-with-php](https://cloudkul.com/blog/redis-introduction-with-php/)
* [php-redis](https://redislabs.com/lp/php-redis/)

#### 1. RUN Composer Command
Before using Redis with PHP, you will need to install the predis/predis package via Composer:

```
composer require predis/predis
```

#### OR 
Create Composer.json

```
{
 "require" : {
   "predis/predis" : "1.1.*"
 }
}
```
Alternatively, you may install the PhpRedis PHP extension via PECL.

#### 2. Create predis_example.php file

```
<?php
//Connect your php application to Redis
//check zf2 redis in vender
require “predis/autoload.php”;
Predis\Autoloader::register();
try {
  $redis = new PredisClient(); //If redis server and client is on same server
  $redis = new PredisClient(array("scheme" => "tcp","host" => "192.168.1.10","port" => 6379 )); 
  //if redis server is installed on some remote server, 192.168.1.10 is remote server IP.
} catch (Exception $e) {
  die($e->getMessage());
}
Now you can perform various getter and setter operations on Redis.
Getter -> to get the key pair value.
Setter -> to set the key pair value.
Lets take an example to understand the basic functionality.
 
$redis->set (“counter”, 2);
$redis->incr(“counter”);
$cvalue->$redis->get(“counter); //cvalue stores the value 3

$redis->set("foo", "bar");
$value = $redis->get("foo");
var_dump($value);
```

#### RUN predis_example.php file

```
$ php predis_example.php
Connected to Redis
string(3) "bar"
```

With the help of Redis we can perform various operations on sets, strings, hashes and lists as well as control the flow of application’s content to make it fast with the help of caching.

# Install the phpredis extension from the Ubuntu respositories
Previously, I had shown you how to install PHP Redis from source but things changed with the latest Ubuntu LTS release. Now you can install the phpredis extension from the Ubuntu respositories.
	
If you want to install the latest version this is the route to take but if your are not so concerned about getting the latest then sudo apt-get install redis-server is the path to tow. Again this is an opportunity to learn how redis actually works and how it is setup. I personally prefer to do it this way so I know in and outs of the system and can alter it to suit my needs and expectations
* [how-to-install-redis-on-ubuntu-16-04](https://askubuntu.com/questions/868848/how-to-install-redis-on-ubuntu-16-04)
* [how-to-install-phpredis-on-ubuntu-1404-lts](https://joshtronic.com/2014/05/12/how-to-install-phpredis-on-ubuntu-1404-lts/)
* [how_to_install_configure_and_use_redis_on_ubuntu_1](https://community.webcore.cloud/tutorials/how_to_install_configure_and_use_redis_on_ubuntu_1/)
* [Integrate Redis-Server using Docker-Compose]https://cloudkul.com/blog/integrate-magento-2-varnish-cache-redis-server-ssl-termination-using-docker-compose/
* [Install Redis with Docker in Ubuntu 14.04 - IMP](https://gist.github.com/kevingo/6017d641e5492e98bee570b77e2ba258)
* [how-to-configure-a-redis-cluster-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-configure-a-redis-cluster-on-ubuntu-14-04)
* [how-to-set-up-a-redis-server-as-a-session-handler-for-php-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-redis-server-as-a-session-handler-for-php-on-ubuntu-14-04)
* [how-to-install-redis-and-redis-php-client](https://anton.logvinenko.name/en/blog/how-to-install-redis-and-redis-php-client.html)
* [install-redis-on-ubuntu-with-php](http://bookofzeus.com/articles/optimization/install-redis-on-ubuntu-with-php/)
* [master-slave-redis-cluster-on-ubuntu-14-04](https://www.devopsdays.in/master-slave-redis-cluster-on-ubuntu-14-04/)

#### 1. Create Docekrfile

```
mkdir redis && touch Dockerfile
```

#### 2. Create Redis Dockerfile

```
FROM        ubuntu:14.04
RUN         apt-get update && apt-get install -y redis-server
EXPOSE      6379
ENTRYPOINT  ["/usr/bin/redis-server"]
```

#### 3. Build redis images

```
docker build -t <your username>/redis .
```

#### 4. Run redis with expose 6379 port 

```
docker run -d --name redis -p 6379:6379 dockerfile/redis
```

[Run Redis Server with Difference RUN vs CMD](https://stackoverflow.com/questions/31660691/how-to-run-a-redis-server-and-another-application-inside-docker)

**RUN** commands are adding new image layers only. They are not executed during runtime. Only during build time of the image.
Use **CMD** instead. You can combine multiple commands by externalizing them into a shell script which is invoked by CMD:

#### 1. Create Docekrfile

```
mkdir redis && touch Dockerfile
```

#### 2. Create Redis Dockerfile

```
FROM        ubuntu:14.04
RUN         apt-get update && apt-get install -y redis-server
EXPOSE      6379
CMD start.sh
```

#### 3. Create start.sh File
In the start.sh script you write the following:

```
#!/bin/bash
nohup redis-server &
```

#### 4. Build redis images

```
docker build -t <your username>/redis .
```

#### 5. Run redis with expose 6379 port 

```
docker run -d --name redis -p 6379:6379 dockerfile/redis
```


# Install Jenkins
#### Create shell.sh file

```
docker pull jenkins
docker run --name jenkins -d -p 49001:8080 -v $PWD/jenkins:/var/jenkins_home -t jenkins
```

# Install RabbitMQ
[RabbitMQ Dockerfile for trusted automated Docker builds](https://github.com/dockerfile/rabbitmq)

# Install Different Dockerfile example like MongoDB
https://github.com/dockerfile

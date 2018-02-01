# [What is Redis Master Slave?](http://blog.awareshop.com/2015/01/11/redis-master-slave-setup-on-single-machine/)

Redis Master Slave setup is same as any other Master Slave setup. It allows you to maintain multiple copies of same data automatically. That will serve the purpose of backup and scaling. You can use Redis Slave to serve the request the reading requests and hence your master load decreases.

We will start with installation of Redis Server, then Redis Slave and then will setup Redis Mater Slave replication.

#### Also, check out these other How-to articles
 * How to setup Redis Session Manager on tcServer/Tomcat
 * How to setup and run multiple Redis server instances on a Linux host
 * How to setup Redis Master and Slave replication
 * How to setup Redis Sentinel and HAProxy to provide automatic failover between Redis Master and Slave servers.

#### How to setup Redis master and slave replication
 * It's very simple to setup a master-slave Redis replication that allows the slave Redis server to keep an exact backup copy of a master server database.

#### [Redis setup involving some or all instances of:](https://github.com/aphorise/docker-redis)
###### - standalone (master) 
###### - replication / mirroring (slave) 
###### - health checker and switch (sentinel) *

Redis Dockerfiles for standalone (master), replication (slave) and sentinel setup. 
``` 
        Redis-Sentinel-1
             _/ \_
           _|     |_
          /         \ 
Redis-Master <--> Redis-Slave
          \_       _/
    	    |_   _|
              \ /
        Redis-Sentinel-2
```
* [docker-redis-master-slave](http://blog.yuanxiaolong.cn/blog/2014/10/29/docker-redis-master-slave/)
* [OR](http://www.xyting.org/2015/10/06/docker-redis-master-slave.html)

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
 * [how-to-install-and-configure-a-redis-cluster-on-ubuntu-1604](https://github.com/linode/docs/blob/master/docs/applications/big-data/how-to-install-and-configure-a-redis-cluster-on-ubuntu-1604.md)
 * [Configure Redis Cluster in Ubuntu Server 14.04
](http://codeflex.co/configuring-redis-cluster-on-linux/)
 * [redis-cluster-using-docker IMP](https://medium.com/monitisemea/creating-redis-cluster-using-docker-67f65545796d)
 * [running_redis_service](http://www.usyiyi.cn/sources/docker/engine/examples/running_redis_service.html)
 * [redis](https://hub.docker.com/r/bitnami/redis/)

# Additionally, If you want to use your own redis.conf …
You can create your own Dockerfile that adds a redis.conf from the context into /data/, like so.
```
FROM redis
COPY redis.conf /usr/local/etc/redis/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
```
Alternatively, you can specify something along the same lines with docker run options.
```
$ docker run -v /myredis/conf/redis.conf:/usr/local/etc/redis/redis.conf --name myredis redis redis-server /usr/local/etc/redis/redis.conf
```

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

[php-redis-extension-using-the-official-php-docker](https://stackoverflow.com/questions/31369867/how-to-install-php-redis-extension-using-the-official-php-docker-image-approach)



**[The first way is to compile redis from sources and install.](https://gist.github.com/diegopacheco/af89b493bc892d470ba8ff79a813c0d2)**
```
Download and Install Redis 4.0

wget http://download.redis.io/releases/redis-4.0.6.tar.gz
tar -xzvf redis-4.0.6.tar.gz
rm -rf redis-4.0.6.tar.gz
cd redis-4.0.6/
make
make test
```

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

**OR**

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
$ composer require predis/predis
```

#### OR 
Create Composer.json

```
{
    "require": {
        "predis/predis": "^1.1"
    }
}
$ compose install
```
Alternatively, you may install the PhpRedis PHP extension via PECL.

#### 2. Create predis_example.php file

```
<?php
//namespace Examples;

require (dirname(__DIR__).'/vendor/autoload.php');
// or require (dirname(__DIR__).'/src/autoloader.php');
Predis\Autoloader::register();

if (!class_exists('Predis\Client')) {
   die('Missing redis library. Please run "composer.phar require predis/predis"');
}  

try {
  //If redis server and client is on same server
  //$redis = new \Predis\Client();
  $redis = new \Predis\Client(array("scheme" => "tcp","host" => "127.0.0.1","port" => 6379)); 
  
  //if redis server is installed on some remote server, 192.168.1.10 is remote server IP.
  //$redis = new PredisClient(array("scheme" => "tcp","host" => "192.168.1.10","port" => 6379 )); 
} catch (Exception $e) {
  die($e->getMessage());
}

$redis->set("counter", 2);
$redis->incr("counter");
echo $redis->get("counter"); //3

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
Previously, I had shown you how to **install PHP Redis from source** but things changed with the latest Ubuntu LTS release. Now you can **install the phpredis extension from the Ubuntu respositories**.
	
If you want to install the latest version this is the route to take but if your are not so concerned about getting the latest then sudo apt-get install redis-server is the path to tow. Again this is an opportunity to learn how redis actually works and how it is setup. I personally prefer to do it this way so I know in and outs of the system and can alter it to suit my needs and expectations
* [how-to-install-redis-on-ubuntu-16-04](https://askubuntu.com/questions/868848/how-to-install-redis-on-ubuntu-16-04)
* [how-to-install-phpredis-on-ubuntu-1404-lts](https://joshtronic.com/2014/05/12/how-to-install-phpredis-on-ubuntu-1404-lts/)
* [how_to_install_configure_and_use_redis_on_ubuntu_1](https://community.webcore.cloud/tutorials/how_to_install_configure_and_use_redis_on_ubuntu_1/)
* [Integrate Redis-Server using Docker-Compose](https://cloudkul.com/blog/integrate-magento-2-varnish-cache-redis-server-ssl-termination-using-docker-compose/)
* [Install Redis with Docker in Ubuntu 14.04 - IMP](https://gist.github.com/kevingo/6017d641e5492e98bee570b77e2ba258)
* [how-to-configure-a-redis-cluster-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-configure-a-redis-cluster-on-ubuntu-14-04)
* [how-to-set-up-a-redis-server-as-a-session-handler-for-php-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-redis-server-as-a-session-handler-for-php-on-ubuntu-14-04)
* [how-to-install-redis-and-redis-php-client](https://anton.logvinenko.name/en/blog/how-to-install-redis-and-redis-php-client.html)
* [install-redis-on-ubuntu-with-php](http://bookofzeus.com/articles/optimization/install-redis-on-ubuntu-with-php/)
* [master-slave-redis-cluster-on-ubuntu-14-04](https://www.devopsdays.in/master-slave-redis-cluster-on-ubuntu-14-04/)
* [Create and Share Redis Docker Image](https://deis.com/blog/2015/creating-sharing-first-docker-image/)

## Case 1::Install redis-server on ubuntu though Dockefile
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
Example: docker build -t redis-server .
```

#### 4. Run redis with expose 6379 port 

```
docker run -d --name redis -p 6379:6379 dockerfile/redis
Example: docker run --name redisinstance -t redis-server
```

#### 5. [Run redis-cli in redis-server shell](https://stackoverflow.com/questions/42083843/how-to-enter-a-redis-server-shell-inside-a-running-docker-compose-container)
You need to log on to the container using docker exec (as mentioned in another answer - not sure if the command is 100% correct as it may just run redis-cli then exit).

```
docker exec -it redisinstance sh
```
That will log you on to the container. You can then run redis-cli from the command prompt.

#### 6. [Assign static IP to Docker container](https://stackoverflow.com/questions/42083843/how-to-enter-a-redis-server-shell-inside-a-running-docker-compose-container)

When running redis we need to assign IP to the container, and assign IP need to create a network, the parameters to be modified according to your situation.
First you need to create you own docker network (dockerservernetworkip)

```
docker network create --subnet=172.18.0.0/16 dockerservernetworkip
```

#### 6. Run the Docker container.

```
docker run --net dockerservernetworkip --ip 172.18.0.22 -it -p 6379:6379 redis-server
```
docker: Error response from daemon: driver failed programming external connectivity on endpoint pedantic_euler (6f5ccee0ba423dc7b037cb8883eae94166d5c57caf13543fb044b114af36fb7d): Error starting userland proxy: listen tcp 0.0.0.0:6379: bind: address already in use.

Again Run with different Local system post
```
docker run --net dockerservernetworkip --ip 172.18.0.22 -it -p 6380:6379 redis-server
docker run --net dockerservernetworkip --ip 172.18.0.22 -it -p 6380:6379 redis-server /bin/sh
docker run --net mynet123 --ip 172.18.0.22 -it ubuntu bash
```

#### 6. ip addr
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 1c:1b:0d:17:47:f9 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.85/24 brd 192.168.1.255 scope global enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::1e1b:dff:fe17:47f9/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:fb:a5:ea:1c brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:fbff:fea5:ea1c/64 scope link 
       valid_lft forever preferred_lft forever
27: br-fa777c0c0570: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:bf:ce:6c:f5 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/16 scope global br-fa777c0c0570
       valid_lft forever preferred_lft forever
    inet6 fe80::42:bfff:fece:6cf5/64 scope link 
       valid_lft forever preferred_lft forever
33: vethf582c27@if32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-fa777c0c0570 state UP group default 
    link/ether 36:6b:62:f5:af:75 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::346b:62ff:fef5:af75/64 scope link 
       valid_lft forever preferred_lft forever
```

**3: docker0**: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:fb:a5:ea:1c brd ff:ff:ff:ff:ff:ff
    inet **172.17.0.1/16** scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:fbff:fea5:ea1c/64 scope link 
       valid_lft forever preferred_lft forever

```
curl 172.17.0.1
```

[Run Redis Server with Difference RUN vs CMD](https://stackoverflow.com/questions/31660691/how-to-run-a-redis-server-and-another-application-inside-docker)

**RUN** commands are adding new image layers only. They are not executed during runtime. Only during build time of the image.
Use **CMD** instead. You can combine multiple commands by externalizing them into a shell script which is invoked by CMD:

**RUN** gets executed when an image gets **built**.
**CMD** gets executed when a container gets **run**.

## Case 2::Install redis-server on ubuntu though Dockefile
#### 1. Create Docekrfile
```
mkdir redis && touch Dockerfile
```

#### 2. Create Redis Dockerfile

```
FROM        ubuntu:14.04
RUN         apt-get update && apt-get install -y redis-server
EXPOSE      6379

# Include the start script
# We copy the start.sh script into /usr/local/bin, make it executable and reference it in the CMD instruction.
COPY start.sh /usr/local/bin/start.sh

# If we dont make it exectable you will get an error like "exec:/user/local/bin/start.sh: Premission denied"
RUN chmod +x /usr/local/bin/start.sh
WORKDIR /root

CMD ["start.sh"]
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
Example: docker build -t redis-server .
```

#### 5. Run redis with expose 6379 port 

```
docker run -d --name redis -p 6379:6379 dockerfile/redis
Example: docker run --name redisinstance -t redis-server    
```

# Redis Cluster 
## CASE 1 
#### 1: Check Redis Server Available 
```
$ ps aux | grep redis
OR
$ ps aux | grep redis-server
redis      924  0.1  0.1  40140  8712 ?        Ssl  12:10   0:03 /usr/bin/redis-server 127.0.0.1:6379
```
It's listening on all available IPs - if bound to a specific IP, you'd see something like 127.0.0.1:6379

#### 2. To connect to your cluster you can use the redis-cli tool:

```
$ redis-cli -h 127.0.0.1
127.0.0.1:6379>
```

```
redis-cli -c -h 127.0.0.1 -p 6379
```

```
redis-cli -c -p 6379 cluster info
```

#### 3. RUN Composer Command
Before using Redis with PHP, you will need to install the predis/predis package via Composer:

```
$ composer require predis/predis
```

#### OR 

#### Create Composer.json

```
{
    "require": {
        "predis/predis": "^1.1"
    }
}
$ compose install
```
Alternatively, you may install the PhpRedis PHP extension via PECL.

#### 4. Create predis_example.php file

```
<?php
include 'vendor/autoload.php';
Predis\Autoloader::register();

if (!class_exists('Predis\Client')) {
   die('Missing redis library. Please run "composer.phar require predis/predis"');
}  

try {
  //If redis server and client is on same server
  //$redis = new \Predis\Client();
  //Local systm already setup redis $ redis-cli -h 127.0.0.1
  $redis = new \Predis\Client(array("scheme" => "tcp","host" => "127.0.0.1","port" => 6379)); 
  
  //if redis server is installed on some remote server, 192.168.1.10 is remote server IP.
  //$redis = new PredisClient(array("scheme" => "tcp","host" => "192.168.1.10","port" => 6379 )); 
} catch (Exception $e) {
  die($e->getMessage());
}

$redis->set("counter", 2);
$redis->incr("counter");
echo $redis->get("counter"); //3

$redis->set("foo", "bar");
$value = $redis->get("foo");
var_dump($value);
```

#### 5. RUN predis_example.php file

```
$ php predis_example.php
3
/var/www/html/php/test-script/redis/predis_example.php:27:
string(3) "bar"
```

## CASE 2
## A Redis cluster in production but Googling shows this image [docker-redis-cluster](https://github.com/Grokzen/docker-redis-cluster).
#### 1. Run the Docker Image with expose 7005

```
$ docker run -d \
  --name redisserver \
  -p 7005:7005 \
  grokzen/redis-cluster
```
**OUTPUT**
```
latest: Pulling from grokzen/redis-cluster

5040bd298390: Pull complete 
996f41e871db: Pull complete 
a40484248761: Pull complete 
a97af2bf2ee7: Pull complete 
dfec56c50bc8: Pull complete 
a86edaad468b: Pull complete 
394561348fd7: Pull complete 
d3822da5b92f: Pull complete 
3e497138f055: Pull complete 
2c78dfd1ceed: Pull complete 
c31f8c56919b: Pull complete 
9d1ba3022d62: Pull complete 
013ee148e80f: Pull complete 
78b8edc7ab97: Pull complete 
8d20209533d3: Pull complete 
b2c3af25c797: Pull complete 
573b5b13ecc8: Pull complete 
df82e44dc4e4: Pull complete 
a9b6088df972: Pull complete 
Digest: sha256:1d0437daed657c0932210202a6ab6cffc85f02b9e947917783a4265ce12d5283
Status: Downloaded newer image for grokzen/redis-cluster:latest
a385fc52e102d875e7b4c1f69b441077878fbbd60afe9b30be47a8dc7a4bd108
```

#### 2. To connect to your cluster you can use the redis-cli tool:
```
$ redis-cli -c -p 7005
$ redis-cli -h 127.0.0.1
$ redis-cli -c -h 127.0.0.1 -p 7005
```
**OUTPUT**
```
127.0.0.1:7005>
```

#### 3. RUN Composer Command
Before using Redis with PHP, you will need to install the predis/predis package via Composer:

```
$ composer require predis/predis
```

#### OR 

#### Create Composer.json

```
{
    "require": {
        "predis/predis": "^1.1"
    }
}
$ compose install
```
Alternatively, you may install the PhpRedis PHP extension via PECL.

#### 4. Create predis_example.php file

```
<?php
include 'vendor/autoload.php';
Predis\Autoloader::register();

if (!class_exists('Predis\Client')) {
   die('Missing redis library. Please run "composer.phar require predis/predis"');
}  

try {
  //If redis server and client is on same server
  //$redis = new \Predis\Client();
  //Local systm already setup redis $ redis-cli -h 127.0.0.1
  $redis = new \Predis\Client(array("scheme" => "tcp","host" => "127.0.0.1","port" => 7005)); 
  
  //if redis server is installed on some remote server, 192.168.1.10 is remote server IP.
  //$redis = new PredisClient(array("scheme" => "tcp","host" => "192.168.1.10","port" => 6379 )); 
} catch (Exception $e) {
  die($e->getMessage());
}

$redis->set("counter", 2);
$redis->incr("counter");
echo $redis->get("counter"); //3

$redis->set("foo", "bar");
$value = $redis->get("foo");
var_dump($value);
```

#### 5. RUN predis_example.php file
```
//$redis = new \Predis\Client(array("scheme" => "tcp","host" => "127.0.0.1","port" => 7005)); 
PHP Fatal error:  Uncaught Predis\Response\ServerException: MOVED 6680 172.17.0.2:7001 in /var/www/html/php/test-script/redis/vendor/predis/predis/src/Client.php:370
Stack trace:
#0 /var/www/html/php/test-script/redis/vendor/predis/predis/src/Client.php(335): Predis\Client->onErrorResponse(Object(Predis\Command\StringSet), Object(Predis\Response\Error))
#1 /var/www/html/php/test-script/redis/vendor/predis/predis/src/Client.php(314): Predis\Client->executeCommand(Object(Predis\Command\StringSet))
#2 /var/www/html/php/test-script/redis/predis_example.php(21): Predis\Client->__call('set', Array)
#3 {main}
  thrown in /var/www/html/php/test-script/redis/vendor/predis/predis/src/Client.php on line 370

```

#### 6. Use the redis-server:
```
$ ps aux | grep redis OR ps aux | grep redis-server
redis      924  0.1  0.1  40140  8712 ?        Ssl  12:10   0:03 /usr/bin/redis-server 127.0.0.1:6379
```
It's listening on all available IPs - if bound to a specific IP, you'd see something like 127.0.0.1:6379

#### 6. To connect to your cluster you can use the redis-cli tool:
docker run **-d** --name redisserver -p 7005:7005 grokzen/redis-cluster [run background due to -d then the below command executable]

```
$ redis-cli -h 127.0.0.1
127.0.0.1:6379>
```

#### 7. Port information
```
netstat -ntlp|grep -E '7001|7002|7003|7004|7005|7006'
```

#### Answer of case 2
**When running redis we need to assign IP to the container, and assign IP need to create a network, the parameters to be modified according to your situation.**

```
docker network create --subnet 10.10.10.0/24 onepiece
```

# Here are some network related commands.
#### List all network
```
docker network ls
docker network ls -q
```

#### Check out a network
```
docker network inspect onepiece
```

#### Delete a network
```
docker network rm onepiece
docker network rm $(docker network ls -q)
```

## Case 3
#### When running we need to assign IP to the container, and assign IP need to create a network, the parameters to be modified according to your situation.

```
docker network create --subnet 10.10.10.0/24 onepiece
```

#### Run the Docker container.
```
docker run --net onepiece --ip 10.10.10.100 -it -p 7000-7002:7000-7002 grokzen/redis-cluster
```
The above meaning is to use onepiece this network, and assign 10.10.10.100 this IP to the container. -p is the port mapping, the left side of the colon is the host port, the right is the port of the container, the redis in our container is to use the 7000-7002 these three ports.

#### Continue to run the second container, command some changes on the IP and port, as follows.
```
docker run --net onepiece --ip 10.10.10.101 -it -p 7003-7005:7000-7002 grokzen/redis-cluster
```

#### The third container is similar.
```
docker run --net onepiece --ip 10.10.10.102 -it -p 7006-7008:7000-7002 grokzen/redis-cluster
```
**We can see if there are 3 redis instances running inside one of the containers.**

#### 4. Create/RUN predis_example.php file, the output rase isssues

```
<?php
include 'vendor/autoload.php';
Predis\Autoloader::register();

if (!class_exists('Predis\Client')) {
   die('Missing redis library. Please run "composer.phar require predis/predis"');
}  

try {
  //If redis server and client is on same server
  //$redis = new \Predis\Client();
  //Local systm already setup redis $ redis-cli -h 127.0.0.1
  $redis = new \Predis\Client(array("scheme" => "tcp","host" => "10.10.10.100","port" => 7005)); 
  
  //if redis server is installed on some remote server, 192.168.1.10 is remote server IP.
  //$redis = new PredisClient(array("scheme" => "tcp","host" => "192.168.1.10","port" => 6379 )); 
} catch (Exception $e) {
  die($e->getMessage());
}

$redis->set("counter", 2);
$redis->incr("counter");
echo $redis->get("counter"); //3

$redis->set("foo", "bar");
$value = $redis->get("foo");
var_dump($value);
```

**OUTPT**
```
( ! ) Fatal error: Uncaught Predis\Response\ServerException: CLUSTERDOWN Hash slot not served in /var/www/html/php/test-script/redis/vendor/predis/predis/src/Client.php on line 370
( ! ) Predis\Response\ServerException: CLUSTERDOWN Hash slot not served in /var/www/html/php/test-script/redis/vendor/predis/predis/src/Client.php on line 370
```

#### Find redis-server.
```
ps aux | grep redis
```

#### Run redis-cli tool to test.
```
redis-cli -c -p 7000 cluster info
```

**OUTPUT**
```
cluster_state:**fail**
cluster_slots_assigned:5461
cluster_slots_ok:5461
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:1
cluster_size:1
cluster_current_epoch:1
cluster_my_epoch:1
cluster_stats_messages_sent:0
cluster_stats_messages_received:0
```

**OR**
```
$ redis-cli -c -h 10.10.10.100 -p 7000
```

**OUTPUT**
```
10.10.10.100:7000> CLUSTER INFO
cluster_state:**fail**
cluster_slots_assigned:5461
cluster_slots_ok:5461
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:1
cluster_size:1
cluster_current_epoch:1
cluster_my_epoch:1
cluster_stats_messages_sent:0
cluster_stats_messages_received:0
```

## How to resolve
[Redis Cluster - How to create a cluster without redis-trib.rb file ](http://pingredis.blogspot.in/2016/09/redis-cluster-how-to-create-cluster.html)

#### 1. Making the nodes meet each other.
This is done using the cluster meet command as mentioned here.
```
redis-cli -c -p 7000 cluster meet 127.0.0.1 7001
redis-cli -c -p 7000 cluster meet 127.0.0.1 7002
redis-cli -c -p 7000 cluster meet 127.0.0.1 7003
redis-cli -c -p 7000 cluster meet 127.0.0.1 7004
redis-cli -c -p 7000 cluster meet 127.0.0.1 7005
```

#### 2. Run redis-cli tool to test.
```
$ redis-cli -p 7000 cluster info
```

**OUTPUT**
```
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_sent:950
cluster_stats_messages_received:700
```

#### OR
```
$ redis-cli -c -h 10.10.10.100 -p 7000
```

**OUTPUT**
```
10.10.10.100:7000> CLUSTER INFO
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_sent:2602
cluster_stats_messages_received:2352
10.10.10.100:7000> 
```

# Need to create for cluster
such as 
```
./src/redis-trib.rb create --replicas 1 127.0.0.1:6336 127.0.0.1:6337 127.0.0.1:6338 127.0.0.1:6339 127.0.0.1:6340 127.0.0.1:6341
```

## Case 4
Pending

# BASH script for dumping all key, values using redis-cli
```
#!/bin/bash

# get all keys
# find the type for each key
# get value(s) for key
# list, string, hash, set

for each in $( redis-cli KEYS \* ); do
  result=$(redis-cli type $each)
  value=""
  if [ $result == "list" ]
  then
    value=$(redis-cli lrange $each 0 -1)
  elif [ $result == "string" ]
  then
    value=$(redis-cli get $each)
  elif [ $result == "hash" ]
  then
    value=$(redis-cli hgetall $each)
  elif [ $result == "set" ]
  then
    value=$(redis-cli smembers $each)
  fi
  printf "key %s\t\t type %s\t\t value %s.\n" $each $result $value
done
```

# Use while to loop through each line:
```
redis-cli-keys \* | while read key; do redis-cli get "$key"; done
```

#### Bash Script
* [Analyse-Redis-Cluster-nodes](https://github.com/myntra/Analyse-Redis-Cluster-nodes)
* [redis-is-easy-trivial-hard](http://blog.commando.io/redis-is-easy-trivial-hard/)
* [redis-cluster-install](https://github.com/Azure/azure-quickstart-templates/blob/master/redis-high-availability/redis-cluster-install.sh)
* [redis-cluster-setup](https://github.com/Azure/azure-quickstart-templates/blob/master/redis-high-availability/redis-cluster-setup.sh)
* [Redis Create Cluster](https://gist.github.com/diegopacheco/a8f98b53a42e0faecbc3)

#### Q: How can I stop redis-server? [stop-redis-server](https://stackoverflow.com/questions/6910378/how-can-i-stop-redis-server)
Either connect to node instance and use shutdown command or if you are on ubuntu you can try to restart redis server through init.d:
```
/etc/init.d/redis-server restart
```
or stop/start it:
```
/etc/init.d/redis-server stop
/etc/init.d/redis-server start
```
On Mac
```
redis-cli shutdown
```

# Redis in Containers as another Service
```
docker run --rm -it -p 0.0.0.0:6379:6379 --name redis redis:alpine

docker run --rm -it --link redis:redis redis:alpine redis-cli -h redis -p 6379 help keys
docker run --rm -it --entrypoint=/bin/sh --link redis:redis redis:alpine
```

https://www.linuxsecrets.com/1665-simple-guide-installing-and-configuring-redis-server-on-redhat-or-debian-distributions

# Use redis cluster in php [https://www.zybuluo.com/phper/note/248555]
The first two articles explain in detail the redis cluster build, it's the basic command of the practical method. This article said how to use redis cluster in php.

Currently we use the php redis extension there are two main, the first one is the most commonly used phpredis, it is efficient c extension php written: https://github.com/phpredis/phpredis , there is a predis, It is written in php code, but also quite a lot: https://github.com/nrk/predis .

We look at them separately in the cluster usage.
 * [https://www.zybuluo.com/phper/note/248555](https://www.zybuluo.com/phper/note/248555)
 * [redisclusterexception-with-phpredis-when-connecting-to-redis-cluster](https://stackoverflow.com/questions/35599977/redisclusterexception-with-phpredis-when-connecting-to-redis-cluster-which-is-no)
 * [phpredis](https://www.thegeekstuff.com/2014/02/phpredis/)
 * [examples/clusters](https://github.com/cheprasov/php-redis-client/blob/master/examples/clusters.php)
 * [redis-cluster-playground](https://github.com/mattsta/redis-cluster-playground)
 
## Running tests
Run Docker container with Redis for tests https://hub.docker.com/r/cheprasov/redis-for-tests/
Run Docker container with Redis Cluster for tests https://hub.docker.com/r/cheprasov/redis-cluster-for-tests/
To run tests type in console:

# Install Jenkins
#### Create shell.sh file

```
docker pull jenkins
docker run --name jenkins -d -p 49001:8080 -v $PWD/jenkins:/var/jenkins_home -t jenkins
```

# Install RabbitMQ
* [RabbitMQ Dockerfile for trusted automated Docker builds](https://github.com/dockerfile/rabbitmq)
* [setup-a-rabbitmq-cluster-on-ubuntu](https://thoughtsimproved.wordpress.com/2015/01/03/tech-recipe-setup-a-rabbitmq-cluster-on-ubuntu/)
* [php-redis-client](https://github.com/cheprasov/php-redis-client)

# Install Different Dockerfile example like MongoDB
https://github.com/dockerfile


# Install composer
```
# Install composer globally
RUN echo "Install composer globally"
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
```

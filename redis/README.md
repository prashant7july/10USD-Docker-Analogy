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
[LINK](https://github.com/Zookal/DocHarris)
[LINK](https://cloudkul.com/blog/integrate-magento-2-varnish-cache-redis-server-ssl-termination-using-docker-compose/)
[LINK](https://github.com/mikechernev/redis-webui)
[LINKBOOK](https://github.com/mikechernev/programming-ebooks/blob/master/Cheat%20Sheets/Rails.pdf)
[LINK](https://github.com/webkul/magento2-varnish-redis-ssl-docker-compose)
[LINK - IMP](https://stackoverflow.com/questions/33304388/calling-redis-cli-in-docker-compose-setup?rq=1)
[LINK](http://kuga.me/2016/07/22/docker-redis-cluster/)
[LINK](https://www.snip2code.com/Snippet/1906152/Redis-Cluster-with-Docker-Compose-v3)
[LINK](https://o-my-chenjian.com/2017/05/24/Deploy-Redis-Cluster-By-Docker/)
[LINK](https://github.com/vishnudxb/docker-redis-cluster)



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
Docker image pull/download from docker hub or docker registry for composer
# https://hub.docker.com/_/composer/

This tells Composer about our dependencies — in this case, just one package — when we run the install command.
Installing the Dependencies

Next, we will install the dependencies using the official Composer Docker image:
```
$ docker run --rm -v $(pwd):/app composer/composer:latest install
```

OR

Install is the composer command that is going to be run. You can also do update or dump-autoload in this same manner.
```
$ docker run --rm -v $(pwd):/app composer:latest require zendframework/zend-crypt "2.0.*"
```

Running the PHP Script for https://hub.docker.com/_/php/
```
$ docker run --rm -v $(pwd):/app -w /app php:cli php index.php
```
### REFERENCE SITES
* [docker-any-php-version](https://serversforhackers.com/c/docker-any-php-version)
* [composer-php-docker](https://www.shiphp.com/blog/2017/composer-php-docker)
* [php-composer](https://github.com/shipping-docker/php-composer)

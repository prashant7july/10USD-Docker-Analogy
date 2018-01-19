# Run the Composer Command
## Reference Link - https://serversforhackers.com/dockerized-app/docker-compose
## 1st Case :: Then we can spin up our containers to run this in development
```
$ docker-compose up -d
```

## Check out our containers
```
$ docker-compose ps
```

And view your website locally at http://localhost:8000/

# 2nd Case
Now we can use this setup to run some commands against our application.
```
$ docker-compose run composer install
```
## Output
```
Loading composer repositories with package information
Updating dependencies (including require-dev)
Package operations: 4 installs, 0 updates, 0 removals
  - Installing zendframework/zend-servicemanager (2.0.8): Downloading (100%)
  - Installing zendframework/zend-stdlib (2.0.8): Downloading (100%)
  - Installing zendframework/zend-math (2.0.8): Downloading (100%)
  - Installing zendframework/zend-crypt (2.0.8): Downloading (100%)
zendframework/zend-servicemanager suggests installing zendframework/zend-di (Zend\Di component)
zendframework/zend-stdlib suggests installing pecl-weakref (Implementation of weak references for Stdlib\CallbackHandler)
zendframework/zend-stdlib suggests installing zendframework/zend-eventmanager (To support aggregate hydrator usage)
zendframework/zend-stdlib suggests installing zendframework/zend-serializer (Zend\Serializer component)
zendframework/zend-stdlib suggests installing zendframework/zend-filter (To support naming strategy hydrator usage)
zendframework/zend-math suggests installing ircmaxell/random-lib (Fallback random byte generator for Zend\Math\Rand if OpenSSL/Mcrypt extensions are unavailable)
zendframework/zend-math suggests installing ext-bcmath (If using the bcmath functionality)
zendframework/zend-math suggests installing ext-gmp (If using the gmp functionality)
zendframework/zend-crypt suggests installing ext-mcrypt (Required for most features of Zend\Crypt)
Writing lock file
Generating autoload files
```

## Question - Why?
Because services name in docker-compose.yml is composer, that's why "docker-compose run composer install"
# Project structure:
``` 
myproject.
├── data -> Create a folder for storing various data of the project, such as database file, logs, (chmod -R 0777 data/ to remove issues Service 'mysql' failed to build on fresh install )
├── laradock -> git clone https://github.com/laradock/laradock.git
└── zendframework -> git clone https://github.com/zendframework/zendframework.git
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

**Run** 
docker-compose up -d nginx php-fpm mysql phpmyadmin

**Issues**
a) Service 'mysql' failed to build on fresh install (Solution - chmod -R 755 data/)
b) ERROR: Service 'mysql' failed to build: Please provide a source image with `from` prior to commit  (Solution - https://fabianlee.org/2017/03/07/docker-installing-docker-ce-on-ubuntu-14-04-and-16-04/)



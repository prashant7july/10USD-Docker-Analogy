How to run Dockerfile for PHP Package Manager
=============================================

## Create index.php
```bash
<?php 

require_once 'vendor/autoload.php';
use Zend\Crypt\Password\Bcrypt;

$bcrypt = new Bcrypt(); 
echo $password = $bcrypt->create("test"); 
```

## Create Dockerfile
```bash
FROM php:7.1.9-apache
RUN apt-get update && \
  apt-get install -y --no-install-recommends git zip

WORKDIR /var/www/html

COPY composer.json composer.lock ./
# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer install --no-scripts --no-autoloader

COPY . .
RUN composer dump-autoload --optimize && composer run-script post-install-cmd
# CMD ["composer","install"]
```

## Create composer.json
```bash
{
    "require": {
       "zendframework/zend-crypt":"2.0.*"
    }
}
```

## Execute Command
```bash
$ docker build -t mywebapp:v1 .
```

## Output
```bash
Sending build context to Docker daemon 4.096 kB
Step 1 : FROM php:7.1.9-apache
7.1.9-apache: Pulling from library/php

aa18ad1a0d33: Pull complete 
29d5f85af454: Pull complete 
eca642e7826b: Pull complete 
3638d91a9039: Pull complete 
3646a95ab677: Pull complete 
628b8373e193: Pull complete 
c24a2b2280ed: Pull complete 
f968b84cbbbc: Pull complete 
60fafe14064c: Pull complete 
bac57a95ddf1: Pull complete 
056ffd8ba0fc: Pull complete 
3c7a6d81f935: Pull complete 
1538d9314280: Pull complete 
Digest: sha256:a08e607368f9010f79171f684f1f128abded1b0b35e4293809819fcaa148f85a
Status: Downloaded newer image for php:7.1.9-apache
 ---> 732d9549c027
Step 2 : RUN apt-get update &&   apt-get install -y --no-install-recommends git zip
 ---> Running in 1789e9581d1b
Ign http://deb.debian.org jessie InRelease
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Get:2 http://deb.debian.org jessie-updates InRelease [145 kB]
Get:3 http://security.debian.org jessie/updates/main amd64 Packages [607 kB]
Get:4 http://deb.debian.org jessie Release.gpg [2434 B]
Get:5 http://deb.debian.org jessie-updates/main amd64 Packages [23.1 kB]
Get:6 http://deb.debian.org jessie Release [148 kB]
Get:7 http://deb.debian.org jessie/main amd64 Packages [9064 kB]
Fetched 10.1 MB in 31s (319 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following extra packages will be installed:
  git-man libcurl3-gnutls liberror-perl
Suggested packages:
  gettext-base git-daemon-run git-daemon-sysvinit git-doc git-el git-email
  git-gui gitk gitweb git-arch git-cvs git-mediawiki git-svn
Recommended packages:
  less rsync ssh-client unzip
The following NEW packages will be installed:
  git git-man libcurl3-gnutls liberror-perl zip
0 upgraded, 5 newly installed, 0 to remove and 26 not upgraded.
Need to get 5465 kB of archives.
After this operation, 25.0 MB of additional disk space will be used.
Get:1 http://deb.debian.org/debian/ jessie/main libcurl3-gnutls amd64 7.38.0-4+deb8u8 [252 kB]
Get:2 http://deb.debian.org/debian/ jessie/main liberror-perl all 0.17-1.1 [22.4 kB]
Get:3 http://deb.debian.org/debian/ jessie/main git-man all 1:2.1.4-2.1+deb8u5 [1268 kB]
Get:4 http://deb.debian.org/debian/ jessie/main git amd64 1:2.1.4-2.1+deb8u5 [3694 kB]
Get:5 http://deb.debian.org/debian/ jessie/main zip amd64 3.0-8 [228 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 5465 kB in 34s (157 kB/s)
Selecting previously unselected package libcurl3-gnutls:amd64.
(Reading database ... 13562 files and directories currently installed.)
Preparing to unpack .../libcurl3-gnutls_7.38.0-4+deb8u8_amd64.deb ...
Unpacking libcurl3-gnutls:amd64 (7.38.0-4+deb8u8) ...
Selecting previously unselected package liberror-perl.
Preparing to unpack .../liberror-perl_0.17-1.1_all.deb ...
Unpacking liberror-perl (0.17-1.1) ...
Selecting previously unselected package git-man.
Preparing to unpack .../git-man_1%3a2.1.4-2.1+deb8u5_all.deb ...
Unpacking git-man (1:2.1.4-2.1+deb8u5) ...
Selecting previously unselected package git.
Preparing to unpack .../git_1%3a2.1.4-2.1+deb8u5_amd64.deb ...
Unpacking git (1:2.1.4-2.1+deb8u5) ...
Selecting previously unselected package zip.
Preparing to unpack .../archives/zip_3.0-8_amd64.deb ...
Unpacking zip (3.0-8) ...
Setting up libcurl3-gnutls:amd64 (7.38.0-4+deb8u8) ...
Setting up liberror-perl (0.17-1.1) ...
Setting up git-man (1:2.1.4-2.1+deb8u5) ...
Setting up git (1:2.1.4-2.1+deb8u5) ...
Setting up zip (3.0-8) ...
Processing triggers for libc-bin (2.19-18+deb8u10) ...
 ---> c24c2cf26541
Removing intermediate container 1789e9581d1b
Step 3 : WORKDIR /var/www/html
 ---> Running in d6f8ec32cf7d
 ---> dcbba1d87954
Removing intermediate container d6f8ec32cf7d
Step 4 : COPY composer.json composer.lock ./
lstat composer.lock: no such file or directory
```

## Question - How to resolve execute below command "no such file or directory"?
### Remove Container
```bash
$ docker rm $(docker ps -aq)
```

### Remove Images
```bash
$ docker rmi $(docker images -q)
```
### Install composer install [You system also install composer, then this command work]
```bash
$ composer install
```
### Execute Command
```bash
$ docker build -t mywebapp:v1 .
```

## Output
```bash
Sending build context to Docker daemon 500.7 kB
Step 1 : FROM php:7.1.9-apache
7.1.9-apache: Pulling from library/php
aa18ad1a0d33: Pull complete 
29d5f85af454: Pull complete 
eca642e7826b: Pull complete 
3638d91a9039: Pull complete 
3646a95ab677: Pull complete 
628b8373e193: Pull complete 
c24a2b2280ed: Pull complete 
f968b84cbbbc: Pull complete 
60fafe14064c: Pull complete 
bac57a95ddf1: Pull complete 
056ffd8ba0fc: Pull complete 
3c7a6d81f935: Pull complete 
1538d9314280: Pull complete 
Digest: sha256:a08e607368f9010f79171f684f1f128abded1b0b35e4293809819fcaa148f85a
Status: Downloaded newer image for php:7.1.9-apache
 ---> 732d9549c027
Step 2 : RUN apt-get update &&   apt-get install -y --no-install-recommends git zip
 ---> Running in 47c3ffebc657
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Get:2 http://security.debian.org jessie/updates/main amd64 Packages [607 kB]
Ign http://deb.debian.org jessie InRelease
Get:3 http://deb.debian.org jessie-updates InRelease [145 kB]
Get:4 http://deb.debian.org jessie Release.gpg [2434 B]
Get:5 http://deb.debian.org jessie-updates/main amd64 Packages [23.1 kB]
Get:6 http://deb.debian.org jessie Release [148 kB]
Get:7 http://deb.debian.org jessie/main amd64 Packages [9064 kB]
Fetched 10.1 MB in 1min 8s (147 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following extra packages will be installed:
  git-man libcurl3-gnutls liberror-perl
Suggested packages:
  gettext-base git-daemon-run git-daemon-sysvinit git-doc git-el git-email
  git-gui gitk gitweb git-arch git-cvs git-mediawiki git-svn
Recommended packages:
  less rsync ssh-client unzip
The following NEW packages will be installed:
  git git-man libcurl3-gnutls liberror-perl zip
0 upgraded, 5 newly installed, 0 to remove and 26 not upgraded.
Need to get 5465 kB of archives.
After this operation, 25.0 MB of additional disk space will be used.
Get:1 http://deb.debian.org/debian/ jessie/main libcurl3-gnutls amd64 7.38.0-4+deb8u8 [252 kB]
Get:2 http://deb.debian.org/debian/ jessie/main liberror-perl all 0.17-1.1 [22.4 kB]
Get:3 http://deb.debian.org/debian/ jessie/main git-man all 1:2.1.4-2.1+deb8u5 [1268 kB]
Get:4 http://deb.debian.org/debian/ jessie/main git amd64 1:2.1.4-2.1+deb8u5 [3694 kB]
Get:5 http://deb.debian.org/debian/ jessie/main zip amd64 3.0-8 [228 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 5465 kB in 47s (115 kB/s)
Selecting previously unselected package libcurl3-gnutls:amd64.
(Reading database ... 13562 files and directories currently installed.)
Preparing to unpack .../libcurl3-gnutls_7.38.0-4+deb8u8_amd64.deb ...
Unpacking libcurl3-gnutls:amd64 (7.38.0-4+deb8u8) ...
Selecting previously unselected package liberror-perl.
Preparing to unpack .../liberror-perl_0.17-1.1_all.deb ...
Unpacking liberror-perl (0.17-1.1) ...
Selecting previously unselected package git-man.
Preparing to unpack .../git-man_1%3a2.1.4-2.1+deb8u5_all.deb ...
Unpacking git-man (1:2.1.4-2.1+deb8u5) ...
Selecting previously unselected package git.
Preparing to unpack .../git_1%3a2.1.4-2.1+deb8u5_amd64.deb ...
Unpacking git (1:2.1.4-2.1+deb8u5) ...
Selecting previously unselected package zip.
Preparing to unpack .../archives/zip_3.0-8_amd64.deb ...
Unpacking zip (3.0-8) ...
Setting up libcurl3-gnutls:amd64 (7.38.0-4+deb8u8) ...
Setting up liberror-perl (0.17-1.1) ...
Setting up git-man (1:2.1.4-2.1+deb8u5) ...
Setting up git (1:2.1.4-2.1+deb8u5) ...
Setting up zip (3.0-8) ...
Processing triggers for libc-bin (2.19-18+deb8u10) ...
 ---> d1e6fb4f6c44
Removing intermediate container 47c3ffebc657
Step 3 : WORKDIR /var/www/html
 ---> Running in fed9a5d67c9b
 ---> 342243829771
Removing intermediate container fed9a5d67c9b
Step 4 : COPY composer.json composer.lock ./
 ---> 374b93a69a68
Removing intermediate container cf874a50d42f
Step 5 : ENV COMPOSER_ALLOW_SUPERUSER 1
 ---> Running in 88e9906a5eef
 ---> bc58d5d32d07
Removing intermediate container 88e9906a5eef
Step 6 : RUN composer install --no-scripts --no-autoloader
 ---> Running in 753c1d39cd56
/bin/sh: 1: composer: not found
The command '/bin/sh -c composer install --no-scripts --no-autoloader' returned a non-zero code: 127
```

## Question - Why "composer: not found"?
Answer:

Your Dockerfile never installs composer into the Docker image.

The default PHP images that you use as a base image do not incude composer in them, so running composer commands will fail unless you install it yourself.

You can see an example of installing composer here: https://github.com/shipping-docker/vessel/blob/master/docker-files/docker/app/Dockerfile#L30

## Modify Dockerfile
```bash
#FROM php:7.0-cli
FROM php:7.1.9-apache

RUN apt-get update
RUN apt-get install -y zip unzip curl git
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

WORKDIR /var/www/html

COPY composer.json ./
RUN composer install --no-scripts --no-autoloader

COPY . .
RUN composer dump-autoload --optimize 
```

## Remove Container
```bash
* $ docker rm $(docker ps -aq)
```

## Remove Images
```bash
* $ docker rmi $(docker images -q)
```

## Execute Command
```bash
* $ docker build -t mywebapp:v1 .
```

## Output
```bash
Sending build context to Docker daemon 500.7 kB
Step 1 : FROM php:7.1.9-apache
7.1.9-apache: Pulling from library/php

aa18ad1a0d33: Pull complete 
29d5f85af454: Pull complete 
eca642e7826b: Pull complete 
3638d91a9039: Pull complete 
3646a95ab677: Pull complete 
628b8373e193: Pull complete 
c24a2b2280ed: Pull complete 
f968b84cbbbc: Pull complete 
60fafe14064c: Pull complete 
bac57a95ddf1: Pull complete 
056ffd8ba0fc: Pull complete 
3c7a6d81f935: Pull complete 
1538d9314280: Pull complete 
Digest: sha256:a08e607368f9010f79171f684f1f128abded1b0b35e4293809819fcaa148f85a
Status: Downloaded newer image for php:7.1.9-apache
 ---> 732d9549c027
Step 2 : RUN apt-get update
 ---> Running in cdd232787a6f
Get:1 http://security.debian.org jessie/updates InRelease [63.1 kB]
Ign http://deb.debian.org jessie InRelease
Get:2 http://security.debian.org jessie/updates/main amd64 Packages [607 kB]
Get:3 http://deb.debian.org jessie-updates InRelease [145 kB]
Get:4 http://deb.debian.org jessie Release.gpg [2434 B]
Get:5 http://deb.debian.org jessie-updates/main amd64 Packages [23.1 kB]
Get:6 http://deb.debian.org jessie Release [148 kB]
Get:7 http://deb.debian.org jessie/main amd64 Packages [9064 kB]
Fetched 10.1 MB in 60s (167 kB/s)
Reading package lists...
 ---> 9c56577e2bdd
Removing intermediate container cdd232787a6f
Step 3 : RUN apt-get install -y zip unzip curl git
 ---> Running in 58092ba9bae0
Reading package lists...
Building dependency tree...
Reading state information...
The following extra packages will be installed:
  git-man less libcurl3 libcurl3-gnutls liberror-perl libpopt0 libx11-6
  libx11-data libxau6 libxcb1 libxdmcp6 libxext6 libxmuu1 openssh-client rsync
  xauth
Suggested packages:
  gettext-base git-daemon-run git-daemon-sysvinit git-doc git-el git-email
  git-gui gitk gitweb git-arch git-cvs git-mediawiki git-svn ssh-askpass
  libpam-ssh keychain monkeysphere openssh-server
Recommended packages:
  ssh-client
The following NEW packages will be installed:
  git git-man less libcurl3-gnutls liberror-perl libpopt0 libx11-6 libx11-data
  libxau6 libxcb1 libxdmcp6 libxext6 libxmuu1 openssh-client rsync unzip xauth
  zip
The following packages will be upgraded:
  curl libcurl3
2 upgraded, 18 newly installed, 0 to remove and 24 not upgraded.
Need to get 8401 kB of archives.
After this operation, 34.0 MB of additional disk space will be used.
Get:1 http://security.debian.org/ jessie/updates/main rsync amd64 3.1.1-3+deb8u1 [390 kB]
Get:2 http://deb.debian.org/debian/ jessie/main libpopt0 amd64 1.16-10 [49.2 kB]
Get:3 http://deb.debian.org/debian/ jessie/main curl amd64 7.38.0-4+deb8u8 [201 kB]
Get:4 http://deb.debian.org/debian/ jessie/main libcurl3 amd64 7.38.0-4+deb8u8 [260 kB]
Get:5 http://deb.debian.org/debian/ jessie/main libcurl3-gnutls amd64 7.38.0-4+deb8u8 [252 kB]
Get:6 http://deb.debian.org/debian/ jessie/main libxau6 amd64 1:1.0.8-1 [20.7 kB]
Get:7 http://deb.debian.org/debian/ jessie/main libxdmcp6 amd64 1:1.1.1-1+b1 [24.9 kB]
Get:8 http://deb.debian.org/debian/ jessie/main libxcb1 amd64 1.10-3+b1 [44.4 kB]
Get:9 http://deb.debian.org/debian/ jessie/main libx11-data all 2:1.6.2-3+deb8u1 [126 kB]
Get:10 http://deb.debian.org/debian/ jessie/main libx11-6 amd64 2:1.6.2-3+deb8u1 [728 kB]
Get:11 http://deb.debian.org/debian/ jessie/main libxext6 amd64 2:1.3.3-1 [52.7 kB]
Get:12 http://deb.debian.org/debian/ jessie/main libxmuu1 amd64 2:1.1.2-1 [23.3 kB]
Get:13 http://deb.debian.org/debian/ jessie/main less amd64 458-3 [124 kB]
Get:14 http://deb.debian.org/debian/ jessie/main openssh-client amd64 1:6.7p1-5+deb8u4 [693 kB]
Get:15 http://deb.debian.org/debian/ jessie/main liberror-perl all 0.17-1.1 [22.4 kB]
Get:16 http://deb.debian.org/debian/ jessie/main git-man all 1:2.1.4-2.1+deb8u5 [1268 kB]
Get:17 http://deb.debian.org/debian/ jessie/main git amd64 1:2.1.4-2.1+deb8u5 [3694 kB]
Get:18 http://deb.debian.org/debian/ jessie/main unzip amd64 6.0-16+deb8u3 [162 kB]
Get:19 http://deb.debian.org/debian/ jessie/main xauth amd64 1:1.0.9-1 [38.2 kB]
Get:20 http://deb.debian.org/debian/ jessie/main zip amd64 3.0-8 [228 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 8401 kB in 1min 16s (109 kB/s)
Selecting previously unselected package libpopt0:amd64.
(Reading database ... 13562 files and directories currently installed.)
Preparing to unpack .../libpopt0_1.16-10_amd64.deb ...
Unpacking libpopt0:amd64 (1.16-10) ...
Preparing to unpack .../curl_7.38.0-4+deb8u8_amd64.deb ...
Unpacking curl (7.38.0-4+deb8u8) over (7.38.0-4+deb8u5) ...
Preparing to unpack .../libcurl3_7.38.0-4+deb8u8_amd64.deb ...
Unpacking libcurl3:amd64 (7.38.0-4+deb8u8) over (7.38.0-4+deb8u5) ...
Selecting previously unselected package libcurl3-gnutls:amd64.
Preparing to unpack .../libcurl3-gnutls_7.38.0-4+deb8u8_amd64.deb ...
Unpacking libcurl3-gnutls:amd64 (7.38.0-4+deb8u8) ...
Selecting previously unselected package libxau6:amd64.
Preparing to unpack .../libxau6_1%3a1.0.8-1_amd64.deb ...
Unpacking libxau6:amd64 (1:1.0.8-1) ...
Selecting previously unselected package libxdmcp6:amd64.
Preparing to unpack .../libxdmcp6_1%3a1.1.1-1+b1_amd64.deb ...
Unpacking libxdmcp6:amd64 (1:1.1.1-1+b1) ...
Selecting previously unselected package libxcb1:amd64.
Preparing to unpack .../libxcb1_1.10-3+b1_amd64.deb ...
Unpacking libxcb1:amd64 (1.10-3+b1) ...
Selecting previously unselected package libx11-data.
Preparing to unpack .../libx11-data_2%3a1.6.2-3+deb8u1_all.deb ...
Unpacking libx11-data (2:1.6.2-3+deb8u1) ...
Selecting previously unselected package libx11-6:amd64.
Preparing to unpack .../libx11-6_2%3a1.6.2-3+deb8u1_amd64.deb ...
Unpacking libx11-6:amd64 (2:1.6.2-3+deb8u1) ...
Selecting previously unselected package libxext6:amd64.
Preparing to unpack .../libxext6_2%3a1.3.3-1_amd64.deb ...
Unpacking libxext6:amd64 (2:1.3.3-1) ...
Selecting previously unselected package libxmuu1:amd64.
Preparing to unpack .../libxmuu1_2%3a1.1.2-1_amd64.deb ...
Unpacking libxmuu1:amd64 (2:1.1.2-1) ...
Selecting previously unselected package less.
Preparing to unpack .../archives/less_458-3_amd64.deb ...
Unpacking less (458-3) ...
Selecting previously unselected package openssh-client.
Preparing to unpack .../openssh-client_1%3a6.7p1-5+deb8u4_amd64.deb ...
Unpacking openssh-client (1:6.7p1-5+deb8u4) ...
Selecting previously unselected package liberror-perl.
Preparing to unpack .../liberror-perl_0.17-1.1_all.deb ...
Unpacking liberror-perl (0.17-1.1) ...
Selecting previously unselected package git-man.
Preparing to unpack .../git-man_1%3a2.1.4-2.1+deb8u5_all.deb ...
Unpacking git-man (1:2.1.4-2.1+deb8u5) ...
Selecting previously unselected package git.
Preparing to unpack .../git_1%3a2.1.4-2.1+deb8u5_amd64.deb ...
Unpacking git (1:2.1.4-2.1+deb8u5) ...
Selecting previously unselected package rsync.
Preparing to unpack .../rsync_3.1.1-3+deb8u1_amd64.deb ...
Unpacking rsync (3.1.1-3+deb8u1) ...
Selecting previously unselected package unzip.
Preparing to unpack .../unzip_6.0-16+deb8u3_amd64.deb ...
Unpacking unzip (6.0-16+deb8u3) ...
Selecting previously unselected package xauth.
Preparing to unpack .../xauth_1%3a1.0.9-1_amd64.deb ...
Unpacking xauth (1:1.0.9-1) ...
Selecting previously unselected package zip.
Preparing to unpack .../archives/zip_3.0-8_amd64.deb ...
Unpacking zip (3.0-8) ...
Processing triggers for mime-support (3.58) ...
Processing triggers for systemd (215-17+deb8u7) ...
Setting up libpopt0:amd64 (1.16-10) ...
Setting up libcurl3:amd64 (7.38.0-4+deb8u8) ...
Setting up curl (7.38.0-4+deb8u8) ...
Setting up libcurl3-gnutls:amd64 (7.38.0-4+deb8u8) ...
Setting up libxau6:amd64 (1:1.0.8-1) ...
Setting up libxdmcp6:amd64 (1:1.1.1-1+b1) ...
Setting up libxcb1:amd64 (1.10-3+b1) ...
Setting up libx11-data (2:1.6.2-3+deb8u1) ...
Setting up libx11-6:amd64 (2:1.6.2-3+deb8u1) ...
Setting up libxext6:amd64 (2:1.3.3-1) ...
Setting up libxmuu1:amd64 (2:1.1.2-1) ...
Setting up less (458-3) ...
debconf: unable to initialize frontend: Dialog
debconf: (TERM is not set, so the dialog frontend is not usable.)
debconf: falling back to frontend: Readline
Setting up openssh-client (1:6.7p1-5+deb8u4) ...
Setting up liberror-perl (0.17-1.1) ...
Setting up git-man (1:2.1.4-2.1+deb8u5) ...
Setting up git (1:2.1.4-2.1+deb8u5) ...
Setting up rsync (3.1.1-3+deb8u1) ...
invoke-rc.d: policy-rc.d denied execution of restart.
Setting up unzip (6.0-16+deb8u3) ...
Setting up xauth (1:1.0.9-1) ...
Setting up zip (3.0-8) ...
Processing triggers for libc-bin (2.19-18+deb8u10) ...
Processing triggers for systemd (215-17+deb8u7) ...
 ---> 16bea006c7e8
Removing intermediate container 58092ba9bae0
Step 4 : RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
 ---> Running in 63117eec0c64
 ---> 3245e90b4d93
Removing intermediate container 63117eec0c64
Step 5 : RUN php composer-setup.php --install-dir=/usr/bin --filename=composer
 ---> Running in b69eb619f2ad
All settings correct for using Composer
Downloading...

Composer (version 1.6.2) successfully installed to: /usr/bin/composer
Use it: php /usr/bin/composer

 ---> a11097a433f2
Removing intermediate container b69eb619f2ad
Step 6 : RUN php -r "unlink('composer-setup.php');"
 ---> Running in 3c899b019d0c
 ---> 9f2369ccc3c9
Removing intermediate container 3c899b019d0c
Step 7 : WORKDIR /var/www/html
 ---> Running in 7ea74bcbcc6f
 ---> 6bd0c41e0842
Removing intermediate container 7ea74bcbcc6f
Step 8 : COPY composer.json ./
 ---> 10a52820a56f
Removing intermediate container 78322d3a5458
Step 9 : RUN composer install --no-scripts --no-autoloader
 ---> Running in 0cd5e37211ad
Do not run Composer as root/super user! See https://getcomposer.org/root for details
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
 ---> 7bf24e491cb7
Removing intermediate container 0cd5e37211ad
Step 10 : COPY . .
 ---> 334695e6e984
Removing intermediate container f300e22ac9e4
Step 11 : RUN composer dump-autoload --optimize
 ---> Running in 8500e3a70eb3
Do not run Composer as root/super user! See https://getcomposer.org/root for details
Generating optimized autoload files
 ---> 3f4009756a4a
Removing intermediate container 8500e3a70eb3
Successfully built 3f4009756a4a
```

## Run Docker
```bash
$ docker run -it --name testweb mywebapp:v1 /bin/bash
```
## Output
```bash
root@97bbf34b4694:/var/www/html# ls -l
total 28
-rw-rw-r-- 1 root root  418 Jan 17 06:52 Dockerfile
-rw-rw-r-- 1 root root   68 Dec 27 05:29 composer.json
-rw-rw-r-- 1 root root 8296 Jan 17 05:53 composer.lock
-rw-rw-r-- 1 root root  144 Dec 27 05:28 index.php
drwxrwxr-x 7 root root 4096 Jan 17 07:03 vendor
root@97bbf34b4694:/var/www/html# 
```

## Run Docker
```bash
$ docker run --rm -it \
    -p 8888:80 \
    -v $(pwd):/var/www/html \
    mywebapp:v1 \
    php -S 0.0.0.0:8888 -t /var/www/html/index.php
/var/www/html/index.php is not a directory.
```

## Question - Why?

First, you're adding composer.json and running `composer install...` within the Dockerfile, which is creating files in /var/www/html.

However, when you then run the container and mount $(pwd):/var/www/html, you're actually hiding/removing all the files (composer.json, composer.lock, the created vendor directory and *all* other files you copy into that location) in /var/www/html - they will get over-written with whatever is your Mac's current directory $(pwd), so the container will not see them. Sharing volumes is one-directional only - whatever is on your local machine will over-write whatever is inside the container.

Second, you are forwarding your local machine's port 8888 to the container's port 80, but then binding PHP's server to port 8888. It needs to bind to port 80. 

Third, you use a specific file (/var/www/html/index.php) instead of a directory with the -t flag. The -t flag I believe needs a directory, not a file (/var/www/html).
```bash
docker run --rm -it \
    -v $(pwd):/var/www/html \
    -p 8888:80 \
    mywebapp:v1 \
    php -S 0.0.0.0:80 -t /var/www/html
```
And view your website locally at http://localhost:8888/.

# Install composer
```
# Install composer globally
RUN echo "Install composer globally"
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
```
#!/bin/bash
IMG_NAME="mysqlserver"
VERSION="latest"
PORTS="3302:3306"

# You need .env file
DATABASE_NAME="mysqldb"
DATABASE_HOST=127.0.0.1
DATABASE_PASSWORD=DBPASS
DATABASE_USERNAME=ROOTNAME

# Remove image if Exists
docker rm $IMG_NAME

# Run Container
sudo docker run -v /mysql/data:/var/lib/mysql \
    --name mysqldb \
    -e MYSQL_DATABASE='mysqldb' \
    -e MYSQL_USER='mysql' \
    -e MYSQL_PASSWORD='mysql' \
    -e MYSQL_ALLOW_EMPTY_PASSWORD='no' \
    -e MYSQL_ROOT_PASSWORD='mysql' \
    -d mysql

#!/bin/bash
# https://github.com/JREAM/demo-code/blob/master/backend/laravel/docker-build.sh
IMG_NAME="jream-demo-laravel"
VERSION="0.0.1"
PORTS="8050:8080"

# Remove image if Exists
docker rm $IMG_NAME

# Build Container
docker build . -t $IMG_NAME:$VERSION

# Run Container
docker run --name $IMG_NAME -d -p $PORTS $IMG_NAME:$VERSION /bin/sh
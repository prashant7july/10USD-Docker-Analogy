#!/bin/bash
# Build Redis Images
docker build -t redis-server .
# Run a Redis-Server Instance
docker run --name redisinstance -t redis-server
# docker run --rm -it -p 0.0.0.0:6379:6379 --name redis redis:alpine [FOR DOCKER HUB]
# docker run --rm -it -p 0.0.0.0:6379:6379 --name redisinstance redis-server
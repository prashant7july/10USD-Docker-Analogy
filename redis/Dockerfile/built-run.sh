#!/bin/bash
# Build Redis Images
docker build -t redis-server .
# Run a Redis-Server Instance
docker run --name redisinstance -t redis-server
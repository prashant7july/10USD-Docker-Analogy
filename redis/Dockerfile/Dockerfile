# Set the base image
FROM ubuntu

# Dockerfile author / maintainer 
MAINTAINER Name <prashant7july@gmail.com>

# Update application repository list and install the Redis server. 
RUN apt-get update && apt-get install -y redis-server

# Expose default port
EXPOSE 6379

# Set the default command
ENTRYPOINT ["/usr/bin/redis-server"]
# Set the base image
FROM ubuntu

# Dockerfile author / maintainer 
MAINTAINER Name <prashant7july@gmail.com>

# Update application repository list and install the Redis server. 
RUN apt-get update && apt-get install -y redis-server

# Expose default port
EXPOSE 6379

# Include the start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
WORKDIR /root

# CMD gets executed when a container gets run.
CMD ["start.sh"]
# CMD start.sh
# RUN ["chmod", "+x", "start.sh"]
# ENTRYPOINT redis-server --daemonize yes && bash
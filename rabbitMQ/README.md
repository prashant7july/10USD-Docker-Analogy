# Install RabbitMQ
* [RabbitMQ Dockerfile for trusted automated Docker builds](https://github.com/dockerfile/rabbitmq)
* [setup-a-rabbitmq-cluster-on-ubuntu](https://thoughtsimproved.wordpress.com/2015/01/03/tech-recipe-setup-a-rabbitmq-cluster-on-ubuntu/)
* [php-redis-client](https://github.com/cheprasov/php-redis-client)
* [docker-rabbitmq-ha-cluster](https://github.com/ypereirareis/docker-rabbitmq-ha-cluster)


#!/bin/bash
response=$(
    curl -u stage:ZmEGNWrB7p7ws5Vl -XGET http://172.16.245.15:15672/api/queues \
        --write-out %{http_code} \
        --silent \
        --output /dev/null \
)
test "$response" -ge 200 && test "$response" -le 299

#Stage
#curl -u stage:ZmEGNWrB7p7ws5Vl -XGET http://172.16.245.15:15672/api/queues | jq .[].name

### Get response from Primary Site
primaryResponse=$(curl --write-out %{http_code} --silent --output /dev/null curl -u stage:ZmEGNWrB7p7ws5Vl -XGET "http://172.16.245.15:15672/api/queues")
echo $primaryResponse


if [ "$primaryResponse" = "200" ]
then
  echo "Primary Site is Up"
else
  echo "Email already sent"
fi

# CLI COMMAND
# sudo rabbitmqctl list_queues


#Reference - https://stackoverflow.com/questions/31530239/use-rabbitmqadmin-in-docker
# https://github.com/smallfish/rabbitmq-httpgit diff
# curl -u stage:ZmEGNWrB7p7ws5Vl -i -X POST http://172.16.245.15:15672/api/queues -d {"name": "q1"}
# curl -u guest:guest -XGET http://localhost:15672/api/queues

# https://gist.github.com/vmwarecode/358097f09e1206b69d79
# https://pulse.mozilla.org/api/
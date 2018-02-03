# [Redis with Cluster](https://github.com/galal-hussein/docker_redis-cl)
## Start Nodes with Different port
To start each node with different port change the value of the environment variable $REDIS_NODE_PORT during running the node.
```
$ docker run -e "REDIS_NODE_PORT=6000" --name node1 -d husseingalal/redis_cl_node
```

**OR**
```
docker run -e "REDIS_NODE_PORT=7000" --name node1 -p 7000:7000 -d husseingalal/redis_cl_node
docker run -e "REDIS_NODE_PORT=7001" --name node2 -p 7001:7001 -d husseingalal/redis_cl_node
docker run -e "REDIS_NODE_PORT=7002" --name node3 -p 7002:7002 -d husseingalal/redis_cl_node
docker run -e "REDIS_NODE_PORT=7003" --name node4 -p 7003:7003 -d husseingalal/redis_cl_node
docker run -e "REDIS_NODE_PORT=7004" --name node5 -p 7004:7004 -d husseingalal/redis_cl_node
docker run -e "REDIS_NODE_PORT=7005" --name node6 -p 7005:7005 -d husseingalal/redis_cl_node
```

**OR**
```
$ docker pull husseingalal/redis_cl_node
$ docker run -d --name redis_node_1 -p 7000:7000 husseingalal/redis_cl_node
$ docker run -d --name redis_node_2 -p 7001:7000 husseingalal/redis_cl_node
$ docker run -d --name redis_node_3 -p 7002:7000 husseingalal/redis_cl_node
$ docker run -d --name redis_node_4 -p 7003:7000 husseingalal/redis_cl_node
$ docker run -d --name redis_node_5 -p 7004:7000 husseingalal/redis_cl_node
$ docker run -d --name redis_node_6 -p 7005:7000 husseingalal/redis_cl_node
```

If you run redis (Docker Hub) image that is not enable cluster
```
$ docker run -d -p 7000:7000 redis --port 7000
```

```
$ redis-cli -p 7000
> cluster info
```

```
$ redis-cli -c -p 7000 cluster info [To check node is clustered or not]
```


How to run a redis cluster with docker instance with a different port 
```
docker run -it \
  -p 7000:7000 \
  -p 7001:7001 \
  -p 7002:7002 \
  -p 7003:7003 \
  -p 7004:7004 \
  -p 7005:7005 \
  -p 7006:7006 \
  -p 7007:7007 \
  --name redisserver \
  grokzen/redis-cluster
```

#### Connecting to Cluster
On linux, this will be the private IP address of the container which can be obtained from
```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <container name or ID>
```

How to run a redis docker instance with a different port, that is not cluster
```
docker run -d -p 7000:7000 redis --port 7000
redis-cli -p 7000
OR
redis-cli -c -p 7000 cluster info [to check node is clustered or not]

docker run -d -p 7001:7001 redis --port 7001
redis-cli -p 7001

docker run -d -p 7002:7002 redis --port 7002
redis-cli -p 7002

docker run -d -p 7003:7003 redis --port 7003
redis-cli -p 7003

docker run -d -p 7004:7004 redis --port 7004
redis-cli -p 7004

docker run -d -p 7005:7005 redis --port 7005
redis-cli -p 7005
```

```
$ ps aux | grep redis
redis      945  0.1  0.0  40136  6612 ?        Ssl  09:55   0:06 /usr/bin/redis-server 127.0.0.1:6379
guest-t+  7541  0.1  0.1  41648  9548 ?        Ssl  11:04   0:02 redis-server *:7000
guest-t+  8327  0.2  0.1  41648  9600 ?        Ssl  11:33   0:00 redis-server *:7001
guest-t+  8446  0.1  0.1  41648  9588 ?        Ssl  11:33   0:00 redis-server *:7002
guest-t+  8554  0.1  0.1  41648  9544 ?        Ssl  11:33   0:00 redis-server *:7003
guest-t+  8650  0.3  0.1  41648  9620 ?        Ssl  11:33   0:00 redis-server *:7004
guest-t+  8750  0.3  0.1  41648  9500 ?        Ssl  11:33   0:00 redis-server *:7005
abc       8791  0.0  0.0  14224  1028 pts/2    S+   11:33   0:00 grep --color=auto redis
abc@abc-To-be-filled-by-O-E-M:~$ 
```
SO That is wrong becuase node is not clustered.

## Redis Cluster with master/slave replication - [How to create a cluster without redis-trib.rb file](http://pingredis.blogspot.in/2016/09/redis-cluster-how-to-create-cluster.html)

#### 1. Create redis nodes are started in cluster mode (Redis with Cluster)
* [redis without cluster](https://github.com/developersworkspace/Docker-Samples/tree/master/redis)
* [redis-cluster](https://github.com/developersworkspace/Docker-Samples/tree/master/redis-cluster)
* [Redis-Cluster with shellscript](https://github.com/developersworkspace/Production-Apps/tree/master/Redis-Cluster)
* [docker-redis-cluster](https://github.com/eloycoto/docker-redis-cluster)
* [docker-redis-cluster](https://github.com/Grokzen/docker-redis-cluster)
```
docker run -it \
  -p 7000:7000 \
  -p 7001:7001 \
  -p 7002:7002 \
  -p 7003:7003 \
  -p 7004:7004 \
  -p 7005:7005 \
  -p 7006:7006 \
  -p 7007:7007 \
  --name redisserver \
  grokzen/redis-cluster
```

[docker-redis-cluster](https://github.com/MyPureCloud/docker-redis-cluster)
```
docker run -it \
  -p 7000:7000 \
  -p 7001:7001 \
  -p 7002:7002 \
  -p 7003:7003 \
  -p 7004:7004 \
  -p 7005:7005 \
  --name redisserver \
  druotic/redis-cluster
```


#### 2. Check redis is indeed running.
```
$ ps -ef | grep redis
```
**OUTPUT**
```
redis      945     1  0 09:55 ?        00:00:16 /usr/bin/redis-server 127.0.0.1:6379
abc      11060  5259  0 12:39 pts/2    00:00:00 docker run -it -p 7000:7000 -p 7001:7001 -p 7002:7002 -p 7003:7003 -p 7004:7004 -p 7005:7005 -p 7006:7006 -p 7007:7007 --name redisserver grokzen/redis-cluster
abc      11989  2505  0 12:59 ?        00:00:00 gedit /var/www/html/php/10USD-Docker-Analogy/redis/docker-compose/docker-compose1ndcase/docker-compose.yml
root     13653 13637  0 13:35 pts/22   00:00:00 /bin/sh /docker-entrypoint.sh redis-cluster
root     13722 13719  0 13:35 ?        00:00:06 /redis/src/redis-server 0.0.0.0:7004 [cluster]
root     13723 13719  0 13:35 ?        00:00:06 /redis/src/redis-server 0.0.0.0:7003 [cluster]
root     13724 13719  0 13:35 ?        00:00:03 /redis/src/redis-server 0.0.0.0:7006
root     13725 13719  0 13:35 ?        00:00:06 /redis/src/redis-server 0.0.0.0:7005 [cluster]
root     13726 13719  0 13:35 ?        00:00:06 /redis/src/redis-server 0.0.0.0:7000 [cluster]
root     13727 13719  0 13:35 ?        00:00:06 /redis/src/redis-server 0.0.0.0:7002 [cluster]
root     13728 13719  0 13:35 ?        00:00:06 /redis/src/redis-server 0.0.0.0:7001 [cluster]
root     13729 13719  0 13:35 ?        00:00:03 /redis/src/redis-server 0.0.0.0:7007
root     13757 13653  0 13:36 pts/22   00:00:00 tail -f /var/log/supervisor/redis-1.log /var/log/supervisor/redis-2.log /var/log/supervisor/redis-3.log /var/log/supervisor/redis-4.log /var/log/supervisor/redis-5.log /var/log/supervisor/redis-6.log /var/log/supervisor/redis-7.log /var/log/supervisor/redis-8.log
abc      15151 15011  0 14:28 pts/23   00:00:00 grep --color=auto redis
```

#### 3. Making the nodes meet each other
```
$ redis-cli -c -p 7000 cluster meet 127.0.0.1 7001
OK
$ redis-cli -c -p 7000 cluster meet 127.0.0.1 7001
OK
$ redis-cli -c -p 7000 cluster meet 127.0.0.1 7003
OK
$ redis-cli -c -p 7000 cluster meet 127.0.0.1 7004
OK
$ redis-cli -c -p 7000 cluster meet 127.0.0.1 7005
OK
```

Now all the nodes have met each other. Execute "redis-cli -p 7000 cluster info" command to check the output. It should show the cluster_state as failed, and cluster_slots_assigned as 0.

```
$ redis-cli -c -p 7000 cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_sent:14557
cluster_stats_messages_received:14557
```

```
$ redis-cli -c -p 7001 cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:2
cluster_stats_messages_sent:14321
cluster_stats_messages_received:14321
```

```
$ redis-cli -c -p 7002 cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:3
cluster_stats_messages_sent:14359
cluster_stats_messages_received:14359
```

#### 4: Assign Slots to the nodes.

```
$ for slot in {0..5461}; do redis-cli -p 7000 CLUSTER ADDSLOTS $slot > /dev/null; done;
$ for slot in {5462..10923}; do redis-cli -p 7001 CLUSTER ADDSLOTS $slot > /dev/null; done;
$ for slot in {10924..16383}; do redis-cli -p 7002 CLUSTER ADDSLOTS $slot > /dev/null; done;
```

Each command may take some time, around a minute. Executing "cluster info" after it shows that cluster state is "ok" and cluster_slots_assigned are 16384.

```
$ redis-cli -p 7000 cluster nodes
86c3bc496cbe0c75f3530999bb4a1c7bde49cbe0 127.0.0.1:7005 slave 29a734fd790db093814773e12600f2c9eee2035b 0 1517475911695 6 connected
fc0e5a966f06b73f3b12ee7a964b697b26d5feac 127.0.0.1:7004 slave a9e429a1c67d1ef79894d39b9677dc01baa78900 0 1517475911194 5 connected
ec4af96fce158f77652b496351829d61b9244c5c 127.0.0.1:7003 slave 61977136fbf3009707c8b9d3fff058781fb5c47c 0 1517475910190 4 connected
a9e429a1c67d1ef79894d39b9677dc01baa78900 127.0.0.1:7001 master - 0 1517475910190 2 connected 5461-10922
61977136fbf3009707c8b9d3fff058781fb5c47c 172.17.0.2:7000 myself,master - 0 0 1 connected 0-5460
29a734fd790db093814773e12600f2c9eee2035b 172.17.0.2:7002 master - 0 1517475910693 3 connected 10923-16383
```

#### 5: Assign Slaves to masters.
Note that we had assigned slots to 7000, 7001, 7002, and plan to make the other nodes as their slaves. Slaves are assigned using **cluster replicate** command as described here. The syntax of the command is **redis-cli -c -p <port_of_slave> cluster replicate <node_id_of_its_master>** To find the node id of masters, we can use "cluster nodes" command and note the ids corresponding to ports 7000, 7001, 7002.

```
$ redis-cli -c -p 7003 cluster replicate 61977136fbf3009707c8b9d3fff058781fb5c47c
OK
$ redis-cli -c -p 7004 cluster replicate a9e429a1c67d1ef79894d39b9677dc01baa78900
OK
$ redis-cli -c -p 7005 cluster replicate 29a734fd790db093814773e12600f2c9eee2035b
OK
```
Congratulations, your cluster is up and running. Now, you can add some dummy data in it and start playing around with it.

```
redis-cli -c -p 7000 set mykey myvalue

redis-cli -c -p 7000 get mykey

for slot in {1..1000}; do redis-cli -c -h 127.0.0.1 -p 7002 set $no $no > /dev/null; done;

redis-cli -c -p 7000 dbsize

redis-cli -c -p 7002 dbsize
```

# PHP Redis Client
* [Installing Redis, Hiredis on Ubuntu 14.04](https://gist.github.com/palpalani/99787e2bca75262f2d73fa960cc7a1fb)
* How to run
  * chmod +x install_predis.sh
  * ./install_predis.sh
* Error:: The "phpiredis" extension is required by this connection backend.
  ```
  git clone https://github.com/nrk/phpiredis.git
  cd phpiredis
  phpize && ./configure --enable-phpiredis
  make && make install
  
  git clone https://github.com/nrk/phpiredis.git && \
         cd phpiredis && \
         phpize && \
         ./configure --enable-phpiredis && \
         make && \
         sudo make install
```
The client is configured correctly but check from the output of phpinfo() that phpiredis is indeed loaded by PHP at runtime, the only possible explanation is that you compiled phpredis but didn't configure PHP to load the extension.

The cluster logic is handled by Predis and not phpiredis which is used only to process the Redis protocol more efficiently.




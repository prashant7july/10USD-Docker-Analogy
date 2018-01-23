# Database images [LINK](https://github.com/pfwd/manning-docker-in-motion/tree/unit-6-website-1#pull-a-database-server-image)
## Database server images can be found on the Docker hub

You can either pull the Docker image or build it

Pull a database server image
```
$ docker pull howtocodewell/manning-database-01:<tag>
```

OR

Build the database container
```
$ cd code/mysql/
$ docker build -t mysql-server . 
```

Run the database container
```
$ docker run --name mysql -e MYSQL_ROOT_PASSWORD=<password> -d mysql-server
```

Rebuild the database

Log into the MYSQL container

$ docker exec -it mysql mysql -u root -p

Enter password

Run the rebuild script from within the container

mysql> source /schemas/rebuild.sql


# Other Example
## [LINK1](https://github.com/sameersbn/docker-mysql)
## [LINK2](https://www.toadworld.com/platforms/oracle/w/wiki/11645.using-mysql-database-with-docker-engine)

## Running the Docker Image
$ docker run -p 3306:3306 \
    --name mysql2 \
    -e MYSQL_ROOT_PASSWORD=b3RmELKOvCUrAdxIg0GEmugc3SY \
    -e MYSQL_ROOT_HOST=% \
    -d mysql/mysql-server:latest
```
Unable to find image 'mysql/mysql-server:latest' locally
latest: Pulling from mysql/mysql-server

4040fe120662: Pull complete 
d049aa45d358: Pull complete 
8804e1dda06d: Pull complete 
47202558e57c: Pull complete 
Digest: sha256:125a402f5b995d53a24d981c1111c8df624d4b49c51af6cf1fc2959dc449c8a7
Status: Downloaded newer image for mysql/mysql-server:latest
66ff9386311afd4e969d8cf6dabc6305e4236ca3a77980300d30c1cb1aded576
docker: Error response from daemon: driver failed programming external connectivity on endpoint mysql2 (212d9aedfb9f08da0eab3e870130ba5bbbb37156f86b3b93dd999309a6d4b366): Error starting userland proxy: listen tcp 0.0.0.0:3306: bind: address already in use.
```
## Question - Why?
Answer - Probably you have already a MySQL service running in port 3306. You should close it first.
```
$ sudo netstat -nlpt |grep 3306
```

## Again Running the Docker Image
$ docker run -p 3302:3306 \
    --name mysql2 \
    -e MYSQL_ROOT_PASSWORD=b3RmELKOvCUrAdxIg0GEmugc3SY \
    -e MYSQL_ROOT_HOST=% \
    -d mysql/mysql-server:latest
```
latest: Pulling from mysql/mysql-server

4040fe120662: Pull complete 
d049aa45d358: Pull complete 
8804e1dda06d: Pull complete 
47202558e57c: Pull complete 
Digest: sha256:125a402f5b995d53a24d981c1111c8df624d4b49c51af6cf1fc2959dc449c8a7
Status: Downloaded newer image for mysql/mysql-server:latest
8e86c638f2353762ea541d44d48d0e1162261794af816627dd17953d01048178
```

```
Host: localhost or 0.0.0.0
Port: 3302
User: root
Password: b3RmELKOvCUrAdxIg0GEmugc3SY
```

## Again Running the Docker Image
docker run -p 3306:3306 --name mysqlserver -e MYSQL_ROOT_PASSWORD=password -d mysql:latest

```
Sever / IP: 127.0.0.1
User : root
Port : 3306
Password : password
```

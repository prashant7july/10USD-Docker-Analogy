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
```
$ docker run -p 3306:3306 \
    --name mysql2 \
    -e MYSQL_ROOT_PASSWORD=b3RmELKOvCUrAdxIg0GEmugc3SY \
    -e MYSQL_ROOT_HOST=% \
    -d mysql/mysql-server:latest
```
## Output
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
### Question - Why?
### Answer
Probably you have already a MySQL service running in port 3306. You should close it first.
```
$ sudo netstat -nlpt |grep 3306
```

## Again Running the Docker Image
```
$ docker run -p 3302:3306 \
    --name mysql2 \
    -e MYSQL_ROOT_PASSWORD=b3RmELKOvCUrAdxIg0GEmugc3SY \
    -e MYSQL_ROOT_HOST=% \
    -d mysql/mysql-server:latest
```
## Ouptut
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

# Data Store

You should mount a volume at /var/lib/mysql.
```
$ docker run --name mysql2 -d \
  -v /opt/mysql/data:/var/lib/mysql \
  mysql:latest
```

This will make sure that the data stored in the database is not lost when the image is stopped and started again.

## Shell Access::Starting an Interactive Terminal
For debugging and maintenance purposes you may want access the containers shell. If you are using docker version 1.3.0 or higher you can access a running containers shell using docker exec command. As indicated in the Dockerfile for the "mysql" Docker image the image is based on the Docker image "debian", which implies that an interactive terminal may be run on the Docker container. Run the following command to start an interactive terminal on the mysql container.
``` 
[sudo] docker exec -it mysql2 bash
```

Alternatively, run the same command using the container id.
``` 
[sudo] docker exec –it 77fbe3dc4f6e bash
```

## Starting MySQL CLI
Start the MySQL command line interface (CLI) with the following command run in the bash shell.
``` 
mysql -u root -p
Enter password: b3RmELKOvCUrAdxIg0GEmugc3SY
```
## OR

## Shell Access::MySQL CLI
```
$ docker exec -it mysql2 mysql -u root -p
Enter password: b3RmELKOvCUrAdxIg0GEmugc3SY
```

## Setting the Database
Before any command may be run in the MySQL CLI a database must be set as the current database. List the databases with the following command.
```
mysql> show databases;
```

In addition to the system, information and performance databases, a user database “mysql” also gets listed.

Set the current database as the “mysql” database.
```
mysql> use mysql;
```

## Import Data
```
mysql -u root -p wishfin-2nd < /home/mywish/Downloads/zend_20161207.sql
```

## Useful Docker commands
Used to show all docker's containers by its created column
```
$ docker ps -a | grep "weeks ago" | awk '{print $1}'
```

Showing all containers that matches with Exited Status
```
$ docker ps -a | grep "Exited" | awk '{print $4}'
```
Note that the bash {print $1} is matched with Status Column

Removing all Exited containers
```
$ docker rm ${docker ps -a | grep "Exited" | awk '{print $1}'}
```
Printing all containers ids
```
$ docker ps -qa
```

Removing all containers
```
$ docker rm $(docker ps -qa)
```
Note that if container is running, we can't do that. We got the following message: Conflict, You cannot remove a running container.

Removing all containers ignoring its status and ignoring the error mentioned above
```
$ docker rm --force $(docker ps -qa)
```

# Load the SQL dump
```
docker exec -i dump mysql -uroot -proot < dump.sql
```
Note that the -i option allows to use input redirection from the host right into the docker container.

# Creating database dumps
Most of the normal tools will work, although their usage might be a little convoluted in some cases to ensure they have access to the mysqld server. A simple way to ensure this is to use docker exec and run the tool from the same container, similar to the following:
```
$ docker exec mysql2 sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```

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
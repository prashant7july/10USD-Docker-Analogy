# Docker Setups

Go into the folder you want, and run `docker-compose up`. 

## Quick Install (Linux)

On Linux Ubuntu, remove old Docker if it exists:
```
sudo apt-get remove docker docker-engine docker.io
```

Install new Docker (GPG Key, Server x64)

```#
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

## Docker Commands

> These apply to `docker` globally.  `docker-compose` has similar commands but it is not system-wide.

Rather than type these all out, I'll provide a few useful ones. If you ever need help with a command type it out and trail it with the help flag: `docker <cmd> --help`

| Command         | Description/Example                      | Notes                                    |
| --------------- | ---------------------------------------- | ---------------------------------------- |
| `docker ps`     | See running containers                   |                                          |
| `docker ps -a`  | See  all containers                      |                                          |
| `docker images` | See all images                           | This is what your Containers are based off, one per many containers. |
| `docker exec`   | Run a command on a container             | `-i interactive`, `-t psuedo TTY`        |
|                 | **Login:** `docker exec -it <container> /bin/bash` | If `/bash` doesn't work use `/sh`        |
|                 | **Get Output:** `docker exec -it <container> ls -lta` |                                          |
| `docker rm`     | Remove Container(s) by ID or NAME.       | Use `docker ps -a` for a list.           |
|                 | `docker rm django_app`                   | `-f force`                               |
|                 | `docker rm 02bfg -f`                     | The full ID isn't required, ensure you don't remove something else though. |
|                 | `docker rm container1 container2`        |                                          |
| `docker rmi`    | Remove Image(s) by REPOSITORY, REPOSITORY:TAG, or IMAGE_ID | Use `docker images` for a list. This will remove any containers reliant on such image removed, which requires you to force with `-f`. |
|                 | `docker rmi django_app -f`               |                                          |
|                 | `docker rmi postgres:latest`             |                                          |
|                 | `docker rmi 224b7eef6944 image_name`     |                                          |

For a list of all commands run `docker`.

## Docker Compose Commands

> **Must Know**: The primary difference between `docker` and `docker-compose` commands is that `docker-compose` is isolated to your current working folder only, where `docker` applies globally to everything. 

These are `docker-compose` commands which require you to be in the same path as your `docker-compose.yml` file. These are ordered by what I think you would use from top to bottom.

| Command                    | Description                              | Notes                   |
| -------------------------- | ---------------------------------------- | ----------------------- |
| `docker-compose up`        | Create and start containers              |                         |
| `docker-compose ps`        | List running containers (all)            |                         |
| `docker-compose port`      | List the public ports for containers (all) |                         |
| `docker-compose stop`      | Stop running containers (all)            |                         |
| `docker-compose kill`      | Kill containers (all)                    |                         |
| `docker-compose rm`        | Remove stopped containers (all)          |                         |
| `docker-compose down`      | Stop and Remove everything to do with this setup. (Good for restarting) |                         |
| `docker-compose restart`   | Restart containers (all)                 |                         |
| `docker-compose run <cmd>` | Run a command within a container (single) (Same as `docker exec`) | Used to setup `django/` |

For a list of all commands type `docker-compose`.
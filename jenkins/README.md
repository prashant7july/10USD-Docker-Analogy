# Install Jenkins
#### Create shell.sh file

```
docker search jenkins
docker pull jenkins
docker run --name jenkins -d -p 49001:8080 -v $PWD/jenkins:/var/jenkins_home -t jenkins
```
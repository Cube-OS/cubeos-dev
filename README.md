# cubeos-dev

## Create docker image from dockerfile
`git clone git@github.com:Cube-OS/cubeos-dev.git` 

`cd cubeos-dev`

`docker build -t cubeos-dev ./`

## Run Docker
`docker run -it -v "$PWD":/usr/cubeos/ -w /usr/cubeos/ cubeos-dev bash`

## to access a running Docker
`docker ps`

`docker exec -it <container name> /bin/bash`

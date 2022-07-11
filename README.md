# cubeos-dev

Use the following commands to install the SDK for Cube-OS.

The SDK allows the user to compile services and apps with the latest Rust version and toolchains, 
and allows cross-compilation for the ISIS iOBC and BeagleBone Black. 

(Cross-compile toolchain for RPIs will be added in the future)

## Create docker image from dockerfile
`git clone git@github.com:Cube-OS/cubeos-dev.git` 

`cd cubeos-dev`

`docker build -t cubeos-dev ./`

## Run Docker
`docker run -it -v "$PWD":/usr/cubeos/ -w /usr/cubeos/ cubeos-dev bash`

## to access a running Docker
`docker ps`

`docker exec -it <container name> /bin/bash`

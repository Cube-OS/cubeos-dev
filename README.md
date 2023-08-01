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

### Use with ssh-authentication
#### MacOS
`docker run -it -v "$PWD":/usr/cubeos -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock:ro -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" -w /usr/cubeos cubeos-dev bash`

#### WSL
`docker run -it -v "$PWD":/usr/cubeos/ -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -w /usr/cubeos cubeos-dev bash`

## to access a running Docker
`docker ps`

`docker exec -it <container name> /bin/bash`

## IMPORTANT
add the targets to your .cargo/config file in your $HOME directory
```
[target.armv5te-unknown-linux-gnueabi]
linker = "/usr/bin/iobc_toolchain/usr/bin/arm-linux-gcc"

[target.arm-unknown-linux-gnueabihf]
linker = "/usr/bin/bbb_toolchain/usr/bin/arm-linux-gcc"
```

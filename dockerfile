FROM ubuntu:18.04

RUN sed -E -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#g' /etc/apt/sources.list
RUN echo "Ubuntu Update and dependency install"

# Tell apt-get we're never going to be able to give manual
# feedback:
RUN export DEBIAN_FRONTEND=noninteractive

# Update the package listing, so we know what package exist:
RUN apt-get update --fix-missing

# Install security updates:
RUN apt-get -y upgrade

# Install a new package, without unnecessary recommended packages:
RUN apt-get install --no-install-recommends -f -y pkg-config build-essential git cmake unzip wget sqlite3 libsqlite3-dev libssl-dev curl git ssh 
RUN apt-get install --no-install-recommends -f -y bc cpio ncurses-dev libc6-i386 lib32stdc++6 lib32z1
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -f -y doxygen graphviz plantuml file rsync python3.10

# Delete cached files we don't need anymore:
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

#Kubos Linux setup
RUN echo "Installing Kubos Linux Toolchain"
RUN wget https://github.com/Cube-OS/toolchains/releases/download/0.1/iobc-toolchain-0.1.tar.gz -O ./iobc_toolchain.tar.gz && mkdir /usr/bin/iobc_toolchain && tar -xf ./iobc_toolchain.tar.gz --strip 1 -C /usr/bin/iobc_toolchain && rm ./iobc_toolchain.tar.gz
RUN wget https://github.com/Cube-OS/toolchains/releases/download/0.1/bbb-toolchain-0.1.tar.gz -O ./bbb_toolchain.tar.gz && mkdir /usr/bin/bbb_toolchain && tar -xf ./bbb_toolchain.tar.gz --strip 1 -C /usr/bin/bbb_toolchain && rm ./bbb_toolchain.tar.gz

# Setup rust stuff
ENV PATH "$PATH:/root/.cargo/bin"

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.61.0 -t armv5te-unknown-linux-gnueabi arm-unknown-linux-gnueabihf -c clippy rustfmt && rustup toolchain uninstall stable-x86_64-unknown-linux-gnu

RUN cargo install --git https://github.com/kubos/cargo-kubos
COPY cargo_config /root/.cargo/config
ENV PATH "$PATH:/usr/bin/iobc_toolchain/usr/bin:/usr/bin/bbb_toolchain/usr/bin"

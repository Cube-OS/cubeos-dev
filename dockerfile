# syntax=docker/dockerfile:experimental
# cuava/kubos-dev:1.17.1
FROM ubuntu:20.04

RUN sed -E -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#g' /etc/apt/sources.list
RUN echo "Ubuntu Update and dependency install"
# COPY install-packages.sh .
# RUN sudo ./install-packages.sh

# RUN set -euo pipefail

# Tell apt-get we're never going to be able to give manual
# feedback:
RUN export DEBIAN_FRONTEND=noninteractive

# Update the package listing, so we know what package exist:
RUN apt-get update

# Install security updates:
RUN apt-get -y upgrade

RUN export DEBIAN_FRONTEND=noninteractive
# Install a new package, without unnecessary recommended packages:
RUN apt-get install --no-install-recommends -y pkg-config build-essential git cmake unzip wget sqlite3 libsqlite3-dev libssl-dev curl git ssh 
RUN apt-get install --no-install-recommends -y bc cpio ncurses-dev libc6-i386 lib32stdc++6 lib32z1
RUN apt-get install --no-install-recommends -y doxygen graphviz plantuml

# Delete cached files we don't need anymore:
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

#Kubos Linux setup
RUN echo "Installing Kubos Linux Toolchain"
RUN wget https://s3.amazonaws.com/kubos-world-readable-assets/iobc_toolchain.tar.gz && tar -xf ./iobc_toolchain.tar.gz -C /usr/bin && rm ./iobc_toolchain.tar.gz
RUN wget https://s3.amazonaws.com/kubos-world-readable-assets/bbb_toolchain.tar.gz && tar -xf ./bbb_toolchain.tar.gz -C /usr/bin && rm ./bbb_toolchain.tar.gz

# Setup rust stuff
ENV PATH "$PATH:/root/.cargo/bin"

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.55.0 -t armv5te-unknown-linux-gnueabi arm-unknown-linux-gnueabihf -c clippy rustfmt && rustup toolchain uninstall stable-x86_64-unknown-linux-gnu
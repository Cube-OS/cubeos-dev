FROM ubuntu:18.04

# Update sources.list to use mirror:
RUN sed -E -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#g' /etc/apt/sources.list
RUN echo "Ubuntu Update and dependency install"

# Set noninteractive mode for apt-get:
RUN export DEBIAN_FRONTEND=noninteractive

# Update the package listing:
RUN apt-get update --fix-missing

# Install security updates:
RUN apt-get -y upgrade

# Install required packages:
RUN TZ=Australia/Sydney && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get install --no-install-recommends -f -y \
    pkg-config build-essential git cmake unzip wget sqlite3 libsqlite3-dev \
    libssl-dev curl git ssh bc cpio ncurses-dev doxygen graphviz plantuml file rsync python3.10
    

# Install 32-bit libraries for non-64-bit architectures:
RUN ARCH=$(dpkg --print-architecture) && \
if [ "${ARCH}" = "amd64" ] || [ "${ARCH}" = "x86_64" ]; then \
    apt-get install --no-install-recommends -f -y \
        libc6-i386 lib32stdc++6 lib32z1; \
fi

# Delete cached files we don't need anymore:
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Kubos Linux Toolchain:
RUN echo "Installing Kubos Linux Toolchain" && \
    wget https://github.com/Cube-OS/toolchains/releases/download/0.1/iobc-toolchain-0.1.tar.gz -O ./iobc_toolchain.tar.gz && \
    mkdir /usr/bin/iobc_toolchain && \
    tar -xf ./iobc_toolchain.tar.gz --strip 1 -C /usr/bin/iobc_toolchain && \
    rm ./iobc_toolchain.tar.gz && \
    wget https://github.com/Cube-OS/toolchains/releases/download/0.1/bbb-toolchain-0.1.tar.gz -O ./bbb_toolchain.tar.gz && \
    mkdir /usr/bin/bbb_toolchain && \
    tar -xf ./bbb_toolchain.tar.gz --strip 1 -C /usr/bin/bbb_toolchain && \
    rm ./bbb_toolchain.tar.gz

# Setup Rust environment:
ENV PATH "$PATH:/root/.cargo/bin"

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.76.0 -t armv5te-unknown-linux-gnueabi arm-unknown-linux-gnueabihf -c clippy rustfmt && \
    rustup toolchain uninstall stable-x86_64-unknown-linux-gnu

RUN cargo install --git https://github.com/kubos/cargo-kubos

# Set path to toolchain binaries:
ENV PATH "$PATH:/usr/bin/iobc_toolchain/usr/bin:/usr/bin/bbb_toolchain/usr/bin"

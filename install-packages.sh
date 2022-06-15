sh "strict mode", to help catch problems and bugs in the shell
# script. Every bash script you write should include this. See
# http://redsymbol.net/articles/unofficial-bash-strict-mode/ for
# details.
set -euo pipefail

# Tell apt-get we're never going to be able to give manual
# feedback:
export DEBIAN_FRONTEND=noninteractive

# Update the package listing, so we know what package exist:
apt-get update --fix-missing

# Install security updates:
apt-get -y upgrade

# Install a new package, without unnecessary recommended packages:
apt-get install --no-install-recommends -f -y pkg-config build-essential git cmake unzip wget sqlite3 libsqlite3-dev libssl-dev curl git ssh 
apt-get install --no-install-recommends -f -y bc cpio ncurses-dev libc6-i386 lib32stdc++6 lib32z1
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -f -y doxygen graphviz plantuml python3.10

# Delete cached files we don't need anymore:
apt-get clean
rm -rf /var/lib/apt/lists/*

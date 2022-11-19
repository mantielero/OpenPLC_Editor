#! /bin/bash

set -e

if [[ "$ARCH" == "" ]]; then
    echo "Usage: env ARCH=... bash $0"
    exit 2
fi

if [[ "$CI" == "" ]]; then
    echo "Caution: this script is supposed to run inside a (disposable) CI environment"
    echo "It will alter a system, and should not be run on workstations or alike"
    echo "You can export CI=1 to prevent this error from being shown again"
    exit 3
fi

case "$ARCH" in
    x86_64)
        ;;
    *)
        echo "Error: unsupported architecture: $ARCH"
        exit 4
        ;;
esac

case "$DIST" in
    xenial|bionic)
        ;;
    *)
        echo "Error: unsupported distribution: $DIST"
        exit 5
        ;;
esac

set -x

packages=(
    curl 
    build-essential 
    pkg-config 
    bison 
    flex 
    autoconf 
    automake 
    libtool 
    make 
    git 
    libssl-dev 
    python2 
    python-wxgtk3.0 
    libssl-dev 
    libxml2-dev
    libxslt1-dev 
    python2-dev 
    'libpng*' 
    libfreetype6-dev 
)

apt-get update
apt-get -y --no-install-recommends install "${packages[@]}"

# Including pip for python2.7
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py

sudo pip install virtualenv  
virtualenv -p python2 usr
source usr/bin/activate
pip install future zeroconf==0.19.1 numpy==1.16.5 matplotlib==2.0.2 lxml==4.6.2 pyro sslpsk pyserial
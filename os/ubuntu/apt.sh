#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

unset UCF_FORCE_CONFFOLD
export UCF_FORCE_CONFFNEW=YES
sudo ucf --purge /boot/grub/menu.lst

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -fuy --force-yes -o Dpkg::Options::="--force-confnew" upgrade

sudo apt-get -y install \
acpid \
ant \
atop \
autoconf \
automake \
bison \
build-essential \
cmake \
cowsay \
curl \
dnsutils \
docker \
expect \
fortune \
g++ \
gcc \
gettext \
gfortran \
git-core \
jq \
libtool \
lsof \
make \
man-db \
maven \
ntp \
numactl \
openjdk-8-jdk \
pigz \
pkg-config \
psmisc \
python-dev \
rsync \
ssh \
strace \
swig \
tmux \
unzip \
vim \
emacs \
wamerican \
wget \
xzdec \
xz-utils \
zip \
\
libatlas-base-dev \
libbz2-dev \
libcairo2-dev \
libcurl4-openssl-dev \
libevent-dev \
libffi-dev \
libfreetype6-dev \
libicu-dev \
libjpeg-dev \
libncurses5-dev \
libpcap-dev \
libpcre3-dev \
libperl-dev \
libpng-dev \
libreadline-dev \
libreadline7 \
libssl-dev \
libsqlite3-dev \
libuuid1 \
libwebp-dev \
libxml2-dev \
uuid-dev \
zlib1g-dev

sudo locale-gen en_US.UTF-8

sudo update-java-alternatives --set java-1.8.0-openjdk-amd64

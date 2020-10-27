#!/bin/bash

BREW="$(which brew)"

sudo xcodebuild -license accept || true
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer || true

$BREW update
$BREW upgrade

$BREW install \
autoconf \
automake \
bison \
bzip2 \
cairo \
cmake \
coreutils \
cowsay \
curl \
expat \
file-formula \
findutils \
fortune \
freetype \
gawk \
gcc \
gdbm \
gettext \
git \
gnu-sed \
gnu-tar \
gzip \
icu4c \
jq \
libevent \
libffi \
libjpeg \
libmagic \
libpcap \
libpng \
libtool \
libxml2 \
make \
maven \
ncurses \
openssl \
ossp-uuid \
pcre \
pixman \
pkgconfig \
readline \
rsync \
sqlite \
swig \
tmux \
vim \
webp \
wget \
xz \
zlib

if [ ! -e /Applications/Docker.app ]; then
    $BREW cask install docker
fi

# test automation stuff
# $BREW install --HEAD libimobiledevice

$BREW install \
carthage \
ideviceinstaller \
ios-deploy

# clang doesn't like arguments it doesn't use
export CFLAGS="-Qunused-arguments $CFLAGS"

export CPPFLAGS="$CPPFLAGS -I/usr/local/include"
export LDFLAGS="$LDFLAGS -L/usr/local/lib"

# brew keg only...
# brew info --json=v1 --installed | jq "map(select(.keg_only == true) | .name)"
for pkg in bison bzip2 expat icu4c libffi ncurses openssl readline sqlite zlib; do
export PATH="/usr/local/opt/$pkg/bin:$PATH"
export LDFLAGS="$LDFLAGS -L/usr/local/opt/$pkg/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/$pkg/include"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/opt/$pkg/lib/pkgconfig"
done

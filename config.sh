#!/bin/bash -xv

USER=$(id -un)
GROUP=$(id -gn)

if [ "$USER" == "root" ]; then
echo 'Do not run as root, we modifiy your local environment...'
exit 1
fi

ARCH="$(uname -m | sed -e 's/i686/i386/g')"
MARCH="$(uname -m)"

if [ "$(uname)" == "Darwin" ];then
    OS="OSX_10.X"
    MOS="OSX"
    PROCS="$(sysctl -n hw.ncpu)"
elif [ "$(lsb_release -si)" == "Ubuntu" ]; then
    OS="Ubuntu_$ver"
    MOS="Ubuntu"
    PROCS=$(grep -c '^processor' /proc/cpuinfo)
fi

function getpkg() {
    URL=$1
    DST=$2
    if [ "$DST" == "" ]; then
        DST=$BUILD_DIR
    fi

    FILENAME=$(basename "$URL")

    mkdir -p $PKG_CACHE

    if [ ! -f "$PKG_CACHE/$FILENAME" ]; then
        curl -s -L --retry 2 --retry-delay 10 -o "$PKG_CACHE/$FILENAME" $URL
    fi
    cp "$PKG_CACHE/$FILENAME" $DST
}

# might want to override these in config_local.sh
DATA_DIR=/data
LOG_DIR="$DATA_DIR/log"
RUN_DIR="$DATA_DIR/run"

pushd $(dirname $0) > /dev/null
SCRIPTPATH="$(pwd)"
popd > /dev/null

# customize here
source $SCRIPTPATH/config_local.sh

export PATH="$VENV/bin:$PATH"
export CFLAGS=""
export CPPFLAGS="-I$VENV/include"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-L. -L$VENV/lib"
export LD_LIBRARY_PATH="$VENV/lib"
export PKG_CONFIG_PATH="$VENV/lib/pkgconfig"

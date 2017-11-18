#!/bin/bash -xv

set -e

pushd $(dirname $0) > /dev/null
SCRIPTPATH="$(pwd)"
popd > /dev/null

source $SCRIPTPATH/config.sh

if [ "$MOS" == "OSX" ]; then

    # TODO: RET-1466: Replace fink with brew in ave
    # RET-943: disabling fink!
    # source $SCRIPTPATH/os/osx/fink.sh

    # install homebrew
    if [ ! -e /usr/local/bin/brew ]; then
        echo "homebrew not found, installing homebrew"
        # install homebrew using macOS system ruby
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # put our own cafile in place
    sudo cp $VENV/lib/python2.7/site-packages/certifi/cacert.pem $($VENV/bin/python -c 'import ssl;print ssl.get_default_verify_paths().openssl_cafile')

elif [ "$MOS" == "Ubuntu" ]; then

    source $SCRIPTPATH/os/ubuntu/apt.sh

    sudo bash -c "echo $VENV/lib > /etc/ld.so.conf.d/venv.conf"
    sudo ldconfig

elif [ "$MOS" == "Arch" ]; then

    source $SCRIPTPATH/os/arch/pacman.sh

    sudo bash -c "echo $VENV/lib > /etc/ld.so.conf.d/venv.conf"
    sudo ldconfig

else
    echo "Error -- unsupported platform"
    exit 1
fi

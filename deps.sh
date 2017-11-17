#!/bin/bash -xv

set -e

pushd $(dirname $0) > /dev/null
SCRIPTPATH="$(pwd)"
popd > /dev/null

source $SCRIPTPATH/config.sh

if [ "$MOS" == "OSX" ]; then

    # disabling fink!
    # some problems with sierra + general unhappiness with slowness/flakiness
    # stand by as we migrate away
    # source $SCRIPTPATH/os/osx/fink.sh

    # install some qa dependencies, see RET-1466
    if [ ! -e /usr/local/bin/brew ]; then
        echo "homebrew not found, installing homebrew"
        # install homebrew using macOS system ruby
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    BREW="/usr/local/bin/brew"
    # ideviceinstaller only works for ios 9. for ios 10, carthage is installed below
    $BREW uninstall --force ideviceinstaller &> /dev/null || true
    $BREW install ideviceinstaller
    # install ios-deploy using brew, not npm
    $BREW uninstall --force ios-deploy &> /dev/null || true
    $BREW install ios-deploy
    # install from HEAD to get important updates
    $BREW uninstall --force libimobiledevice &> /dev/null || true
    $BREW install libimobiledevice
    # install carthage
    $BREW uninstall --force carthage &> /dev/null || true
    $BREW install carthage

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

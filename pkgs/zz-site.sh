# This is the second-last package built -- add your dependencies here,
# python/ruby/node pkgs, etc.

gem install sass --version "=3.4.19"
npm install -g grunt-cli

if [ "$MOS" == "Ubuntu" ]; then
sudo apt-get -y install fortune cowsay
elif [ "$MOS" == "Arch" ]; then
sudo pacman --sync --needed --noconfirm fortune-mod cowsay
fi

getpkg http://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/3.2.1/flyway-commandline-3.2.1.tar.gz
tar zxf flyway-commandline-3.2.1.tar.gz
rm -rf $VENV/flyway
mv flyway-3.2.1 $VENV/flyway
chmod 755 $VENV/flyway/flyway

ANDROID_SDK_VERSION="r24.4.1"
rm -rf $VENV/android-sdk
if [ "$MOS" == "OSX" ]; then
getpkg http://dl.google.com/android/android-sdk_${ANDROID_SDK_VERSION}-macosx.zip
unzip android-sdk_${ANDROID_SDK_VERSION}-macosx.zip
mv android-sdk-macosx $VENV/android-sdk
else
getpkg http://dl.google.com/android/android-sdk_${ANDROID_SDK_VERSION}-linux.tgz
tar zxvf android-sdk_${ANDROID_SDK_VERSION}-linux.tgz
mv android-sdk-linux $VENV/android-sdk

if [ "$MOS" == "Ubuntu" ]; then
sudo apt-get -y install libc6-i386 lib32z1 lib32gcc1
elif [ "$MOS" == "Arch" ]; then
echo "FIXME - arch i386 libs for android?"
fi

fi

for pkg in platform-tools build-tools-23.0.3 android-19 android-22 android-23 sys-img-armeabi-v7a-android-19 sys-img-armeabi-v7a-android-22 extra-android-m2repository extra-google-m2repository extra-google-google_play_services; do
$VENV/android-sdk/tools/android update sdk --no-ui --all --filter "$pkg" <<EOF
y
EOF
done

cat > $VENV/android-sdk/tools/android-wait-for-emulator <<EOF
#!/bin/bash

# Originally written by Ralf Kistner <ralf@embarkmobile.com>, but placed in the public domain

set +e

bootanim=""
failcounter=0
timeout_in_sec=360

until [[ "\$bootanim" =~ "stopped" ]]; do
  bootanim="\$($VENV/android-sdk/platform-tools/adb -e shell getprop init.svc.bootanim 2>&1)"
  if [[ "\$bootanim" =~ "device not found" || "\$bootanim" =~ "device offline"
    || "\$bootanim" =~ "running" || "\$bootanim" =~ "error" ]]; then
    let "failcounter += 1"
    echo "Waiting for emulator to start \$failcounter"
    if [[ \$failcounter -gt timeout_in_sec ]]; then
      echo "Timeout (\$timeout_in_sec seconds) reached; failed to start emulator"
      exit 1
    fi
  fi
  sleep 1
done

echo "Emulator is ready"
EOF
chmod 755 $VENV/android-sdk/tools/android-wait-for-emulator
# Handle macOS by echoing a ":" if find returns nothing, as xargs does not handle
# no results on macOS.  The risk is if there is a file named : in the local
# directory from which this script is run, it will be affected by the chmod.
# http://stackoverflow.com/questions/17402345/ignore-empty-results-for-xargs-in-mac-os-x
if [ "$MOS" == "OSX" ]; then
    (find $VENV/android-sdk/tools -maxdepth 1 -type f -perm 744 || echo :) | xargs chmod 755
else
    find $VENV/android-sdk/tools -maxdepth 1 -type f -perm 744 | xargs -r chmod 755
fi    

cd $BUILD_DIR
mkdir klassmaster
cd klassmaster
RSYNC_PASSWORD="fdc30617-6818-47fb-bb81-245c73777dda" \
rsync -av --progress $RSYNC_USER@$RSYNC_HOST:$RSYNC_PATH/KlassMaster.zip .
unzip KlassMaster.zip
rm KlassMaster.zip
cd $BUILD_DIR
rm -rf $VENV/klassmaster
mv klassmaster $VENV

# iOS SDK build tools
if [ "$MOS" == "OSX" ]; then
cd $BUILD_DIR
git clone https://github.com/tomaz/appledoc.git
cd appledoc
mkdir -p $VENV/share/appledoc
./install-appledoc.sh -b $VENV/bin -t $VENV/share/appledoc
cd $BUILD_DIR

gem install cocoapods
gem install jazzy
fi

cd $BUILD_DIR
PROTOBUF_VERSION="2.6.1"
getpkg https://github.com/google/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-${PROTOBUF_VERSION}.tar.gz
tar zxf protobuf-${PROTOBUF_VERSION}.tar.gz
cd protobuf-${PROTOBUF_VERSION}
./configure --prefix=$VENV
$PMAKE install
$VENV/bin/pip install protobuf

# pkgs for dealing with tweak debian repos
$VENV/bin/pip install chardet python-debian

# reviewboard tools
$VENV/bin/pip install git+https://github.com/mattbillenstein/rbtools.git

cd $BUILD_DIR
# pypy pkgs
$VENV/pypy/bin/pip install protobuf pynsq google-api-python-client

# azure tooling
npm install -g azure-cli
$VENV/bin/pip install --pre azure

# yarn
npm install -g yarn

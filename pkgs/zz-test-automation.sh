# test automation tooling
if [ "$MOS" == "OSX" ]; then
    getpkg https://chromedriver.storage.googleapis.com/2.33/chromedriver_mac64.zip
    unzip chromedriver_mac64.zip
    mv chromedriver $VENV/bin/
else
    getpkg https://chromedriver.storage.googleapis.com/2.33/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip
    mv chromedriver $VENV/bin/
fi

# brew requirements
BREW="/usr/local/bin/brew"
# Uninstall all old versions to make sure our new versions install cleanly
# because they might be interdependent
$BREW uninstall --force ideviceinstaller &> /dev/null || true
$BREW uninstall --force ios-deploy &> /dev/null || true
$BREW uninstall --force libimobiledevice &> /dev/null || true
$BREW uninstall --force carthage &> /dev/null || true
# NOTE: Homebrew doesn't let you install specific versions
# install carthage
$BREW install carthage
# install from HEAD to get important updates
$BREW install --HEAD libimobiledevice
# clean up any previous idevice* binaries
rm $VENV/bin/idevice* &> /dev/null || true
# ideviceinstaller only works for ios 9. for ios 10+, we use carthage
$BREW install ideviceinstaller
# install ios-deploy using brew, not npm
$BREW install ios-deploy

# prevent libimobiledevice errors
sudo chmod -R 777 /var/db/lockdown

# appium requirements
$VENV/bin/npm uninstall -g appium
$VENV/bin/npm install -g appium@1.7.1  # this does not install cleanly on arch...
if [ "$MOS" == "OSX" ]; then
    $VENV/bin/npm uninstall -g authorize-ios
    $VENV/bin/npm install -g authorize-ios@1.0.5
    $VENV/bin/gem install xcpretty
fi

# pip install packages for automation support
$VENV/bin/pip install Appium-Python-Client
$VENV/bin/pip install enum34
$VENV/bin/pip install py
$VENV/bin/pip install pytest
$VENV/bin/pip install selenium
$VENV/bin/pip install subprocess32
$VENV/bin/pip install pytest-rerunfailures

# sym-link iproxy since it's the incorrect version
if [ "$MOS" == "OSX" ]; then
    sudo mv /sw/bin/iproxy /sw/bin/iproxy_old
    sudo ln -s /ave/bin/iproxy /sw/bin/iproxy
fi

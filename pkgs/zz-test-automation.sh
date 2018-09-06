# test automation tooling
if [ "$MOS" == "OSX" ]; then
    getpkg https://chromedriver.storage.googleapis.com/2.40/chromedriver_mac64.zip
    unzip chromedriver_mac64.zip
    mv chromedriver $VENV/bin/
else
    getpkg https://chromedriver.storage.googleapis.com/2.40/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip
    mv chromedriver $VENV/bin/
fi

if [ "$MOS" == "OSX" ]; then
    # prevent libimobiledevice errors
    sudo chmod -R 777 /var/db/lockdown
fi

# appium requirements
$VENV/bin/npm uninstall -g appium
$VENV/bin/npm install -g appium@1.8.1  # this does not install cleanly on arch...
if [ "$MOS" == "OSX" ]; then
    $VENV/bin/npm uninstall -g authorize-ios
    $VENV/bin/npm install -g authorize-ios@1.0.5
    $VENV/bin/gem install xcpretty --version 0.2.8
fi

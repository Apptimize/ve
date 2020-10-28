# test automation tooling
if [ "$MOS" == "OSX" ]; then
    getpkg https://chromedriver.storage.googleapis.com/2.42/chromedriver_mac64.zip
    unzip chromedriver_mac64.zip
    mv chromedriver $VENV/bin/
else
    getpkg https://chromedriver.storage.googleapis.com/2.42/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip
    mv chromedriver $VENV/bin/
fi

# Override URL beacause maven no longer allowes HTTP URLs.
# See custom binaries section @ https://github.com/appium-boneyard/appium-selendroid-driver
export SELENDROID_DRIVER_CDNURL=https://repo2.maven.org/maven2/io/selendroid/selendroid-standalone

# appium requirements
$VENV/bin/npm uninstall -g appium
$VENV/bin/npm install -g appium@1.9.1
if [ "$MOS" == "OSX" ]; then
    $VENV/bin/npm uninstall -g authorize-ios
    $VENV/bin/npm install -g authorize-ios@1.0.5
    $VENV/bin/gem install xcpretty --version 0.2.8
fi

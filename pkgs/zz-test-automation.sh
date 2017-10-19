# test automation tooling

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

# sym-link to chromedriver
if [ "$MOS" == "OSX" ]; then
    sudo ln -sf $VENV/lib/node_modules/appium/node_modules/appium-chromedriver/chromedriver/mac/chromedriver $VENV/bin/chromedriver
else
    sudo ln -sf $VENV/lib/node_modules/appium/node_modules/appium-chromedriver/chromedriver/linux/chromedriver $VENV/bin/chromedriver_64
fi

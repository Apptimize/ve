PYTHON_VERSION="3.6.3"

getpkg http://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
tar zxf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}
./configure --prefix=$VENV --enable-shared --with-system-expat # --enable-optimizations
make
make install

cd $BUILD_DIR

$VENV/bin/pip3 install -r ${SCRIPTPATH}/pkgs/python3-requirements.txt --src $BUILD_DIR

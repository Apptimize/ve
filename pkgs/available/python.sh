PYTHON_VERSION="2.7.14"

getpkg http://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
tar zxf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}
./configure --prefix=$VENV --enable-shared --with-system-expat --enable-unicode=ucs4 --enable-optimizaations
$PMAKE
make install

cd $BUILD_DIR

getpkg https://bootstrap.pypa.io/get-pip.py
$VENV/bin/python ./get-pip.py

PIP_OPTS="--src $VENV/src" # --no-clean"

$VENV/bin/pip install $PIP_OPTS -r ${SCRIPTPATH}/pkgs/python-requirements.txt

$VENV/bin/python -m compileall -q -f $VENV || true

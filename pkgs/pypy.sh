PYPY_VERSION="v7.3.2"
PYPY_ARCH="linux64"

rm -fR $VENV/opt/pypy
mkdir -p $VENV/opt

if [ "$MOS" == "OSX" ]; then
PYPY_ARCH="osx64"
fi

getpkg https://downloads.python.org/pypy/pypy2.7-${PYPY_VERSION}-${PYPY_ARCH}.tar.bz2
tar jxf pypy2.7-${PYPY_VERSION}-${PYPY_ARCH}.tar.bz2
mv pypy2.7-${PYPY_VERSION}-${PYPY_ARCH} $VENV/opt/pypy

cd $BUILD_DIR
getpkg https://bootstrap.pypa.io/get-pip.py
$VENV/opt/pypy/bin/pypy ./get-pip.py

$VENV/opt/pypy/bin/pip install -r ${SCRIPTPATH}/pkgs/pypy-requirements.txt --src $BUILD_DIR

NODEJS_VERSION="6.14.3"

getpkg https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}.tar.gz
tar zxf node-v${NODEJS_VERSION}.tar.gz
cd node-v${NODEJS_VERSION}/
# Patch to use libc++ instead of libstdc++ (removed in latest Xcode)
# Details: https://github.com/nodejs/node/issues/24648
if [ "$MOS" == "OSX" ]; then
# Insert CXX library override at line 403
ex common.gypi <<EOF
403 insert
"CLANG_CXX_LIBRARY":"libc++"
.
xit
EOF
# Xcode default is now C++11 in libc++, delete line 17 with define macro.
sed -i -e '17d' src/util.h
fi
./configure --prefix=$VENV
make install

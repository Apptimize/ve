getpkg https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar zxf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}
./config --prefix=$VENV
make depend
make install
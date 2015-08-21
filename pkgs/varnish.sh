VARNISH_VERSION="3.0.7"

rm -fR varnish-${VARNISH_VERSION}*
getpkg https://repo.varnish-cache.org/source/varnish-${VARNISH_VERSION}.tar.gz

tar zxf varnish-${VARNISH_VERSION}.tar.gz
cd varnish-${VARNISH_VERSION}
./configure --prefix=$VENV --localstatedir=/data/varnish
$PMAKE
make install
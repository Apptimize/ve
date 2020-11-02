BEANSTALKD_VERSION="1.10"

getpkg https://github.com/kr/beanstalkd/archive/v${BEANSTALKD_VERSION}.tar.gz
tar zxf v${BEANSTALKD_VERSION}.tar.gz
cd beanstalkd-${BEANSTALKD_VERSION}
make CFLAGS=-O2
make install PREFIX=$VENV

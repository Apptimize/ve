OPENRESTY_VERSION="1.17.8.1"
rm -fR openresty-${OPENRESTY_VERSION}* ngx_* nginx_* openssl-*

git clone https://github.com/yaoweibin/nginx_upstream_check_module.git
cd nginx_upstream_check_module
git checkout 9aecf15
cd $BUILD_DIR

git clone https://github.com/harvesthq/nginx-statsd
cd nginx-statsd
git checkout b970e40
cd $BUILD_DIR

getpkg https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz
tar zxf openresty-${OPENRESTY_VERSION}.tar.gz

cd openresty-${OPENRESTY_VERSION}/bundle/nginx-1.17.8
patch -p1 < $BUILD_DIR/nginx_upstream_check_module/check_1.12.1+.patch
cd $BUILD_DIR

getpkg https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar zxf openssl-${OPENSSL_VERSION}.tar.gz

SSL_PATCH=openssl-1.1.1c-sess_set_get_cb_yield.patch
SSL_PATCH_URL="https://raw.githubusercontent.com/openresty/openresty/master/patches/$SSL_PATCH"
curl -o "${BUILD_DIR}/$SSL_PATCH" $SSL_PATCH_URL

cd ${BUILD_DIR}/openssl-${OPENSSL_VERSION}
patch -p1 < ${BUILD_DIR}/${SSL_PATCH}
cd $BUILD_DIR

cd openresty-${OPENRESTY_VERSION}

./configure --prefix=$VENV/opt/openresty \
--with-openssl=../openssl-${OPENSSL_VERSION} \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_v2_module \
--with-http_auth_request_module \
--http-client-body-temp-path=$RUN_DIR/nginx/client_body_temp \
--http-proxy-temp-path=$RUN_DIR/nginx/proxy_temp \
--http-fastcgi-temp-path=$RUN_DIR/nginx/fastcgi_temp \
--http-uwsgi-temp-path=$RUN_DIR/nginx/uwsgi_temp \
--http-scgi-temp-path=$RUN_DIR/nginx/scgi_temp \
--http-log-path=$LOG_DIR/nginx/nginx-access.log \
--error-log-path=$LOG_DIR/nginx/nginx-error.log \
--pid-path=$RUN_DIR/nginx/nginx.pid \
--lock-path=$RUN_DIR/nginx/nginx.lock \
--with-cc-opt="$CPPFLAGS" \
--with-ld-opt="$LDFLAGS -Wl,-rpath,$VENV/lib" \
--add-module=$BUILD_DIR/nginx_upstream_check_module \
--add-module=$BUILD_DIR/nginx-statsd

make
make install

PATH=$VENV/opt/openresty/bin:$PATH

$VENV/opt/openresty/bin/opm get pintsized/lua-resty-http
$VENV/opt/openresty/bin/opm get bungle/lua-resty-session
$VENV/opt/openresty/bin/opm get pronan/lua-resty-datetime

ln -s $VENV/nginx/sbin/nginx $VENV/bin/nginx
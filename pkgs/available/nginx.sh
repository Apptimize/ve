NGINX_VERSION="1.8.0"

rm -fR nginx-${NGINX_VERSION}* ngx_* lua-nginx-module* v[0-9]*

getpkg http://luajit.org/download/LuaJIT-2.0.4.tar.gz
tar zxf LuaJIT-2.0.4.tar.gz
cd  LuaJIT-2.0.4
$PMAKE PREFIX=$VENV
make PREFIX=$VENV install
cd ..

getpkg https://github.com/simpl/ngx_devel_kit/archive/v0.2.19.tar.gz
tar zxf v0.2.19.tar.gz

getpkg https://github.com/openresty/lua-nginx-module/archive/v0.9.17.tar.gz
tar zxf v0.9.17.tar.gz

getpkg http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar zxf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}

export LUAJIT_LIB="$VENV/lib"
export LUAJIT_INC="$VENV/include/luajit-2.0"

./configure --prefix=$VENV \
--with-http_ssl_module \
--with-http_stub_status_module \
--http-client-body-temp-path=$RUN_DIR/nginx/client_body_temp \
--http-proxy-temp-path=$RUN_DIR/nginx/proxy_temp \
--http-fastcgi-temp-path=$RUN_DIR/nginx/fastcgi_temp \
--http-uwsgi-temp-path=$RUN_DIR/nginx/uwsgi_temp \
--http-scgi-temp-path=$RUN_DIR/nginx/scgi_temp \
--http-log-path=$LOG_DIR/nginx/nginx-access.log \
--error-log-path=$LOG_DIR/nginx/nginx-error.log \
--pid-path=$RUN_DIR/nginx/nginx.pid \
--lock-path=$RUN_DIR/nginx/nginx.lock \
--with-cc-opt="$CFLAGS" \
--with-ld-opt="$LDFLAGS -Wl,-rpath,$VENV/lib" \
--add-module=../ngx_devel_kit-0.2.19 \
--add-module=../lua-nginx-module-0.9.17

$PMAKE
make install
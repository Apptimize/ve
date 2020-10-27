POSTGRES_VERSION="9.6.9"
getpkg http://ftp.postgresql.org/pub/source/v${POSTGRES_VERSION}/postgresql-${POSTGRES_VERSION}.tar.bz2
tar jxf postgresql-${POSTGRES_VERSION}.tar.bz2
cd postgresql-${POSTGRES_VERSION}

# hack default socket dir
sed -i -e 's:DEFAULT_PGSOCKET_DIR[ ][ ]*"/tmp":DEFAULT_PGSOCKET_DIR "${RUN_DIR}/pg":' src/include/pg_config_manual.h

# Fix configure failure on OSX.
# Details https://www.postgresql.org/message-id/flat/09A4B554-82B1-4536-B191-2461342EE0BB%40icloud.com

if [ "$MOS" == "OSX" ]; then
for postgrestconfig in config/c-compiler.m4 config/c-library.m4 configure; do
sed -i -e 's/exit(! does_int64_work());.*/return (! does_int64_work());/' $postgrestconfig
sed -i -e 's/exit(! does_int64_snprintf_work());.*/return (! does_int64_snprintf_work());/' $postgrestconfig
done
fi

./configure --prefix=$VENV --with-openssl
make
make install

for ext in pgcrypto hstore pg_trgm; do
cd contrib/$ext
make
make install
cd ../..
done

# install prefix
APPTIMIZE_VE_ROOT=$HOME/apptimize-ve
VENV="$APPTIMIZE_VE_ROOT/ave"
DATA_DIR="$APPTIMIZE_VE_ROOT/data"
# cache package downloads
PKG_CACHE="/tmp/ave-pkg"

# build directory
BUILD_DIR="$VENV/build"

# remote rsync for push/pull
RSYNC_USER="ve"
RSYNC_HOST="netops.apptimize.com"
RSYNC_PATH="ve/next"

LOG_DIR="$DATA_DIR/log"
RUN_DIR="$DATA_DIR/run"

OPENSSL_VERSION="1.1.1h"

#!/bin/bash

pushd $(dirname $0) > /dev/null
SCRIPTPATH="$(pwd)"
popd > /dev/null

source $SCRIPTPATH/config.sh

rsync -av --delete $* $RSYNC_USER@$RSYNC_HOST:$RSYNC_PATH/$OS/ $VENV

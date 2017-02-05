#!/bin/bash
cd `dirname $0`

# local setting
BIN_DIR=./bin
MAIN_LAU="main.lua"

# build
ant build
STATUS=$?

# run
if [ $STATUS == "0" ]; then
    cd $BIN_DIR
    $MOAI_BIN/moai $MAIN_LAU
fi

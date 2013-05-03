#!/bin/bash
cd `dirname $0`

# moai setting
MOAI_HOME=~/moai-sdk
MOAI_BIN=$MOAI_HOME/bin/osx/moai

# local setting
BIN_DIR=./bin
CONFIG_LUA="$MOAI_HOME/samples/config/config.lua"
MAIN_LAU="main.lua"

# build
ant build
STATUS=$?

# run
if [ $STATUS == "0" ]; then
    cd $BIN_DIR
    $MOAI_BIN $CONFIG_LUA $MAIN_LAU
fi

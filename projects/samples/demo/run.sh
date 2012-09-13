#!/bin/bash
cd `dirname $0`

# setting
MOAI_HOME=~/moai-sdk
DEST_DIR=./dest
CONFIG_LUA="${MOAI_HOME}/samples/config/config.lua"
MAIN_LAU="main.lua"

# build
ant build

# run
cd ${DEST_DIR}
${MOAI_HOME}/bin/osx/moai $CONFIG_LUA $MAIN_LAU
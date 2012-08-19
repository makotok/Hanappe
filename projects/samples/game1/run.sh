#!/bin/bash
cd `dirname $0`

# setting
MOAI_HOME=~/moai-sdk
DEST_DIR=./dest

# build
ant

# run
cd ${DEST_DIR}
${MOAI_HOME}/bin/osx/moai "${MOAI_HOME}/samples/config/config.lua" "main.lua"
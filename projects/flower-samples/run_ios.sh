#!/bin/bash
cd `dirname $0`

# moai setting
MOAI_HOME=~/moai-sdk
MOAI_BIN="$MOAI_HOME/bin/osx/moai"
MOAI_IOS="$MOAI_HOME/hosts/ios"
MOAI_TARGET="moai-target"
MOAI_LUA_MODULES="$MOAI_HOME/include/lua-modules"

# ios setting
IOS_BUILD_TARGET="MoaiSample"
IOS_BUILD_APP="$IOS_BUILD_TARGET.app"
IOS_BUILD_CONFIG="Release"
IOS_BUILD_JOB="flower"
IOS_BUILD_SDK="iphonesimulator"
IOS_BUILD_DIR="/tmp/$IOS_BUILD_JOB/ios/$IOS_BUILD_TARGET/moai/iphonesimulator/$IOS_BUILD_CONFIG"
IOS_SIMULATOR_DIR=~/"Library/Application Support/iPhone Simulator/6.1/Applications"

# local setting
BIN_DIR="`pwd`/bin"
CONFIG_LUA="$MOAI_HOME/samples/config/config.lua"
MAIN_LAU="main.lua"

# flower build
ant build
STATUS=$?
if [ $STATUS != "0" ]; then
    echo "Build Error!"
    exit 1
fi

# ios build
cd "$MOAI_IOS"
echo "$BIN_DIR" > $MOAI_TARGET
echo "$MOAI_LUA_MODULES" >> $MOAI_TARGET
. package.sh

xcodebuild -configuration $IOS_BUILD_CONFIG -workspace moai.xcodeproj/project.xcworkspace -scheme $IOS_BUILD_TARGET -sdk "$IOS_BUILD_SDK" build CONFIGURATION_BUILD_DIR="$IOS_BUILD_DIR"

# ios install
cd "$IOS_SIMULATOR_DIR"
STATUS=$?
if [ $STATUS != "0" ]; then
    echo "iOS Install Error!"
    exit 2
fi


if [ -e $IOS_BUILD_TARGET ]; then
    rm -fr "$IOS_BUILD_TARGET"
fi

mkdir "$IOS_BUILD_TARGET"
cd "$IOS_BUILD_TARGET"
cp -r "$IOS_BUILD_DIR/$IOS_BUILD_APP" .

# ios run
open -a "iPhone Simulator.app"


#!/bin/bash
cd `dirname $0`
cd src/test
$MOAI_HOME/bin/osx/moai "$MOAI_HOME/samples/config/config.lua" "main.lua"
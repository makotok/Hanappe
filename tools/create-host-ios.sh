#!/bin/bash

hanappe_home=`dirname $0`/..
moaisdk_home=$MOAI_HOME

cd $hanappe_home
rm -fr hosts/latest/ios
mkdir hosts/latest/ios

cd $moaisdk_home/util
pito host-ios -s -o $hanappe_home/hosts/latest/ios/ -c $hanappe_home/tools/hostconfig.lua

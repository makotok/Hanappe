#!/bin/bash

hanappe_home=`dirname $0`/..
moaisdk_home=$MOAI_HOME

cd $hanappe_home
rm -fr hosts/latest/osx
mkdir hosts/latest/osx

cd $moaisdk_home/util
pito host-osx-app -s -o $hanappe_home/hosts/latest/osx/ -c $hanappe_home/tools/hostconfig.lua

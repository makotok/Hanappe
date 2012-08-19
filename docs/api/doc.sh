#!/bin/bash
cd `dirname $0`
rm -rf doc/*
cd src/main
luadoc -d ../../doc hp/*/*.lua

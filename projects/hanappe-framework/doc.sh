#!/bin/bash
cd `dirname $0`

# setting
SRC_DIR=`pwd`"/src"
DOC_DIR=`pwd`"/doc"

# build
rm -rf $DOC_DIR/*

cd $SRC_DIR
ldoc -d $DOC_DIR $SRC_DIR

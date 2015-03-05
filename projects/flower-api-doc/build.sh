#!/bin/bash
cd `dirname $0`

# setting
SRC_DIR=`pwd`"/work"
DOC_DIR=`pwd`"/doc"

# build
ant build
rm -rf $DOC_DIR/*

cd $SRC_DIR
ldoc -d $DOC_DIR $SRC_DIR

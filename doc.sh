#!/bin/bash
cd `dirname $0`
rm -rf doc/*
luadoc -d doc hp/*.lua hp/*/*.lua

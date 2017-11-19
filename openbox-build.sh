#!/bin/bash

## Build xfce desktop.
## This script must be run from the root of the openbox dev folder
## The following folders should exist

## Enter the name of the folder that holds your openbox dev file
basef=`pwd`

## github
##  |
##  ---- DOC PKG32 PKG64 SRC TREE
##
## export64/32
## build

ARCH=`uname -m`

if [ "$ARCH" != "x86_64" ]; then
	ARCH=i486
	SUFFIX=32
else
	SUFFIX=64
fi

[ ! -d $basef/PKG${SUFFIX} ] && { echo "Run this script from root of openbox dev folder"; exit; }

echo "Cleaning old build files"
[ ! -d build ] && mkdir build || rm -rf build/*

for a in `find $basef/PKG${SUFFIX} -type f | egrep "*.tgz|*.txz"`; do
	installpkg --terse -root build $a
done

for a in `find $basef/PKG${SUFFIX} -name "*.xzm"`; do
	xzm2dir $a build
done

cp -a $basef/TREE/* build
cd build
./launch_before_go_openbox.sh
rm launch_before_go_openbox.sh
cd -
#dir2xzm build 003-openbox${SUFFIX}.xzm
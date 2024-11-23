#!/bin/bash

set -e
set -x

BASE=`pwd`
SRC=$BASE/src
WGET="wget --prefer-family=IPv4 -nc"
DEST=$BASE/opt
LDFLAGS="-L$DEST/lib -Wl,--gc-sections"
CPPFLAGS="-I$DEST/include"
CFLAGS="-ffunction-sections -fdata-sections"
CXXFLAGS=$CFLAGS
CC="$(which mipsel-linux-musl-gcc)"
CXX="$(which mipsel-linux-musl-g++)"
AR="$(which mipsel-linux-musl-ar)"
RANLIB="$(which mipsel-linux-musl-ranlib)"
CONFIGURE="./configure --prefix=/opt --host=mipsel-linux"
MAKE="make -j`nproc`"
mkdir -p $SRC

######## ####################################################################
# LUAJIT # ####################################################################
######## ####################################################################

mkdir -p $SRC/lua && cd $SRC/lua
$WGET https://www.lua.org/ftp/lua-5.4.7.tar.gz
tar zxvf lua-5.4.7.tar.gz
cd lua-5.4.7

CC=$CC \
CX=$CXX \
AR=$AR \
LDFLAGS=$LDFLAGS \
CPPFLAGS=$CPPFLAGS \
CFLAGS=$CFLAGS \
CXXFLAGS=$CXXFLAGS

$MAKE
make install INSTALL_TOP=$DEST

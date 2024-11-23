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
# ZLIB # ####################################################################
######## ####################################################################

mkdir -p $SRC/zlib && cd $SRC/zlib
$WGET http://zlib.net/fossils/zlib-1.2.8.tar.gz
tar zxvf zlib-1.2.8.tar.gz
cd zlib-1.2.8

CC=$CC \
CX=$CXX \
AR=$AR \
LDFLAGS=$LDFLAGS \
CPPFLAGS=$CPPFLAGS \
CFLAGS=$CFLAGS \
CXXFLAGS=$CXXFLAGS \
CROSS_PREFIX=mipsel-linux- \
./configure \
--prefix=/opt

$MAKE
make install DESTDIR=$BASE

######## ####################################################################
# DROPBEAR # ####################################################################
######## ####################################################################

mkdir -p $SRC/dropbear && cd $SRC/dropbear
$WGET https://matt.ucc.asn.au/dropbear/dropbear-2024.85.tar.bz2
tar jxvf dropbear-2024.85.tar.bz2
cd dropbear-2024.85

CC=$CC \
CX=$CXX \
AR=$AR \
LDFLAGS=$LDFLAGS \
CPPFLAGS=$CPPFLAGS \
CFLAGS=$CFLAGS \
CXXFLAGS=$CXXFLAGS \
CROSS_PREFIX=mipsel-linux- \
./configure \
--enable-static \
--prefix=/opt \
--host=mipsel-linux \
--with-zlib=$DEST/lib

$MAKE
make install DESTDIR=$BASE

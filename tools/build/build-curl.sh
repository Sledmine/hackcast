#!/bin/bash

set -e
set -x

mkdir ~/curl && cd ~/curl

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
#tar zxvf zlib-1.2.8.tar.gz
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

########### #################################################################
# OPENSSL # #################################################################
########### #################################################################

#mkdir -p $SRC/openssl && cd $SRC/openssl
#$WGET "http://www.openssl.org/source/openssl-1.0.1k.tar.gz"
#tar zxvf "openssl-1.0.1k.tar.gz"
#cd openssl-1.0.1k
#
#cat << "EOF" > openssl.patch
#--- Configure_orig      2013-11-19 11:32:38.755265691 -0700
#+++ Configure   2013-11-19 11:31:49.749650839 -0700
#@@ -402,6 +402,7 @@ my %table=(
# "linux-alpha+bwx-gcc","gcc:-O3 -DL_ENDIAN -DTERMIO::-D_REENTRANT::-ldl:SIXTY_FOUR_BIT_LONG RC4_CHAR RC4_CHUNK DES_RISC1 DES_UNROLL:${alpha_asm}:dlfcn:linux-shared:-fPIC::.so.\$(SHLIB_MAJOR).\$(SHLIB_MINOR)",
# "linux-alpha-ccc","ccc:-fast -readonly_strings -DL_ENDIAN -DTERMIO::-D_REENTRANT:::SIXTY_FOUR_BIT_LONG RC4_CHUNK DES_INT DES_PTR DES_RISC1 DES_UNROLL:${alpha_asm}",
# "linux-alpha+bwx-ccc","ccc:-fast -readonly_strings -DL_ENDIAN -DTERMIO::-D_REENTRANT:::SIXTY_FOUR_BIT_LONG RC4_CHAR RC4_CHUNK DES_INT DES_PTR DES_RISC1 DES_UNROLL:${alpha_asm}",
#+"linux-mipsel", "gcc:-DL_ENDIAN -DTERMIO -O3 -mtune=mips32 -mips32 -fomit-frame-pointer -Wall::-D_REENTRANT::-ldl:BN_LLONG RC4_CHAR RC4_CHUNK DES_INT DES_UNROLL BF_PTR:${mips32_asm}:o32:dlfcn:linux-shared:-fPIC::.so.\$(SHLIB_MAJOR).\$(SHLIB_MINOR)",
#
# # Android: linux-* but without -DTERMIO and pointers to headers and libs.
# "android","gcc:-mandroid -I\$(ANDROID_DEV)/include -B\$(ANDROID_DEV)/lib -O3 -fomit-frame-pointer -Wall::-D_REENTRANT::-ldl:BN_LLONG RC4_CHAR RC4_CHUNK DES_INT DES_UNROLL BF_PTR:${no_asm}:dlfcn:linux-shared:-fPIC::.so.\$(SHLIB_MAJOR).\$(SHLIB_MINOR)",
#EOF
#
#patch < openssl.patch
#
#./Configure linux-mipsel \
#-ffunction-sections -fdata-sections -Wl,--gc-sections \
#--prefix=/opt shared zlib zlib-dynamic \
#--with-zlib-lib=$DEST/lib \
#--with-zlib-include=$DEST/include
#
#make CC=$CC AR="$AR r" RANLIB=$RANLIB
#make install CC=$CC AR="$AR r" RANLIB=$RANLIB INSTALLTOP=$DEST OPENSSLDIR=$DEST/ssl

######## ####################################################################
# CURL # ####################################################################
######## ####################################################################

mkdir -p $SRC/curl && cd $SRC/curl
$WGET http://curl.haxx.se/download/curl-7.40.0.tar.gz
tar zxvf curl-7.40.0.tar.gz
cd curl-7.40.0

CC=$CC \
CX=$CXX \
AR=$AR \
LDFLAGS=$LDFLAGS \
CPPFLAGS=$CPPFLAGS \
CFLAGS=$CFLAGS \
CXXFLAGS=$CXXFLAGS \
$CONFIGURE \
--with-zlib=$DEST
#--with-ssl=$DEST

$MAKE LIBS="-all-static -ldl"
make install DESTDIR=$BASE/curl
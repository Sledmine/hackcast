#!/bin/bash

############### dump rootfs
#dd count=8388608 skip=1114112 ibs=1 of=rootfs if=

############### patch old fs with new fs
#dd of=custom.firmware bs=1 seek=1114112 count=7274496 conv=notrunc < customfs

OFFSETS=$(xxd rootfs | grep "1f8b 0804 0000 0000 000b" | awk -F ':' '{ print $1 }' )
DEC_OFFSETS=$(echo -e "$OFFSETS" | while read i; do echo $((16#$i)); done)
prev=0
cur=0
index=0
while read i;
do
	cur=$i
	dd if=rootfs of=rootfs$index.gz ibs=1c skip="$prev"c obs=1K count=$(($cur-$prev))c
	prev=$cur
	index=$(($index+1))
done < <(echo -e "$DEC_OFFSETS")

filesize=$(wc -c < rootfs)
dd if=rootfs of=rootfs$index.gz ibs=1c skip="$prev"c obs=1K count=$(($filesize-$prev))c
rm rootfs0.gz
gunzip rootfs*.gz
mv rootfs _rootfs
cat rootfs* > ROOTFS
rm rootfs*
mv _rootfs rootfs

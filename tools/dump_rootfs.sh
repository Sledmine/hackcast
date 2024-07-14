#!/bin/bash

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

#!/bin/bash
rm customfs ; mksquashfs-lzma rootfs customfs -b 131072; unsquashfs-lzma -s customfs
echo $PWD
luajit ../../tools/fs_patcher.lua "../../dumped_firmware/sage_8268B_mirascreen-dongle_8Mkey-8723as(19659015).firmware" $PWD/customfs $PWD/custom.firmware
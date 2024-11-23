# hackcast
Firmware dump, builder and compiler for cast-like devices or more specifically "Actions
MicroEletronics Native MBR for Embedded Linux on NandFlash" devices.

Commercial device names:
- MiraScreen M2 Pro (sage_8268B_mirascreen-dongle_8Mkey-8723as) [AliExpress (second option/color)](https://es.aliexpress.com/item/1005006821979781.html)
- AnyCast M2 Plus (am_8268B_anycast-dongle_8MFree) [AliExpress](https://es.aliexpress.com/item/1005006821979781.html)

sage_8268B_mirascreen-dongle_8Mkey-8723as 19659015:
- Linux Kernel 2.6.27.29

am_8268B_anycast-dongle_8MFree 19028031:
- Linux Kernel 2.6.27.29

## Firmware dump
Firmware dumped for the previously mentioned devices is available in the `dumped_firmware` directory.
You can dump the firmware from the device using a CH341A programmer and the flashrom utility, you can
try to use the following command to dump the firmware:
```bash
flashrom -VV -p ch341a_spi -n -r firmware.bin
```

## Building binaries for the device
At this moment the only way to build the binaries is to cross
compile them and upload them to the device via rebuilding firmware filesystem or to upload using
a hacked version of the `upload.cgi` binary that comes with the device.

For building binaries we recommend you to use musl libc, as it does not depend on glibc and it will
be easier to run the binaries on the device due to no need to match the glibc version and kernel
version.

Get the musl libc toolchain from:
```bash
wget https://musl.cc/mipsel-linux-musl-cross.tgz
tar -xvf mipsel-linux-musl-cross.tgz
export PATH=$PATH:/path/to/mipsel-linux-musl-cross/bin
```
Then you can build the binaries with:
```bash
mipsel-linux-musl-gcc -static -o binary binary.c
```
You can find in this repository under `tools/build` scripts that will help you build the binaries
for the device, also under the `bin` directory you will find some precompiled binaries that you can
use directly on the device, not all of them work due to some compatibility issues like
some programs expecting taking control over a folder that is read-only.

## Useful commands to run with stock firmware
```bash
# Launch a web server on port 8080
thttpd -p 8080 -d /tmp -u root
# Launch a web server on port 8080 with CGI support
thttpd -p 8080 -d /tmp -c /*.cgi -u root
```
# Firmware teardown so far

Firmware appears to contain a boot loader, unknown firmware files, a custom linux kernel and a 
root filesystem made with squashfs.

We have been able to extract and rebuild the filesystem, but we are still working on the kernel
and the boot loader.

Once the system has been booted, it will start the `init` process using file `/etc/inittab` as
configuration file, from there it will start the `rcS` script which will pretty much launch all
the services and applications used by the device.

# Building firmware with custom filesytem
By running binwalk on the firmware file we can see that it contains a squashfs filesystem:
```bash
binwalk -e am_8268B_anycast-dongle_8MFree(19028031).firmware
```
```
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
38160         0x9510          CRC32 polynomial table, little endian
41535         0xA23F          Copyright string: "Copyright 1995-2005 Mark Adler "
43620         0xAA64          xz compressed data
77824         0x13000         xz compressed data
1114112       0x110000        Squashfs filesystem, little endian, non-standard signature, version 3.1, size: 7057135 bytes, 767 inodes, blocksize: 131072 bytes, created: 2024-03-20 07:03:54
```
Filesystem is at offset 1114112, we can extract it using dd:
```bash
dd if=am_8268B_anycast-dongle_8MFree(19028031).firmware of=rootfs bs=1 skip=1114112
```
However filesystem is compressed with .gz in different chunks, we need to find every chunk and
decompress it, there is a script in the `tools` directory that will help you with this task:
```bash
./tools/dump_rootfs.sh rootfs
```
Once you have the filesystem in one piece you can now use `unsquashfs` to extract it, keep in mind
you need a custom version of `unsquashfs` that supports the filesystem version used by the device
you can find it in the `firmware_tools` directory:
```bash
unsquashfs-lzma rootfs -d stockfs-root
```
Now you can modify the filesystem as you wish, once you are done you can rebuild the filesystem
using the following command:
```bash
mksquashfs-lzma stockfs-root custom.firmware
```
You have to patch the firmware file with the new filesystem, there is a script in the `tools`
directory that will help you with this task:
```bash
luajit tools/fs_patch.lua am_8268B_anycast-dongle_8MFree(19028031).firmware customfs
```
This will create a new firmware file called `custom.firmware` with the new filesystem, you can now write it to the device.

# Writing firmware to the device
Custom firmware is written to the device using flashrom, you can use the following command to write
the firmware to the device:
```bash
flashrom -VV -p ch341a_spi -n -w custom.firmware
```
# Problems and stoppers
- We still don't have idea how the boot loader works, we are trying to reverse engineer it.
- Kernel is not open source, so I guess we will have to try and use the one from the device or reverse
  engineer it, I'm open to suggestions.
- Video output is proprietary so any chance to display custom images trough HDMI is not possible yet.
- Filesystem is read-only, so firmware modifications are not possible without reflashing the device.

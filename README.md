# hackcast
Firmware dump, builder and compiler for cast-like devices or more specifically "Actions
MicroEletronics Native MBR for Embedded Linux on NandFlash" devices.

Commercial device names:
- MiraScreen M2 Pro (sage_8268B_mirascreen-dongle_8Mkey-8723as)
- AnyCast M2 Plus (am_8268B_anycast-dongle_8MFree)

sage_8268B_mirascreen-dongle_8Mkey-8723as 19659015:
- Linux Kernel 2.6.27.29

am_8268B_anycast-dongle_8MFree 19028031:
- Linux Kernel 2.6.27.29

## Building binaries for the device
As there is no way to rebuild the firmware yet, the only way to build the binaries is to cross
compile them and upload them to the device `upload.cgi` exploit.

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


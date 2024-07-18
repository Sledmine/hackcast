# hackcast
Firmware dump, builder and compiler for cast-like devices or more specifically "Actions
MicroEletronics Native MBR for Embedded Linux on NandFlash" devices.

Commercial device names:
- MiraScreen M2 Pro (sage_8268B_mirascreen-dongle_8Mkey-8723as)
- AnyCast M2 Plus (am_8268B_anycast-dongle_8MFree)

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

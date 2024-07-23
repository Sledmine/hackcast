#!/bin/sh
alias busybox="/tmp/busybox.pem"
for i in $(./busybox.pem --list); do
    #ln -s /bin/busybox /bin/$i
    echo "Aliasing $i to /tmp/busybox.pem $i"
    alias $i="/tmp/busybox.pem $i"
done

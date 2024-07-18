#!/bin/bash
ARGPARSE_DESCRIPTION="Wrapper script to upload files to cast device"
source $(dirname $0)/argparse.bash || exit 1
argparse "$@" <<EOF || exit 1
parser.add_argument('filepath')
parser.add_argument('-p', '--patched', action='store_true', default=False, help='Use patched upload.cgi')
EOF

#for file in custom*; do mv "$file" "$file".pem; done
#for file in *.pem; do curl -v -H 'User-Agent:' -H 'Accept:' -F name=fileName -F fileName="@$file" "http://192.168.100.5:8080/upload.cgi" ; done
#thttpd -p 8080 -d /tmp -c /*.cgi -u root

# Check if arguments flags include "--patch"
if [ $PATCHED ]; then
	echo "Patched firmware, using modified upload.cgi..."
	curl -v -H 'User-Agent:' -H 'Accept:' -F name=fileName -F fileName=@$FILEPATH "http://192.168.100.5:8080/upload.cgi"
else
	echo "Original firmware, using original upload.cgi..."
	cp $FILEPATH "$FILEPATH.pem"
	curl -v -H 'User-Agent:' -H 'Accept:' -F name=fileName -F fileName=@$FILEPATH.pem "http://192.168.100.5/cgi-bin/upload.cgi"
	rm "$FILEPATH.pem"
fi

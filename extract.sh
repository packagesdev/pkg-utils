#!/bin/sh

if [ $# -lt 1 ]; then
   	echo "Missing distribution path"
    exit 1
fi

if [ -f "$1" ]; then
    echo "Extracting packages from $1"
else 
    echo "$1 does not exist"
    
    exit 1
fi

distributionNameWithExtension=`/usr/bin/basename $1`

temporaryDirectory=$(/usr/bin/mktemp -d "/var/tmp/${distributionNameWithExtension}".XXXXXXXXX)

/usr/sbin/pkgutil --expand "$1" "${temporaryDirectory}/expanded/"

cd "${temporaryDirectory}/expanded"

/bin/mkdir ../extracted

/usr/bin/find . -type d -name '*.pkg' | while read FILE ; do
	/usr/sbin/pkgutil --flatten "${FILE}" "${temporaryDirectory}/extracted/${FILE}"
done

cd ../extracted

/usr/bin/open .

exit 0

#!/bin/bash

# get the MaxMind's GeoLite2 Country, City, and ASN databases from here
# https://github.com/P3TERX/GeoLite.mmdb
# script adopted from https://mailfud.org/geoip-legacy/


# Database directory
DBDIR=/usr/share/GeoIP

# Files to download (.dat.gz suffix not required)
FILES="https://git.io/GeoLite2-ASN.mmdb https://git.io/GeoLite2-City.mmdb https://git.io/GeoLite2-Country.mmdb"

# If http proxy needed
#https_proxy="http://foo.bar:3128"

# DB directory
test -w $DBDIR && cd $DBDIR 2>/dev/null || { echo "Invalid directory: $DBDIR"; exit 1; }

# Sleep 0-600 sec if started from cron
if [ ! -t 0 ]; then sleep $((RANDOM/54)); fi

export https_proxy
for f in $FILES; do
	wget -nv -N -T 30 $f --directory-prefix=$DBDIR
	RET=$?
	if [ $RET -ne 0 ]; then
		echo "wget $f failed: $RET" >&2
		continue
	fi
done


#!/bin/bash

# this script run on admin/janus directory verify to verify the production probe.
# it is called by verify-label.pl running on laptop 

DESIRED_VERSION="1040_4610_1"

VLOGFILE='/home/atlas/verify/tplink-xx.txt'

DATE=`date '+%Y%m%d-%H%M'`
if [ -z "$1" ] ; then
    m=$SSH_ORIGINAL_COMMAND 
else
    m=$1
fi

mac=$(echo $m | tr -d ':')

if [ -z "$mac" ]; then
	echo "ERROR 0 NOMAC $@"
	exit
fi

rep=`echo "select prb_id, prb_mac from admin_probe where prb_mac='$mac';" | mysql -u viewer -poop8quiepaeMuche -h atlas-db.atlas.ripe.net --ssl-ca=/etc/pki/tls/certs/RIPEAtlasCA.pem atlas_meas | grep -v prb_id` 

## don't change format of OTXT. It is parsed by a perlscript.
## check what verify-label.pl is doing.

if [ -z "$rep" ]; then
	OTXT="$DATE ERROR 1 MAC $mac NOT FOUND IN DB"
	echo "$OTXT"
	echo "$OTXT" >> $VLOGFILE

	exit;
else 
	probes=`echo $rep | wc -l`
	if [ "$probes" -gt 1 ]; then	
		OTXT="$DATE ERROR 2 MAC $mac duplicate has $probes"
		echo "$OTXT"
		echo "$OTXT" >> $VLOGFILE
		exit;
	fi
	set $rep
	prb_id=$1
	mac=$2
	ver=`echo "select prb_last_kernel,prb_last_app,prb_from>prb_to from meas_probe where prb_id='$prb_id';" | mysql -u viewer -poop8quiepaeMuche -h atlas-db.atlas.ripe.net --ssl-ca=/etc/pki/tls/certs/RIPEAtlasCA.pem atlas_meas | grep -v prb_last_app`
	if [ -z "$ver" ]; then
		OTXT="$DATE ERROR 3 MAC $mac Probe ID $prb_id NO firmware version"
		echo "$OTXT"
		echo "$OTXT" >> $VLOGFILE
		exit;
	fi
	ver=`echo $ver | tr " " _`
	if [ "$ver" == "$DESIRED_VERSION" ]; then
		OTXT="$DATE SUCCESS 1 MAC $mac Probe ID $prb_id"
		echo "$OTXT"
		echo "$OTXT" >> $VLOGFILE
		exit
	else
		OTXT="$DATE ERROR 4 MAC $mac Probe ID $prb_id MISMATCH $ver vs $DESIRED_VERSION"
		echo "$OTXT"
		echo "$OTXT" >> $VLOGFILE
		exit
	fi
fi

#!/bin/sh

#model="tl-wr703n"
model="tl-mr3020"

if [ $# -ne 1 ]
then
	echo "Usage: install-atlas dev|test|prod" >&2
	echo "Usage: install-atlas prod verbose" >&2
	exit 1
fi

mode=$(echo $1 | tr '[:upper:]' '[:lower:]')
verbose=$(echo $2 | tr '[:upper:]' '[:lower:]')
serial='deadbeef'
BASEDIR=/home/atlas/openwrt
FIRMWARE_FILE="bin/ar71xx/openwrt-ar71xx-generic-$model-v1-squashfs-factory.bin";
KEYS_DIR=keys

export GREEN="\e[0;32m"
export BLUE="\e[0;34m"
export RED="\e[0;31m"
export ENDCOLOR="\e[m"
export MAGENTA="\e[0;35m"

echo_atlas()
{
	if [ "$mode" = "prod"  ] ; then
		if [ "$verbose" = "verbose" ] ; then
			printf "$1"
		else 
			printf  "$1"  >/dev/null 2>/dev/null	
		fi
	else
		printf "$1"
	fi
}

kill_tcpdump()
{
	TCPDUMP_PID_R=`pidof tcpdump`
	printf "tcpudump running $TCPDUMP_PID_R to kill $TCPDUMP_PID\n"
	for s in $TCPDUMP_PID_R 
	do
		if [ "$s" == "$TCPDUMP_PID" ] ; then
			# -2 is SIGINT
			echo "kill -s 2 $s"
			sudo /bin/sh -c "kill -s 2 $s"
		fi
	done
}

clean_tcpdump()
{
 kill_tcpdump
 rm  -fr ./${ether_nocol}.pcap
}

if [ "$mode" = "prod"  ]  ; then
	FIRMWARE_FILE='initprobe/images/kernel-tl-mr3020-1040.bin'
	echo "initialize production probe using $FIRMWARE_FILE"
	KEYS_DIR='keys-prod'
else 
	serial='deadbeef'
	echo "not production? serial default to : $serial"
fi

case X"$model" in
Xtl-wr703n)
PROBEADDR=192.168.1.1
PROBEADDRNEW=192.168.1.2
;;
Xtl-mr3020)
PROBEADDR=192.168.0.254
PROBEADDRNEW=192.168.0.2
;;
*)
echo "Unknow model '$model'" >&2
exit 1
;;
esac

cd $BASEDIR/initprobe || { echo "Can't cd to initprobe directory"; exit 1; }

if [ ! -d "$KEYS_DIR" ] ; then
	mkdir -p $KEYS_DIR
fi


# Wait for the probe to become alive
i=0
printf  "${BLUE}Plugin a FLASH FAILED probe. Pinging $PROBEADDRNEW ${ENDCOLOR} : "

cp dhcpd.leases.empty /var/lib/dhcp/dhcpd.leases
cp dhcp.conf.in.fails dhcp.conf
sudo /etc/init.d/isc-dhcp-server stop
sudo sh -c "cat dhcpd.leases.empty > /var/lib/dhcp/dhcpd.leases"
sudo sh -c "rm -fr /var/lib/dhcp/dhcpd.leases?"
sudo /etc/init.d/isc-dhcp-server start

while [ $i -lt 100 ]
do
	ping -c 1 $PROBEADDRNEW >/dev/null && break
	i=$(expr $i + 1)
	echo_atlas " $i"
	sleep 1
done
echo
# Try to find the probe's MAC address
ping -c 1 $PROBEADDRNEW >/dev/null 2>/dev/null || { echo_atlas "Probe unreachable ($PROBEADDRNEW)?\n"; exit 1; }
set $(/usr/sbin/arp -n $PROBEADDRNEW | grep $PROBEADDRNEW)
probe_ea=$3
ether=$(echo $probe_ea | tr 'a-f' 'A-F')
ether_nocol=$(echo $ether | tr -d ':')

log_entry()
{
	echo $(date +"%Y%m%d-%H%M%S") $1 $mode probe $ether_nocol $ether $serial $2 >> initprobe-$mode.log
}

log_entry NEWPROBEFIXED

if [ "$mode" = "prod" ] ; then
	install_n=`grep $ether_nocol initprobe-$mode.log | wc -l` 
	if [ "$install_n" -gt 8 ] ; then
		printf "${RED}FAILED: Probe $ether  label it : ${ENDCOLOR}"
		printf "${RED} failed $install_n times ${ENDCOLOR}\n"
		printf "Press ENTER to continue."
		read eee
		/usr/bin/clear 
		exit 1
	fi
fi

/usr/sbin/tcpdump -s 0 -w  ./${ether_nocol}.pcap -n -i eth2 &
TCPDUMP_PID=$!
#TCPDUMP_SUDO_PID=$!
#TCPDUMP_PID=`ps --ppid $TCPDUMP_SUDO_PID -o pid=`
echo "tcpdump $TCPDUMP_PID sudo $TCPDUMP_SUDO_PID "

starttime=$(date +%s)

# Generate a new key if one doesn't exist already
if [ ! -f "$KEYS_DIR/$ether" ] 
then
	echo "Creating a new key for the probe MAC $ether $KEYS_DIR/$ether  "
	rm -f "$KEYS_DIR/$ether"
	ssh-keygen -t rsa -P '' -C $ether  -f $KEYS_DIR/$ether 

	# Generate keys for the two partitions on USB.
	dd if=/dev/urandom of=$KEYS_DIR/$ether.sda2 count=1
	dd if=/dev/urandom of=$KEYS_DIR/$ether.sda3 count=1
else
        echo "Using the existing key for the probe $KEYS_DIR/$ether"
fi

printf "Probe is alive Sleeping to allow sshd on the probe get started.\n"
sleep 5

sh copy-keys $ether $PROBEADDRNEW $mode $serial || 
	{ 
		printf "${RED}Unable to copy keys to probe $ether ${ENDCOLOR}\n"  
		log_entry ERROR "copy key failed "
		kill_tcpdump
		exit 1
	}

clean_tcpdump

echo $model $ether_nocol $serial $(cat $KEYS_DIR/$ether.pub) >> probes.$mode
endtime=$(date +%s)
log_entry SUCCESSFIXEDPROBE $(expr $endtime - $starttime) 
printf  "${GREEN}SUCCESS $ether is complete. Please remove the probe and  Pres ENTER to continue. ${ENDCOLOR}\n"
read eee
/usr/bin/clear 

exit 0

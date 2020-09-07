#!/bin/bash
# this run from .ssh/authrized_keys/
# command="/home/atlas/openwrt/initprobe/install-atlas-prod-loop.sh" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3txHCcOq6MMvpCMU9J3CVT89CfPYqn2OKwRAc8iUzm6EbgwlncWPHysFnXR1tK8Imikd8anPzjCaTV2qTp/pUysr8EhuA0Kq0f2IfN+LGZtQ+PGh7Ebb2WOGxbfLy74l3EzdLwhGJh2oNNQBN/hbg3FFDfsLY/3is+5Xz57kFdpyIC7jXCsTLiHnplsrtbIF5O4UDJAcXHLmnldyPNR4WH4lhCvPZ4I/lQi/bgbdlc28ADlxBm6U8qBvmIM83maUiVrI2RyGj0Ujo6X92eOBM55giPD1EaaGlkz7Ii/EaVBUMNWwnDJsVk5WIl5Bj9yuBS0GyDmxFTjCGm90rtyNN 00:00:00:00:45:10

keys=`ssh-add -l` 
set $keys 
len=$1
fp=$2

if [ -n "$fp" ] ; then
	if [ "$fp" == "97:1c:2e:cb:8c:11:f1:85:09:54:c6:60:9a:79:5e:53" ] ; then
		printf "\nHave a key ready!!\n"
	elif [  "$len" == "1024" ] ; then
		printf "\n Have some key $len $fp $3  good luck\n"
	elif [  "$len" == "2048" ] ; then
		printf "\n Have some key $len $fp $3  good luck\n"
	else 
		printf "\n No Known keys \n"
		exit 
	fi
else 
	printf "\n NO ssh key forwarded ?\n"
	exit;
fi

cd /home/atlas/openwrt/initprobe/
while [ 1 ]; do 
	killall install-atlas 2>/dev/null
	./install-atlas prod
#	printf "this only works on flash failed probes\n"
#	./fix-fails.sh prod
done
else 
	printf "no ssh key forwarded. can't initialize probe\n"
	exit;
fi

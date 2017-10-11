#!/bin/bash
if [ ! -f ./oui.txt ]; then
	echo -n "oui.txt not found. start download (y/n)? "
	read answer
	if echo "$answer" | grep -iq "^y"; then
		wget http://standards-oui.ieee.org/oui.txt
	else
		exit
	fi
fi
echo -e "HOST IPaddr MACaddr Interface \033[1;35mVendor\033[0m\n"
while read -r line
do
	words=( $line )
	HOST=${words[0]}
	IP=${words[1]}
	MAC=${words[3]}
	NIF=$(echo $line | grep -oP '(?<=on ).*')
	VENDMAC=${MAC:0:2}-${MAC:3:2}-${MAC:6:2}
	ouiline=$(grep -wi "^$VENDMAC" ./oui.txt)
	VENDOR=$(echo $ouiline | grep -oP '(?<=\(hex\) ).*')
	echo -e "$HOST $IP $MAC $NIF \033[1;35m$VENDOR\033[0m"
done < <(sudo arp -a)


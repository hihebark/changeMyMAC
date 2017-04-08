#!/bin/bash

echo -e "   .                      .  ..--. __ \n _ |_  _,._  _  _ ._ _   .|\/||__|/  \`\n(_,[ )(_][ [(_](/,[ [ [\_||  ||  |\__,\n            ._|        ._| -v 0.1 Beta\n"
if [[ $EUID -ne 0 ]]; then
	echo "[!] Must be run as root!"
	echo "[!] sudo bash $0 [-r | -m ff:ff:ff:ff:ff:ff | -p]"
	exit
else
    randmac=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/./0/2; s/.$//')
	if [[ $1 == '-m' ]]; then
		check="^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$"
		if ! [[ $2 =~ $check ]]; then
   			echo -e "[!] MAC address must be in format ff:ff:ff:ff:ff:ff\ntry the option -r to get random MAC" >&2;
			exit 1
			exit 1
		elif [[ $2 != "ff:ff:ff:ff:ff:ff" ]]; then
		  newmac=$2
		else 
			echo -e "[!] Error the MAC address must not be like: ff:ff:ff:ff:ff:ff\nyou can use this Mac address: $randmac"
			exit
		fi
	elif [[ $1 == '-r' ]]; then
		newmac=$randmac
	elif [[ $1 == '-p' ]]; then
	  newmac='ff:ff:ff:ff:ff:ff' #put here you'r MAC addresse
	fi
fi
sleep .5s
ifconfig wlan0 down
ifconfig wlan0 hw ether "$newmac"
sleep .5s
ifconfig wlan0 up
echo "[+] You'r new MAC: $newmac"
ifconfig wlan0

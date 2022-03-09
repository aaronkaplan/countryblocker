#!/bin/bash

countries=$( cat countries.txt )
date=$(date --iso-8601)


echo "making backup of iptables..."
# you can always restore your rules via iptables-restore in case something goes wrong...
mkdir -p backups
iptables-save > backups/$date-iptables.save

# note: you first have to have called ./fetch-ripe-assignments.sh
# this creates the data/*.txt files with lists of CIDR ranges.
# next, iterate over these:
for cc in $countries; do
	ipset="${cc}-blocker"
	ipv4file="data/$date-$cc-ipv4.txt"

	ipset destroy $ipset
	ipset create $ipset hash:net counters

	# ################### IPv4
	echo "Installing new netblock rules for country $cc."
	echo "==============================================="
	echo "(IPv4)"
	echo 
	let i=0
	for netblock in $(bzcat $ipv4file.bz2 | sort | uniq |   iprange --optimize ); do
		ipset -exist add $ipset $netblock
		result=$((i++ % 100))
	        if [ $result -eq 0 ]; then	
			echo -n "."
		fi
	done
	echo "Done (v4)"


	# ################### IPv6
	ipset6="${cc}-blocker-v6"
	ipv6file="data/$date-$cc-ipv6.txt"
 
	ipset destroy $ipset6
	ipset create $ipset6 hash:net family inet6 counters
 
 	echo 
 	echo "(IPv6)"
 	echo 
 	let i=0
 	for netblock in $(bzcat $ipv6file.bz2 | sort | uniq  ); do
 		ipset add $ipset6 $netblock
 		result=$((i++ % 100))
 	        if [ $result -eq 0 ]; then	
 			echo -n "."
 		fi
 
 	done
 	echo "done (v6)"

	# activate the rules, here is where the magic of ipset comes in... It ends up being two rules only for many CIDR ranges.
	iptables  -I INPUT -m set --match-set $ipset  src  -j DROP
	ip6tables -I INPUT -m set --match-set $ipset6 src  -j DROP
done





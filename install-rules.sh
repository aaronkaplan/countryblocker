#!/bin/bash

countries=$( cat countries.txt )
date=$(date --iso-8601)


echo "making backup of iptables..."
iptables-save > backups/$date-iptables.save

# for IPv4 only so far....
for cc in $countries; do
	table="${cc}-blocker"
	ipv4file="data/$date-$cc-ipv4.txt"

	iptables -F $table && echo "flushed table $table"
	iptables -N $table && echo "  and created a new one"

	# ################### IPv4
	echo "Installing new netblock rules for country $cc."
	echo "==============================================="
	echo "(IPv4)"
	echo 
	let i=0
	for netblock in $(bzcat $ipv4file.bz2 | sort | uniq |   iprange --optimize ); do
		iptables -A $table -s $netblock -j DROP
		result=$((i++ % 100))
	        if [ $result -eq 0 ]; then	
			echo -n "."
		fi

	done
	echo "Done."
	iptables -A $table -j RETURN 
	iptables -I INPUT -j $table


	# ################### IPv6
	ipv6file="data/$date-$cc-ipv6.txt"

	ip6tables -F $table && echo "flushed table $table"
	ip6tables -N $table && echo "  and created a new one"

	echo 
	echo "(IPv6)"
	echo 
	let i=0
	for netblock in $(bzcat $ipv6file.bz2 | sort | uniq  ); do
		ip6tables  -A $table -s $netblock -j DROP
		result=$((i++ % 100))
	        if [ $result -eq 0 ]; then	
			echo -n "."
		fi

	done

	ip6tables -A $table -j RETURN 
	ip6tables -I INPUT -j $table
done





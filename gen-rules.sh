#!/bin/bash

countries=$( cat countries.txt )
date=$(date --iso-8601)

cp /dev/null  add.v4
cp /dev/null  add.v6
cp /dev/null  head.v4
cp /dev/null  head.v6

iptables() {
	echo "$@" >> add.v4
}

ip6tables() {
	echo "$@" >> add.v6
}

iptables_head() {
	echo "$@" >> head.v4
}

ip6tables_head() {
	echo "$@" >> head.v6
}


#echo "making backup of iptables..."
#mkdir -p backups
#iptables-save > backups/$date-iptables.save


for cc in $countries; do
	table="${cc}-blocker"
	iptables_head ":$table - [0:0]"
	ip6tables_head ":$table - [0:0]"
done

for cc in $countries; do
	table="${cc}-blocker"
	iptables_head -A INPUT -j $table
	ip6tables_head -A INPUT -j $table
done

for cc in $countries; do
	table="${cc}-blocker"
	ipv4file="data/$date-$cc-ipv4.txt"

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


	# ################### IPv6
	ipv6file="data/$date-$cc-ipv6.txt"

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
done





#!/bin/bash

countries=$( cat countries.txt )
date=$(date --iso-8601)


echo "flushing country block list rules..."

# for IPv4 only so far....
for cc in $countries; do
	table="${cc}-blocker"
	iptables -F $table && echo "flushed table $table"
	ip6tables -F $table && echo "flushed table $table (v6)"
	iptables -t filter -D INPUT -j $table
done
echo "Done."





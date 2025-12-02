#!/bin/sh

countries=$( cat countries.txt )
date=$(date --iso-8601)

mkdir -p data

for cc in $countries; do
	outfile="data/$date-$cc.json"
	ipv4file="data/$date-$cc-ipv4.txt"
	ipv6file="data/$date-$cc-ipv6.txt"
	asnfile="data/$date-$cc-asn.txt"

	curl "https://stat.ripe.net/data/country-resource-list/data.json?resource=$cc&v4_format=prefix"  > $outfile
	jq -r '.data.resources.ipv4[]'  < $outfile > $ipv4file
	jq -r '.data.resources.ipv6[]'  < $outfile > $ipv6file
	jq -r '.data.resources.asn[]'   < $outfile > $asnfile

	bzip2 -f $outfile $ipv4file $ipv6file $asnfile
done



combinedoutfile=data/$date-combined.json
cat < /dev/null > $combinedoutfile

for cc in $countries; do 
	curl "https://stat.ripe.net/data/country-resource-list/data.json?resource=$cc"  >> $combinedoutfile
	jq -r '.data.resources.ipv4[]' < $combinedoutfile | sort > $combinedoutfile.txt
done
	

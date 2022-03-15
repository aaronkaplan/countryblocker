#
# /etc/iptables/Makefile for Debian
#

# uncomment to add IPv6 statistics output

#IP6=yes


IPTABLES=/usr/sbin/iptables
IP6TABLES=/usr/sbin/ip6tables


all: .state

.state gen: rules.v4 rules.v6
	@-./UPDATE ;\
	mkdir -p REV; \
	cp -p rules.v4 REV/rules.v4.`date +%Y-%m-%d` ;\
	cp -p rules.v6 REV/rules.v6.`date +%Y-%m-%d` ;\
	touch .state

rules.v4: rules.v4.m4 countryblocker/head.v4 countryblocker/add.v4
	m4 $< > $@

rules.v6: rules.v6.m4 countryblocker/head.v6 countryblocker/add.v6
	m4 $< > $@

status:
	$(IPTABLES) -vnL

status6:
	$(IP6TABLES) -vnL

stat stats:
	@-$(IPTABLES) -L -vnx | awk '/Chain|destination/||($$1!=0){print}'
	@-test -n "$(IP6)" && ( $(IP6TABLES) -L -vnx | awk '/Chain|destination/||($$1!=0){print}' ) || true

cron.stats:
	@-mkdir -p statistics ;\
	$(MAKE) -s stats > statistics/iptables-stats.`date +%Y-%m-%d`


help:
	@-awk '/^##/,/_END_/{print substr($$0,2)}' Makefile

## /etc/iptables/Makefile help
#
# To enable IPv6 statistic output uncomment set the IP6 variable in Makefile!
#
# Pathes and files:
# 	REV/	dated rule history
# 	statistics/
# 		dated statistic output (see cron.stats target)
#	countryblocker/
#		Countryblocker scripts
#	.state	update timestamp file
# 
# Targets:
# 	gen	generate IPtables rules derived from countryblocker changes
# 	stat
# 	status	show the IPv4 IPtables rules
# 	status6	show the IPvr64 IPtables rules
# 	cron.stats
# 		create and save a statistics output in statistics/
#
# Cron tab (optional): (crontab -e -u root)
# 	5 0 * * * make -sC /etc/iptables cron.stats
#

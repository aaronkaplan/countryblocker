# countryblocker
simple scripts which fetch CIDR blocks by country code and add them to iptables/ipset blocklists

There are two ways to do this in Linux:

  1. directly by iptables (like in ``iptables -A $table -s 8.8.8.8/32 -j DROP``). However, this is inefficient for large numbers of netblocks
  2. via ``ipset``: this is much more efficient. See many tutorial such as https://malware.expert/howto/ipset-with-iptables/

# How to use this?

Put it into a crontab script!

First you need to specify the countries which should be blocked: edit ``countries.txt``.
Next, fetch the IP ranges from RIPE stat: ``fetch-ripe-assignments.sh``
Third, insert them into iptables via ipset: ``install-rules-ipset.sh``



# countryblocker
simple scripts which fetch CIDR blocks by country code and add them to iptables/ipset blocklists

There are two ways to do this in Linux:

  1. directly by iptables (like in ``iptables -A $table -s 8.8.8.8/32 -j DROP``). However, this is inefficient for large numbers of netblocks
  2. via ``ipset``: this is much more efficient. See many tutorial such as https://malware.expert/howto/ipset-with-iptables/

# **NOTE WELL**

Of course, the country blocker is not necessarily helpful for you, it really depends a lot on the use case.
For my private email and web server which only is there for me, I can agree with myself that I am OK with blocking certain CIDR (IP) ranges.
For example TOR Exit node lists. Or North Korea to give some example. **THIS MIGHT NOT BE POSSIBLE FOR YOU if you run a larger organisation**. 
In other words: please consider side-effects. Blocking whole countries is a big thing and is probably way too broad for most use-cases.

In addition, these filter lists are very easily circumvented by a knowledgable attacker (they could go via Tor, or proxies etc).

Nevertheless, there might be use-cases where this script might be helpful. The good news is: it's so small that you easily adapt.

# Needed tools

 - bzip2 (Debian package bzip2: high-quality block-sorting file compressor - utilities)
 - jq (Debian package jq: lightweight and flexible command-line JSON processor)
 - iprange (Debian package iprange: optimizing ipsets for iptables)
 - ipset (Debian package ipset: administration tool for kernel IP sets)
   (optional for install-rules-ipset.sh)

# How to use this?

Put it into a crontab script!

First you need to specify the countries which should be blocked: edit ``countries.txt``.
Next, fetch the IP ranges from RIPE stat: ``fetch-ripe-assignments.sh``
Third, insert them into iptables via ipset: ``install-rules-ipset.sh``



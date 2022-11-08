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


# Debian environment

A debian installation uses rules in /etc/iptables/. The directory debian/ provides some files to be placed into /etc/iptables/ with an additional directory named countryblocker containing the this software.

A Makefile provides the management and control of several task.
Calling "make help" shows a summary about paths and usable targets.

To setup the environment as prerequisite package ``netfilter-persistent`` and ``m4`` should be already installed.

The files ``rules.v4`` and ``rules.v6`` are derived from the M4 macro templates ``rules.v4.m4`` and ``rules.v6.m4`` which are
provided as samples. You have to adapt these to meet your environment and service portfolio.
The M4 templates refer to rule snippets called ``add.v4``, ``head.v4`` and ``add.v6``, ``head.v6`` created by script ``gen-rules.sh`` (to be called regularly by cron) which is expected to reside in sub-directory ``countryblocker`` (in company with the remainder of this package).

Optional one might create IPtable statistics (daily, weekly or whatever interval is considered as useful) using `make cron.stats` (in short described in make help). The history is stored in the sub-directory ``statistics`` with files named according to the pattern ``iptables-stats.YYYY-MM-DD`` containing the packet and byte counters of all rules.



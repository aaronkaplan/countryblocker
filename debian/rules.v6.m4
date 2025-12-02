*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:FW1 - [0:0]
include(`countryblocker/head.v6')dnl
-A INPUT -j FW1
-A FORWARD -j FW1
-A FW1 -i lo -j ACCEPT
-A FW1 -p icmp -m icmp --icmp-type any -j ACCEPT
-A FW1 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FW1 -m state --state INVALID -j DROP
-A FW1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
-A FW1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
-A FW1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -j DROP
-A FW1 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
-A FW1 -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
-A FW1 -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP

# Allow SMTP, HTTP, IMAP, HTTPS, SUBMISSION and IMAPS
-A FW1 -p tcp -m tcp --dport 22 -j ACCEPT
-A FW1 -p tcp -m tcp --dport 25 -j ACCEPT
-A FW1 -p tcp -m tcp --dport 80 -j ACCEPT
-A FW1 -p tcp -m tcp --dport 110 -j ACCEPT
-A FW1 -p tcp -m tcp --dport 143 -j ACCEPT
-A FW1 -p tcp -m tcp --dport 443 -j ACCEPT
-A FW1 -p tcp -m tcp --dport 587 -j ACCEPT
-A FW1 -p tcp -m tcp --dport 993 -j ACCEPT
-A FW1 -p tcp -m tcp --dport 995 -j ACCEPT

# Drop the rest
-A FW1 -j LOG --log-prefix "Rejected packet: "
#-A FW1 -j REJECT --reject-with icmp-host-prohibited

include(`countryblocker/add.v6')dnl

COMMIT


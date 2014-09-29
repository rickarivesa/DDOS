#/sbin.sh
#limit the number of incoming tcp connections
/sbin/iptables -N syn_flood
/sbin/iptables -A INPUT -p tcp --tcp-flags SYN,ACK SYN -j syn_flood
/sbin/iptables -A syn_flood -m state --state INVALID,UNTRACKED, -j REJECT
/sbin/iptables -A syn_flood -m connlimit --connlimit-above 1 -j REJECT
/sbin/iptables -A syn_flood -m hashlimit --hashlimit 20/s --hashlimit-mode dstip,dstport --hashlimit-name hosts --hashlimit-burst 1
/sbin/iptables -A syn_flood -m limit --limit 1/100s --liimit-burst 1 -j RETURN
/sbin/iptables -A syn_flood -p tcp -m tcpmss --mss -:500

#limit the incoming udp-flood protection
/sbin/iptables -N udp_flood
/sbin/iptables -A INPUT -p udp --dport 11111 -j udp_flood
/sbin/iptables -A INPUT -f -j DROP
/sbin/iptables -A udp_flood -m length --length 0:58 -j REJECT
/sbin/iptables -A udp_flood -m length --length 2401:65535 -j REJECT

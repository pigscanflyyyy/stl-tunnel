#!/bin/bash
#stl (Wegare)
case $1 in
"stop")
	iptables -t nat -F REDSOCKS
	iptables -t nat -F OUTPUT
	iptables -t nat -F PREROUTING
	echo "Internet Disconnected"
	killall redsocks
	exit
;;
esac
    echo ""
    iptables -t nat -N REDSOCKS
    #Ignore LANs and some other reserved addresses.
    iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
    iptables -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A REDSOCKS -d 10.10.1.0/22 -j RETURN
    iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
    iptables -t nat -A REDSOCKS -d 169.254.0.0/16 -j RETURN
    iptables -t nat -A REDSOCKS -d 172.16.0.0/12 -j RETURN
    iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A REDSOCKS -d 224.0.0.0/4 -j RETURN
    iptables -t nat -A REDSOCKS -d 240.0.0.0/4 -j RETURN
    iptables -t nat -A REDSOCKS -d 202.152.240.50/32 -j RETURN
    iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
    iptables -t nat -A PREROUTING -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A PREROUTING -p tcp -j REDIRECT --to-ports 12345
    iptables -t nat -A OUTPUT -j REDSOCKS
    redsocks -c /etc/redsocks.conf > /dev/null &
    echo "Internet Connected"




#!/bin/bash
#stl (Wegare)
udp="$(cat /root/.ssh/config | grep -i udpgw | cut -d= -f2)" 
host="$(cat /root/akun/ssl.conf | grep -i connect | head -n1 | awk '{print $3}' | cut -d: -f1)" 
route="$(route -n | grep -i 192 | head -n1 | awk '{print $2}')" 
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
    echo "is connecting to the internet"
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
    iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
    iptables -t nat -I OUTPUT -p tcp -j REDSOCKSS
    iptables -t nat -I PREROUTING -p tcp -s 10.0.0.2 -j REDSOCKS
    redsocks -c /etc/redsocks.conf > /dev/null &
    sleep 1
    screen -d -m badvpn-tun2socks --tundev tun1 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp &
    route add 1.1.1.1 gw $route metric 4
    route add 1.0.0.1 gw $route metric 4
    route add $host gw $route metric 4
    route add default gw 10.0.0.2 metric 6
    sleep 10
    echo "Internet Connected"
    sed -i '/^# BEGIN STL/,/^# END STL/d' /etc/crontabs/root > /dev/null 2>&1 &
    /etc/init.d/cron restart



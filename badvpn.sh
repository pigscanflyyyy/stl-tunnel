#!/bin/bash
#stl (Wegare)
udp="$(cat /root/.ssh/config | grep -i udpgw | cut -d= -f2)" 
host="$(cat /root/akun/ssl.conf | grep -i connect | head -n1 | awk '{print $3}' | cut -d: -f1)" 
route="$(route -n | grep -i 192 | head -n1 | awk '{print $2}')" 
screen -d -m badvpn-tun2socks --tundev tun1 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp &
route add 1.1.1.1 gw $route metric 4
route add 1.0.0.1 gw $route metric 4
route add $host gw $route metric 4
route add default gw 10.0.0.2 metric 6
sleep 5



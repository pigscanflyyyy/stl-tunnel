#!/bin/bash
#stl (Wegare)
clear
echo "Inject SSL by wegare"
echo "1. Sett Profile"
echo "2. Start Inject"
echo "3. Stop Inject"
echo "4. Enable booting"
echo "5. Disable booting"
echo "e. exit"
read -p "(default tools: 2) : " tools
[ -z "${tools}" ] && tools="2"
if [ "$tools" = "1" ]; then
read -p "Masukkan host/ip : " host
read -p "Masukkan port : " port
read -p "Masukkan bug : " bug
read -p "Masukkan port udpgw : " udp
read -p "Masukkan user : " user
read -p "Masukkan pass : " pass
echo "[SSH]
client = yes
accept = localhost:69
connect = $host:$port
sni = $bug" > ~/akun/ssl.conf
echo "#udpgw=$udp
#pass=$pass
Host ssl*
    PermitLocalCommand yes
    LocalCommand gproxy %h
    DynamicForward 1080
    StrictHostKeyChecking no
    ServerAliveInterval 10
    TCPKeepAlive yes
Host ssl1
    HostName 127.0.0.1
    Port 69
    User $user" > ~/.ssh/config
echo "Sett Profile Sukses"
sleep 2
clear
stl
elif [ "${tools}" = "2" ]; then
cek="$(ls ~/.ssh/ | grep -i know | cut -d_ -f1)" 
if [ "$cek" = "known" ]; then
rm -f ~/.ssh/known*
fi
ip tuntap add dev tun1 mode tun
ifconfig tun1 10.0.0.1 netmask 255.255.255.0
clear
pass="$(cat ~/.ssh/config | grep -i pass | cut -d= -f2)" 
udp="$(cat ~/.ssh/config | grep -i udpgw | cut -d= -f2)" 
host="$(cat ~/akun/ssl.conf | grep -i connect | head -n1 | awk '{print $3}' | cut -d: -f1)" 
route="$(route -n | grep -i 192 | head -n1 | awk '{print $2}')" 
stunnel ~/akun/ssl.conf
sshpass -p $pass ssh -N ssl1 &
sleep 35
screen -d -m badvpn-tun2socks --tundev tun1 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp &
route add 1.1.1.1 gw $route metric 4
route add 1.0.0.1 gw $route metric 4
route add $host gw $route metric 4
route add default gw 10.0.0.2 metric 6
elif [ "${tools}" = "3" ]; then
host="$(cat ~/akun/ssl.conf | grep -i connect | head -n1 | awk '{print $3}' | cut -d: -f1)" 
route="$(route -n | grep -i 192 | head -n1 | awk '{print $2}')" 
killall screen
gproxy stop
killall stunnel
killall ssh
route del 1.1.1.1 gw $route metric 4
route del 1.0.0.1 gw $route metric 4
route del $host gw $route metric 4
route del default gw 10.0.0.2 metric 6
ip link delete tun1
killall dnsmasq
/etc/init.d/dnsmasq start > /dev/null
sleep 2
echo "Stop Suksess"
sleep 2
clear
stl
elif [ "${tools}" = "4" ]; then
echo "belum tersedia"
exit
host="$(cat ~/akun/ssl.conf | grep -i connect | head -n1 | awk '{print $3}' | cut -d: -f1)" 
route="$(route -n | grep -i 192 | head -n1 | awk '{print $2}')" 
sed -i 's/exit 0/ /g' /etc/rc.local
echo "# BEGIN STL
route del 8.8.8.8 gw $route metric 4
route del $host gw $route metric 4
route del default gw 10.0.0.2 metric 6
printf '2' | stl
# END STL
exit 0" >> /etc/rc.local
echo "Enable Suksess"
sleep 2
clear
stl
elif [ "${tools}" = "5" ]; then
echo "belum tersedia"
exit
sed -i "/^# BEGIN STL/,/^# END STL/d" /etc/rc.local
echo "Disable Suksess"
sleep 2
clear
stl
elif [ "${tools}" = "e" ]; then
clear
exit
else 
echo -e "$tools: invalid selection."
exit
fi
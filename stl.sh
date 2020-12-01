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
read -p "(default tools: 2):" tools
[ -z "${tools}" ] && tools="2"
if [ "$tools" = "1" ]; then
mkdir -p ~/akun/
mkdir -p ~/.ssh/
touch ~/akun/ssl.conf
read -p "Masukkan host/ip" host
read -p "Masukkan port" port
read -p "Masukkan bug" bug
read -p "Masukkan port udpgw" udp
read -p "Masukkan user" user
read -p "Masukkan pass" pass
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
ip tuntap add dev tun0 mode tun
ifconfig tun0 10.0.0.1 netmask 255.255.255.0 up
route add $host gw 192.168.8.1 metric 4
route add default gw 10.0.0.2 metric 6
echo "Sett Profile Sukses"
sleep 0.8
clear
stl
elif [ "${tools}" = "2" ]; then
pass="$(cat ~/.ssh/config | grep -i pass | cut -d= -f2)" 
udp="$(cat ~/.ssh/config | grep -i udpgw | cut -d= -f2)" 
stunnel ssl.conf
sshpass -p $pass ssh -N ssl1 &
badvpn-tun2socks --tundev tun0 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp &
elif [ "${tools}" = "3" ]; then
gproxy stop && killall stunnel && killall ssh
echo "Stop Suksess"
sleep 0.8
clear
stl
elif [ "${tools}" = "4" ]; then
sed -i 's/exit 0/ /g' /etc/rc.local
host="$(cat ~/akun/ssl.conf | grep -i connect | head -n1 | cut -d: -f1 | sed 's/ //g')" 
pass="$(cat ~/.ssh/config | grep -i pass | cut -d= -f2)" 
udp="$(cat ~/.ssh/config | grep -i udpgw | cut -d= -f2)" 
echo "# BEGIN STL
ip tuntap add dev tun0 mode tun
ifconfig tun0 10.0.0.1 netmask 255.255.255.0 up
route add $host gw 192.168.8.1 metric 4
route add default gw 10.0.0.2 metric 6
stunnel ssl.conf
sshpass -p $pass ssh -N ssl1 &
badvpn-tun2socks --tundev tun0 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp &
# END STL
exit 0" >> /etc/rc.local
echo "Enable Suksess"
sleep 0.8
clear
stl
elif [ "${tools}" = "5" ]; then
sed -i "/^# BEGIN STL/,/^# END STL/d" /etc/rc.local
echo "Disable Suksess"
sleep 0.8
clear
stl
elif [ "${tools}" = "e" ]; then
clear
exit
else 
echo -e "$tools: invalid selection."
exit
fi
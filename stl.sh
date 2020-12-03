#!/bin/bash
#stl (Wegare)
clear
echo "Inject SSL by wegare"
echo "1. Sett Profile"
echo "2. Start Inject"
echo "3. Stop Inject"
echo "4. Enable auto booting & auto rekonek"
echo "5. Disable auto booting & auto rekonek"
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
sni = $bug" > /root/akun/ssl.conf
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
    User $user" > /root/.ssh/config
echo "Sett Profile Sukses"
sleep 2
clear
stl
elif [ "${tools}" = "2" ]; then
cek="$(ls /root/.ssh/ | grep -i know | cut -d_ -f1)" 
if [ "$cek" = "known" ]; then
rm -f /root/.ssh/known*
fi
ip tuntap add dev tun1 mode tun
ifconfig tun1 10.0.0.1 netmask 255.255.255.0
clear
udp="$(cat /root/.ssh/config | grep -i udpgw | cut -d= -f2)" 
host="$(cat /root/akun/ssl.conf | grep -i connect | head -n1 | awk '{print $3}' | cut -d: -f1)" 
route="$(route -n | grep -i 192 | head -n1 | awk '{print $2}')" 
pass="$(cat /root/.ssh/config | grep -i pass | cut -d= -f2)" 
stunnel /root/akun/ssl.conf
sleep 1
sshpass -p $pass ssh -o 'GatewayPorts yes' -N ssl1 &
elif [ "${tools}" = "3" ]; then
host="$(cat /root/akun/ssl.conf | grep -i connect | head -n1 | awk '{print $3}' | cut -d: -f1)" 
route="$(route -n | grep -i 192 | head -n1 | awk '{print $2}')" 
killall screen
gproxy stop
killall ssh
killall stunnel
route del 8.8.8.8 gw $route metric 4
route del 8.8.4.4 gw $route metric 4
route del $host gw $route metric 4
ip link delete tun1
killall dnsmasq
/etc/init.d/dnsmasq start > /dev/null
sleep 2
echo "Stop Suksess"
sleep 2
clear
stl
elif [ "${tools}" = "4" ]; then
echo "#!/bin/bash
#stl (Wegare)
cat <<EOF>> /etc/crontabs/root
# BEGIN AUTORESTARTSTL
*/2 * * * * (printf '3\n'; sleep 10; printf '\n') | stl
# END AUTORESTARTSTL
EOF
/etc/init.d/cron restart" > /usr/bin/autostart-stl
chmod +x /usr/bin/autostart-stl

echo "#!/bin/bash
#stl (Wegare)
route=$(route | grep -i default | grep -i 192| head -n1 | awk '{print $2}')
while true
do
echo $route
	if [[ -z $route ]]; then
		while true
		do
		if [[ null != $route ]]; then
		   (printf '3\n'; sleep 10; printf '\n') | stl	
		   sleep 60
		   exit
		fi
		sleep 1
		done
	   sleep 1
        exit
	fi
	sleep 1
done" > /usr/bin/autorekonek-stl
chmod +x /usr/bin/autorekonek-stl

cat <<EOF>> /etc/crontabs/root
# BEGIN AUTOREKONEKSTL
* * * * *  autorekonek-stl
# END AUTOREKONEKSTL
EOF


sed -i 's/exit 0/ /g' /etc/rc.local
echo "# BEGIN STL
autostart-stl
# END STL" >> /etc/rc.local

echo "Enable Suksess"
sleep 2
clear
stl
elif [ "${tools}" = "5" ]; then
sed -i "/^# BEGIN AUTORESTARTSTL/,/^# END AUTORESTARTSTL/d" /etc/rc.local
sed -i "/^# BEGIN AUTOREKONEKSTL/,/^# END AUTOREKONEKSTL/d" /etc/rc.local
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
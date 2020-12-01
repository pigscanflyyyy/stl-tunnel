#!/bin/bash
#stl (Wegare)
wget -O ~/badvpn.ipk "https://github.com/wegare123/stl-tunnel/blob/main/badvpn_1.999.130-1_aarch64_cortex-a53.ipk?raw=true"
wget -O /usr/bin/stl "https://raw.githubusercontent.com/wegare123/stl-tunnel/main/stl.sh"
opkg update && opkg install openssh-client && opkg install stunnel && opkg install redsocks && opkg install badvpn.ipk
/etc/init.d/stunnel disable
/etc/init.d/redsocks disable
echo "base {
    log_debug = off;
    log_info = on;
    daemon = on;
    redirector = iptables;
}
redsocks {
    local_ip = 0.0.0.0;
    local_port = 12345;
    ip = 127.0.0.1;
    port = 1080;
    type = socks4;
}
redudp {
    local_ip = 127.0.0.1;
    local_port = 10053;
    ip = 127.0.0.1;
    port = 1080;
    dest_ip = 8.8.8.8;
    dest_port = 53;

    udp_timeout = 30;
    udp_timeout_stream = 180;
}
dnstc {
    local_ip = 127.0.0.1;
    local_port = 5300;
}" > /etc/redsocks.conf
echo '#!/bin/sh
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
    echo "Internet Connected"' > /usr/bin/gproxy
chmod +x /usr/bin/gproxy
rm -r ~/badvpn.ipk
echo "install selesai\n"
echo "untuk memulai tools silahkan jalankan perintah 'stl'"

				
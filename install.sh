#!/bin/bash
#stl (Wegare)
wget -O ~/badvpn.ipk "https://github.com/wegare123/stl-tunnel/blob/main/badvpn_1.999.130-1_aarch64_cortex-a53.ipk?raw=true"
wget -O /usr/bin/stl "https://raw.githubusercontent.com/wegare123/stl-tunnel/main/stl.sh"
wget -O /usr/bin/stl-start "https://raw.githubusercontent.com/wegare123/stl-tunnel/main/stl-start.sh"
wget -O /usr/bin/gproxy "https://raw.githubusercontent.com/wegare123/stl-tunnel/main/gproxy.sh"
wget -O /etc/redsocks.conf "https://raw.githubusercontent.com/wegare123/stl-tunnel/main/redsocks.conf"
opkg update && opkg install ip-full && opkg install openssh-client && opkg install stunnel && opkg install redsocks && opkg install badvpn.ipk
/etc/init.d/stunnel disable
/etc/init.d/redsocks disable
killall redsocks
killall stunnel
chmod +x /usr/bin/gproxy
chmod +x /usr/bin/stl
chmod +x /usr/bin/stl-start
rm -r ~/badvpn.ipk
rm -r ~/install.sh
mkdir -p ~/akun/
mkdir -p ~/.ssh/
touch ~/akun/ssl.conf
clear
echo "install selesai"
echo "untuk memulai tools silahkan jalankan perintah 'stl'"

				
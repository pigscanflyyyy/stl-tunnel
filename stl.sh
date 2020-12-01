#!/bin/bash
#stl (Wegare)
            number_of_clients=$(grep -c '^# BEGIN_SSSO' /etc/akun/akun-ss.txt)
			if [[ "$number_of_clients" = 0 ]]; then
				echo -e "There are no existing clients!"
				exit
			fi
			echo -e "Select the client to remove:"
			grep '^# BEGIN_SSSO' /etc/akun/akun-ss.txt | cut -d ' ' -f 3 | nl -s ') '
			read -p "Pilih No Client: " client_number
			until [[ "$client_number" =~ ^[0-9]+$ && "$client_number" -le "$number_of_clients" ]]; do
			    echo -e "$client_number: invalid selection."
				read -p "Pilih No Client: " client_number
			done
			client=$(grep '^# BEGIN_SSSO' /etc/akun/akun-ss.txt | cut -d ' ' -f 3 | sed -n "$client_number"p)
				# Remove from the configuration file
				sed -i "/^# BEGIN_SSSO $client/,/^# END_SSSO $client/d" /etc/akun/akun-ss.txt
				pid="$(ps -ef | grep ss-server | grep /etc/shadowsocks-libev/${client}.json | awk '{print $2}' | tail -n1)"
				kill -9 "$pid"
				sed -i "/^# BEGIN_SSSO $client/,/^# END_SSSO $client/d" /etc/crontab
				sed -i "/^# BEGIN_SSSO $client/,/^# END_SSSO $client/d" /etc/rc.local
				rm -r /etc/shadowsocks-libev/"$client".json
				echo -e "$client removed!"
				
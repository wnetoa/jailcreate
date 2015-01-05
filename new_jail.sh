#!/usr/local/bin/zsh

DEBUG=1

if [ $1 ] && [ $2 ] && [ $3 ]; then
        jail_name=$1
        jail_ip=$2
        jail_netmask=$3
                echo "ifconfig bce0 $jail_ip netmask $jail_netmask alias"
                alias=$(grep alias /etc/rc.conf | cut -d "=" -f 1 | cut -d "_" -f 3 | cut -c 6-7 | sort -un | tail -1)
                next_alias=$((alias+1))
                echo "echo 'ifconfig_bce0_alias$next_alias=\"inet $jail_ip netmask $jail_netmask\" #$jail_name' >> /etc/rc.conf"

                if [ $4 ]; then
                        jail_flav=$4
                        echo "ezjail-admin create -c zfs -f $jail_flav $jail_name $jail_ip"
                else    
                        echo "ezjail-admin create -c zfs $jail_name $jail_ip"
                        echo
                        echo "kein flavor-name: du willst aber zumindest *das* hier:"
                        echo
                        echo "
- nameserver und search in /etc/resolv.conf
- .zshrc in \$USER_HOME 
- ...                   
                        "
                fi
                
                echo "ezjail-admin start $jail_name"
                echo "jls"
                echo
                echo "what u wanna do after first jexec:"
                echo
                echo "
cd /usr/ports/ports-mgmt/portmaster
make install clean
rehash
portmaster shells/zsh
rehash          
                "

else
  echo
  echo "Usage: new_jail { Name IP-Address Netmask [flavor-name] }"
  echo
fi

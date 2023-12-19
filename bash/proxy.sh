#!/bin/bash
CUSTOMER="AXESS"
customer_community=$(echo "$CUSTOMER""data" | tr '[:upper:]' '[:lower:]')
ip=(192.168.0.1 192.168.0.1)
sed -i "1,/#proxy configuration/!d" /etc/snmp/snmpd.conf

active_dids=""
echo "#proxy configuration ${customer_community}" >> /etc/snmp/snmpd.conf
echo "group ${CUSTOMER}DATA v2c ${customer_community}User" >> /etc/snmp/snmpd.conf
echo "com2sec -Cn ${customer_community} ${customer_community}User default ${customer_community}" >> /etc/snmp/snmpd.conf
echo "access ${CUSTOMER}DATA ${customer_community} v2c noauth exact all none none" >> /etc/snmp/snmpd.conf

for nms in ${ip[@]}
do
    echo $nms
    dids=$(snmpwalk -On -v 2c -c public $nms 1.3.6.1.4.1.13732.1.1.1.1.7 | grep $CUSTOMER | sed 's@.*1.3.6.1.4.1.13732.1.1.1.1.7.@@' | sed 's/=.*//')
    for did in $dids
    do
        name=$(snmpwalk -On -v 2c -c public $nms 1.3.6.1.4.1.13732.1.1.1.1.7.$did | grep $CUSTOMER | sed -n 's/^.*STRING://p')
        state=$(snmpwalk -On -v 2c -c public $nms .1.3.6.1.4.1.13732.1.1.1.1.15.$did | sed -n 's/^.*STRING://p')
        if [[ "$state" == *"Nominal"* ]] || [[ "$state" == *"ChangesPending"* ]]
        then
            echo $name
            active_dids+="${name}: ${did},"
            data=$"### $name\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.1.1.1.1.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.1.1.1.7.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.1.1.1.8.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.1.1.1.12.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.1.1.1.15.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.1.1.1.16.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.2.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.3.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.4.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.5.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.6.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.7.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.8.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.9.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.10.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.11.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.12.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.13.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.1.1.14.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.3.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.4.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.5.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.6.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.10.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.11.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.12.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.13.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.14.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.2.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.3.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.4.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.2.1.7.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.8.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.9.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.11.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.20.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.21.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.22.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.23.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.47.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.48.$did\n 
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.3.1.49.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.4.1.2.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.5.1.3.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.5.1.5.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.5.1.6.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.9.1.4.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.9.1.5.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.11.1.8.$did\n
            proxy -Cn ${customer_community} -v 2c -c public $nms .1.3.6.1.4.1.13732.1.4.11.1.9.$did\n
            "
            echo -ne $data >> /etc/snmp/snmpd.conf
        fi
    done
done
echo "#END ${customer_community}" >> /etc/snmp/snmpd.conf

ulimit -n 1048576

echo -ne "{${active_dids::-1}}" > /etc/snmp/active_proxy.json

systemctl restart snmpd
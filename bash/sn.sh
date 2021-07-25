#!/bin/bash

mount 192.168.100.1:/data/sn /mnt

echo "Where is the delivery place?"
read name

sn=`ipmitool fru |grep -i "product serial" |awk '{print $4}'`
date=`date +%F`

echo -e "${sn} \t ${name}" >> /mnt/$date.txt
cat /mnt/$date.txt

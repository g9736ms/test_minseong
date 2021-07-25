#! /bin/bash

#rpm -Uvh issdcm-3.0.4-1.x86_64.rpm;

hnum=`issdcm -drive_list |grep -A 1 100 |sed -n '/Index/p' |awk '{print $3}' |wc -l`
i=0


while [ $i -lt $hnum ]
do


	x=`issdcm -drive_list |grep -A 1 100 |sed -n '/Index/p' |awk '{print $3}' |head -n 1 |tail -n+1`

	issdcm -drive_index $x -firmware_update XCV10110_XBUB0008_signed.bin;
	i=$(($i+1))

	sleep 10
done

echo "update completed SSD count"
issdcm -drive_list |grep -i 0110 |wc -l

echo "must have update SSD count"
issdcm -drive_list |grep -i 0100 |wc -l

echo "reboot plz"



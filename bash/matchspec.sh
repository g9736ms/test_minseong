#! /bin/bash
#made by minseong.G
#if [ "" = "" ]; then
#
#else
#
#fi
i=0
#read -p "asdf : " asdf

echo "[1] SP7-2104P"
echo "[2] SP7-2212P"
read -p "choose your server : " fser


if [ $fser = 1 ];then
	bios="4.1.4"
	bmc="4.12"
	serbios=`dmidecode -t bios |grep -i "version:" |awk '{print $2}'`
	serbmc=`ipmitool mc info |grep -i "firmware revi"|awk '{print $4}'`
	if [ $bios = $serbios ];then
		statbios="PASS"
	else
		statbios="FAIL"
		erro=$erro+1
	fi

	if [ $bmc = $serbmc ];then
		statbmc="PASS"
	else
		statbmc="FAIL"
		erro=$erro+1	
	fi


elif [ $fser = 2 ];then 
	bios="4.0.8"
	bmc="4.19"
	serbios=`dmidecode -t bios |grep -i "version:" |awk '{print $2}'`
	serbmc=`ipmitool mc info |grep -i "firmware revi"|awk '{print $4}'`
	if [ $bios = $serbios ];then
		statbios="PASS"
	else
		statbios="FAIL"
		erro=$erro+1
	fi

	if [ $bmc = $serbmc ];then
		statbmc="PASS"
	else
		statbmc="FAIL"
		erro=$erro+1	
	fi


fi

serfru=`ipmitool fru |grep -i eslim |wc -l`
if [ "$serfru" -ge "1" ];then
	SERFRU="PASS"
else
	SERFRU="FAIL"
fi

############################
##########INPUT#############
############################

 

read -p "How many cpu(s) are in server? :" cpunum
read -p "What is name of cpu? (ex) 4110 :" cpuname



read -p "What memory size do you have ? (ex) 16GB,32GB >> 16,32 :" memsize
read -p "How many $memsize GB memory do you have?" memnum
read -p "Do you have different size of memory? (y/n) :" memchk
if [ "$memchk" = "y" ] || [ "$memchk" = "Y" ]; then 	
	read -p "What differ memory size?" memsize1
	read -p "What man differ size do U have ?" memnum1
fi


read -p "Do you have nvme? (y/n) : " tnvme
read -p "What type of hard disk? [ex)sas,sata,ssd] : " tdisk   ##put in the file
read -p "What size is it ? [ex)300GB,2TB] : " tdisksize
read -p "How many $tdisksize $tdisk have? " ntdisk
nodisk=0 	#chogiwha 
read -p "Any other disk? (y/n) : " odisk
if [ "$odisk" = "y" ] || [ "$odisk" = "Y" ]; then
	read -p "What type of hard disk? [ex)sas,sata,ssd] : " odisk
	read -p "What size is it ? [ex)300GB,2TB] : " odisksize	
	read -p "How many $odisksize $odisk have? " nodisk 
fi
read -p "Do you have RAID or HBA card? (y/n) :" rcard
if [ "$rcard" = "y" ] || [ "$rcard" = "Y" ]; then 	
	read -p "What kind of card do you have ? ex)3008,3108 :" rcard
	read -p "Any other card? or more $rcard card? (y/n)" rcard1
fi
if [ "$rcard1" = "y" ] || [ "$rcard1" = "Y" ]; then 	
	read -p "What kind of card do you have ? ex)3008,3108 :" rcard1
fi





############################
#########BUNSU##############
############################
erro=0

CPUNUM=`lscpu |grep -i "socket(s)" |awk '{print $2}'`
CPUNAME=`lscpu |grep -i "model name" |grep -i $cpuname |awk '{print $6}' `


MEMNUMM=`ipmitool sdr type memory |grep -i Presence |wc -l`
MEMSIZE=`dmidecode -t memory |grep -i "Size: $memsize"|wc -l`
MEMNUM=`dmidecode -t memory |grep -i "Size: $memsize"|wc -l`
if [ "$memchk" = "y" ] || [ "$memchk" = "Y" ]; then	
	MEMSIZE1=`dmidecode -t memory |grep -i "Size: $memsize1"|wc -l`
	MEMNUM1=`dmidecode -t memory |grep -i "Size: $memsize1"|wc -l`
fi



if [ "$tnvme" = "y" ] || [ "$tnvme" = "Y" ]; then
	echo "#####check your disk size#####"	
	nvme -list
	read -p "is it right?(y/n)" SDISK
	if [ "$SDISK" = "y" ] || [ "$rcard" = "Y" ]; then 
		SDISK="PASS"
	else
		SDISK="FAIL"
		let erro=$erro+1
	fi
fi
if [ "$rcard" = "n" ] || [ "$rcard" = "N" ]; then 
	echo "#####check your disk size#####"	
	SRCARD=`lsblk |grep -i disk |awk '{print $4}' |wc -l`
	while [ $i -lt $SRCARD ]
	do
	let i=$i+1
		a=`lsblk |grep -i disk |awk '{print $4}' |head -n $i|tail -n+$i`
		b=`cat /proc/scsi/scsi |grep -i vendor |awk '{print $4}'|head -n $i |tail -n+$i`
		c=`cat /proc/scsi/scsi |grep -i vendor |awk '{print $7}'|head -n $i |tail -n+$i`
		echo -e "size \t vendor \t firmware "
		echo -e "$a \t $b \t\t $c"
	done
	echo "#####check the quantity of hard#####"
	lsblk |grep -i disk |awk '{print $4}'|wc -l	
	read -p "is it right? (y/n) : " SSDISK
	if [ "$SSDISK" = "y" ] || [ "$rcard" = "Y" ]; then 
		SSDISK="PASS"
	else
		SSDISK="FAIL"
		let erro=$erro+1
	fi
elif [ "$rcard" = "3008" ]; then

let totaldisk=$ntdisk+$nodisk
	echo "#####check your FirmWare and model#####"
	echo -e "vendor \t firmware "
	while [ $i -lt $totaldisk ]
	do
		let i=$i+1
		j=2
		a=`sas3ircu 0 display |grep -i firm |awk '{print $4}'|head -n $j |tail -n+$j`
		b=`sas3ircu 0 display |grep -i model|awk '{print $4}'|head -n $i |tail -n+$i`
		let j=$j+1
		echo -e "$b \t\t $a"
		
		
	done
#	echo "#####check your Raid level#####"
#	sas3ircu 0 display |grep -i "raid level"
#	echo "#####check your FirmWare#####"
#	sas3ircu 0 display |grep -i firm
#	echo "#####check your raid volume size#####"	
#	lsblk |grep -i disk |awk '{print $4}'
	echo "#####Check the quantity of hard#####"
	sas3ircu 0 display |grep -i "drive type" |wc -l
	FIRMCARD=`sas3ircu 0 display |grep -i "16.00.00"`
	echo "##### Card firmware #####"
	echo $FIRMCARD
	read -p "is it right? (y/n) : " SDISK
		if [ "$SDISK" = "y" ] || [ "$rcard" = "Y" ]; then 
			SDISK="PASS"
		else
			SDISK="FAIL"
			let erro=$erro+1
		fi
	FIRMCARD=`sas3ircu 0 display |grep -i "16.00.00"|wc -l`
	if [ "$FIRMCARD" -ge "1" ]; then
		firmcard="PASS"
	else
		firmcard="FAIL"
		let erro=$erro+1
	fi
fi

#elif [ "$rcard" = "3108" ]; then
#	cd /opt/MegaRAID/storcli
#	./storcli64 /c0 show all |grep -i "raid level"
#	./storcli64 /c0 show all |grep -i ugood
#	./storcli64 /c0 show all |grep -i ugood |wc -l
#	 




############################
##########YUNSAN############
############################
####server####
#if [ "$server" = "sp7-2104p" ]; then
#
#fi


####cpu####
if [ "$CPUNUM" = "$cpunum" ]; then
	CPUNUM="PASS"
else
	let erro=$erro+1
	CPUNUM="FAIL"
fi

if [ "$CPUNAME" = "$cpuname" ]; then
	CPUNAME="PASS"
else
	let erro=$erro+1
	CPUNAME="FAIL"
fi

####memory####
if [ "$memchk" = "y" ] || [ "$memchk" = "Y" ]; then
	if [ "$MEMNUM" = "$MEMSIZE" ] && [ "$MEMNUM1" = "MEMSIZE1" ]; then
		MEMSIZE="PASS"
	else
		MEMSIZE="FAIL"
	fi

elif [ "$MEMNUM" = "$MEMSIZE" ]; then
	MEMSIZE="PASS"
else
	MEMSIZE="FAIL"
	let erro=$erro+1
fi

if [ "$memchk" = "y" ] || [ "$memchk" = "Y" ]; then
	let MEMNUN=$memnum+$memnum1
	
	if [ "$MEMNUMM" = "$MEMNUM" ]; then
		MEMNUM="PASS"
	else
		MEMNUM="FAIL"
		let erro=$erro+1
	fi

elif [ "$memnum" = "$MEMNUM" ]; then
	MEMNUM="PASS"

else
	MEMNUM="FAIL"
	let erro=$erro+1		

fi




echo "#####SERVER FirmWarer status#####"
echo "BIOS	: $statbios"
echo "BMC	: $statbmc"
echo "FRU	: $SERFRU"


############################
########OUTPUT##############
############################
echo "#####  SERVER  STATUS  #####"
echo "CPU Quantity 	: $CPUNUM"
echo "CPU Kind     	: $CPUNAME"
echo "mem size     	: $MEMSIZE"
echo "mem Quantity 	: $MEMNUM"
echo "Hard Disk    	: $SSDISK"
if [ "$tnvme" = "y" ] || [ "$tnvme" = "Y" ]; then
	echo "NVME status  	: $SDISK"
fi
if [ "$rcard" = "3008" ]; then 
echo "$rcard card firm	: $firmcard"
fi


if [ "$erro" = "0" ]; then
	#D=`date +%F`
	#mount 192.168.100.1:/data/sn /sn
	echo "server status is good"
	#echo "$cpuname *$cpunum / $memsize *$memnum / " >> /sn/$D_spec.txt
else
	echo "###!!!!!!!ERRO!!!!!!!###"
	echo "U have $erro erro"
fi

#어떤 장비에 어떤 HW가 있는지 기록해주는 스크립트
# 장비 이름 || 일자             || 생상날짜 || 시리얼 ||
# "$pname ||  `date +%Y-%m-%d` || $deli   || $seri  || 
#CPU랑 메모리 각종 카드 등등등 나열
#$cpuname *$cpuqty / $memory $mem_type $lsi3108 $sas3008ir $sas3008it $onhardall $hard3008all $nvMeall $hard3008tall $hard3108all $plus3108a $oncard $i350t $x540t $connX $hba16g $hba8g $gpuall"
#date +%y-%m.txt 이쪽 파일로 저장이된다.
# >> `date +%y-%m.txt`

 
#!/bin/bash
echo " runing . . . . ."
#made by minseong

#delivery
#cpu; 
#meminfo; 
#onbor; 
#server; 
#i350; 
#x540;
#connectx; 
#hba; 
#card3008; 
#hard; 
#onhardchek; 
#nvME;

server(){
#echo "name in"
pname=`ipmitool fru |grep 'Product Name'| head -n1 |awk '{print $4}'`
}
 
cpu(){
#echo "cpu in"
cpuname=`dmidecode |grep -i cpu |grep Intel| head -n1  |awk '{print $4,$5}'` #cpu name
cpuqty=`dmidecode |grep -i cpu |grep -c "$cpuname"`  #cpu qty
}

 

onbor(){
#echo "onbord nic in"
oncardall=`dmidecode |grep -ic "Onboard X722 NIC*"`  #phy10G-2 / 1G - 4
if [ "$oncardall" != "0" ];then
if [ $oncardall = "2" ];then
oncard=`echo "/ 10Gb DP PHY *1"`
elif [ $oncardall = "4" ];then
oncard=`echo "/ 1Gb QP PHY *1"`
fi
fi
}
delivery(){
#echo "date in"
read -p " where is server delivered ? : " deli
}

meminfo(){

#echo "memory in"
local i=1
local j=2
memqty0=1
memqty1=0

memqty=`dmidecode |grep "Size: ..... MB" |awk '{print $2}'|sed 's/...$//'|grep -v Si |wc -l` #mem  all qty
mem0=`dmidecode |grep "Size: ..... MB" |awk '{print $2}'|sed 's/...$//'|grep -v Si |head -n1 |tail -n1`

if [ "$memqty" != "0" ];then
while [ "$i" -lt "$memqty" ] 
do
mem1=`dmidecode |grep "Size: ..... MB" |awk '{print $2}'|sed 's/...$//'|head -n+$j |tail -n+$j`
if [ "$mem0" = "$mem1" ]; then
memsize0=$mem0
let memqty0=$memqty0+1
elif [ "$mem0" != "$mem1" ]; then
memsize1=$mem1
let memqty1=$memqty1+1
fi

let i=$i+1
let j=$j+1
done

if [ "$memqty1" = "0" ];then
memory=`echo "$memsize0 GB DDR4 *$memqty0"`
else
memory=`echo "$memsize0 GB DDR4 *$memqty0" / $memsize1 GB DDR4 *$memqty1`

fi

if [ -z "$memsize0" ];then #one memory
memsize0=`dmidecode |grep "Size: ..... MB" |awk '{print $2}'|sed 's/...$//'`
memory=`echo "$memsize0 GB DDR4 *1"`
fi

elif [ "$memqty" = "0" ];then
memqty0=1
memqty1=0
memqty=`dmidecode |grep "Size: .. GB" |grep -v Range |awk '{print $2}' |wc -l` #mem  all qty
mem0=`dmidecode |grep "Size: .. GB"|grep -v Range |awk '{print $2}'|head -n1 |tail -n1` 
i=1
memsize0=$mem0
while [ "$i" -lt "$memqty" ] 
do
mem1=`dmidecode |grep "Size: .. GB"|grep -v Range |awk '{print $2}'|head -n+$j |tail -n+$j`

if [ "$mem0" = "$mem1" ]; then
memsize0=$mem0
let memqty0=$memqty0+1
elif [ "$mem0" != "$mem1" ]; then
memsize1=$mem1
let memqty1=$memqty1+1
fi

let i=$i+1
let j=$j+1
done

if [ "$memqty1" = "0" ];then
memory=`echo "$memsize0 GB DDR4 *$memqty0"`
else
memory=`echo "$memsize0 GB DDR4 *$memqty0" / $memsize1 GB DDR4 *$memqty1`

fi

if [ -z "$memsize0" ];then #one memory
memsize0=`dmidecode |grep "Size: .. GB" |grep -v Range |awk '{print $2}'`
memory=`echo "$memsize0 GB DDR4 *1"`
fi

fi

mem_dimm=`dmidecode -t 17 |grep Part |grep -v "NO DIMM"|awk '{print $3}'|head -n1`
#mem_dimm_qty=`dmidecode -t 17 |grep Part |grep -vc "NO DIMM"`
mem_dimm_qty=`dmidecode -t 17 |grep -ic "$mem_dimm "`
mem_type="($mem_dimm *$mem_dimm_qty)"

mem_dimm_qty=`dmidecode -t 17 |grep Part |grep -v "NO DIMM" |grep -vc "$mem_dimm"`

if [ "$mem_dimm_qty" != "0" ];then
mem_dimm1=`dmidecode -t 17 |grep Part |grep -v "NO DIMM" |grep -v "$mem_dimm" |awk '{print $3}'|head -n1`
mem_dimm_qty=`dmidecode -t 17 |grep -c "$mem_dimm1"`
mem_type="$mem_type/($mem_dimm1 *$mem_dimm_qty)" 
fi
 
}

i350(){
#echo "i350 in "
i350all=`lspci |grep -ic i350`
if [ "$i350all" != "0" ]; then
i350t2=`lspci |grep -i i350 |awk '{print $1}' | sed 's/......//' |grep -ic 0`
i350t4=`lspci |grep -i i350 |awk '{print $1}' | sed 's/......//' |grep -ic 3`

let i350t2=$i350t2-$i350t4

if [ "$i350t4" = "0" ];then
i350t=`echo "/ i350-T2 *$i350t2"`
elif [ "$i350t2" = "0" ];then
i350t=`echo "/ i350-T4 *$i350t4"`
else
i350t=`echo "/ i350-T2 *$i350t2 / i350-T4 *$i350t4"`
fi
fi
}
x540(){
#echo "x540 in"
x540all=`lspci |grep -ic x540`
if [ "$x540all" != "0" ]; then
x540t2=`lspci |grep -ic x540`
let x540t2=x540t2/2
x540t=`echo "/ X540-T2 *$x540t2"`
fi
}


connectx(){
#echo "10G DP NIC in"
conn=`lspci |grep -ic 'connectX-4'`
if [ "$conn" != "0" ]; then
dp10g=`lspci |grep -i 'connectx-4' |awk '{print $1}' | sed 's/......//' |grep -ic 0`
qp10g=`lspci |grep -i 'connectx-4' |awk '{print $1}' | sed 's/......//' |grep -ic 3`

let dp10g=$dp10g-$qp10g

if [ "$qp10g" = "0" ];then
connX=`echo "/ Mellanox 10G DP NIC *$dp10g"`
elif [ "$dp10g" = "0" ];then
connX=`echo "/ Mellanox 10G QP NIC *$qp10g"`
else
connX=`echo "/ Mellanox 10G DP NIC *$dp10g / Mellanox 10G QP NIC *$qp10g"`

fi
fi
}

hba(){
#echo "hba in"
hball=`lspci |grep -ic emulex`
if [ "$hball" != "0" ];then
hba16g=`hbacmd listhbas| grep -ic 'LPe16002B-M6'`
if [ "$hba16g" != "0" ];then
let hba16g=$hba16g/2
hba16g=`echo "/ Emulex 16G HBA *$hba16g"`
fi
hba8g=`hbacmd listhbas| grep -ic 'LPe12002'`
if [ "$hba8g" != "0" ];then
let hba8g=$hba8g/2
hba8g=`echo "/ Emulex 8G HBA *$hba8g"`
fi
fi
}

card3008(){
#echo "3008 in"
c3008=`lspci |grep -c 3008`
local i=0
if [ "$c3008" != "0" ]; then
#sas3008ir=`sas3ircu list |grep -ic "sas3ir"`
#sas3008it=`sas3ircu list |grep -ic "sas3it"`
sas3008ir=`sas3ircu 0 display |grep -i "raid support"|grep -ic yes`
sas3008it=`sas3ircu 1 display |grep -i "raid support"|grep -ic no`

if [ "$sas3008ir" = "1" ]; then
sas3008ir=`echo '/ LSI3008IR *1'`
elif [ "$sas3008ir" = "2" ]; then
sas3008ir=`echo '/ LSI3008IR *2'`
elif [ "$sas3008ir" = "0" ]; then
sas3008ir=""
fi

if [ "$sas3008it" = "1" ]; then
sas3008it=`echo '/ LSI3008IT *1'`
elif [ "$sas3008it" = "2" ]; then
sas3008it=`echo '/ LSI3008IT *2'`
elif [ "$sas3008it" = "0" ]; then
sas3008it=""
fi

hard3008=`sas3ircu 0 display |grep -i "model number"|grep -vc Cub`
until [ "$hard3008" = "0" ];
do
case $i in
0)
hard3008_0=`sas3ircu 0 display |grep -i "model number" |awk '{print $4 ,$5}'|head -n1|tail -n1`
hard3008qty0=`sas3ircu 0 display |grep -ic "$hard3008_0"`
hard3008all=`echo "/ $hard3008_0 *$hard3008qty0"`
let hard3008=$hard3008-$hard3008qty0
;;
1)
  hard3008_1=`sas3ircu 0 display |grep -i "model number"|awk '{print $4 ,$5}'|grep -v "$hard3008_0" |head -n1|tail -n1`
 
hard3008qty1=`sas3ircu 0 display |grep -ic "$hard3008_1"`
  hard3008all=`echo "/ $hard3008_0 *$hard3008qty0 / $hard3008_1 *$hard3008qty1"`
 
  let hard3008=$hard3008-$hard3008qty1
  ;;
2)
  hard3008_2=`sas3ircu 0 display |grep -i "model number" |awk '{print $4 ,$5}'|grep -ve "$hard3008_0" -e "$hard3008_1"|head -n1|tail -n1`
  hard3008qty2=`sas3ircu 0 display |grep -ic "$hard3008_2"`

  hard3008all=`echo "/ $hard3008_0 *$hard3008qty0 / $hard3008_1 *$hard3008qty1 / $hard3008_2 *$hard3008qty2"`
 
  let hard3008=$hard3008-$hard3008qty2
  ;;
  3)
  hard3008_3=`sas3ircu 0 display |grep -i "model number" |awk '{print $4 ,$5}'|grep -ve "$hard3008_0" -e "$hard3008_1" -e "$hard3008_3"|head -n1|tail -n1`
  hard3008qty3=`sas3ircu 0 display |grep -ic "$hard3008_3"`
 
  hard3008all=`echo "/ $hard3008_0 *$hard3008qty0 / $hard3008_1 *$hard3008qty1 / $hard3008_2 *$hard3008qty2 / $hard3008_3 *$hard3008qty3"`
 
  let hard3008=$hard3008-$hard3008qty3
  ;;

esac
let i=$i+1
done

local i=0
hard3008t=`sas3ircu 1 display |grep -ic "model number"`
if [ "$hard3008t" != "0" ]; then
until [ "$hard3008t" = "0" ];
do
case $i in
0)
hard3008t_0=`sas3ircu 1 display |grep -i "model number" |awk '{print $4 ,$5}'|head -n1|tail -n1`
hard3008tqty0=`sas3ircu 1 display |grep -ic "$hard3008t_0"`

hard3008tall=`echo "/ $hard3008t_0 *$hard3008tqty0"`

let hard3008t=$hard3008t-$hard3008tqty0
;;
1)
hard3008t_1=`sas3ircu 1 display |grep -i "model number"|awk '{print $4 ,$5}'|grep -v "$hard3008t_0" |head -n1|tail -n1`
hard3008tqty1=`sas3ircu 1 display |grep -ic "$hard3008t_1"`

hard3008tall=`echo "/ $hard3008t_0 *$hard3008tqty0 / $hard3008t_1 *$hard3008tqty1"`

let hard3008t=$hard3008t-$hard3008tqty1
;;
2)
hard3008t_2=`sas3ircu 1 display |grep -i "model number" |awk '{print $4 ,$5}'|grep -ve "$hard3008t_0" -e "$hard3008t_1"|head -n1|tail -n1`
hard3008tqty2=`sas3ircu 1 display |grep -ic "$hard3008t_2"`

hard3008tall=`echo "/ $hard3008t_0 *$hard3008tqty0 / $hard3008t_1 *$hard3008tqty1 / $hard3008t_2 *$hard3008tqty2"`

let hard3008t=$hard3008t-$hard3008tqty2
;;
3)
hard3008t_3=`sas3ircu 1 display |grep -i "model number" |awk '{print $4 ,$5}'|grep -ve "$hard3008t_0" -e "$hard3008t_1" -e $hard3008t_3|head -n1|tail -n1`
hard3008tqty3=`sas3ircu 1 display |grep -ic "$hard3008t_3"`

hard3008tall=`echo "/ $hard3008t_0 *$hard3008tqty0 / $hard3008t_1 *$hard3008tqty1 / $hard3008t_2 *$hard3008tqty2 / $hard3008t_3 *$hard3008tqty3"`

let hard3008t=$hard3008t-$hard3008tqty3
;;

esac
let i=$i+1
done

fi


fi
}

hard(){
c3108=`lspci |grep -i raid |wc -l`
if [ "$c3108" -gt "0" ];then
lsi3108=`echo "/ LSI3108 *1"`
i=0
cd /opt/MegaRAID/storcli
hardall=`./storcli64  /c0 show  |grep -i 512B` 
hardallc=`./storcli64  /c0 show  |grep -ic 512B` 
until [ "$hardallc" = "0" ];
do
case $i in
0) 
hard0=`./storcli64  /c0 show  |grep -i 512B |awk '{print $5$6,$7,$12, $13}'|head -n1|tail -n1`

hardqty0=`./storcli64  /c0 show  |grep -i 512B |awk '{print $5$6,$7,$12, $13}'|grep -ic "$hard0"`

hard3108all=`echo "/ $hard0 *$hardqty0"`
let hardallc=$hardallc-$hardqty0
;;
1)
hard1=`./storcli64  /c0 show  |grep -i 512B |awk '{print $5$6,$7,$12, $13}'|grep -v "$hard0"|head -n1 |tail -n1`

hardqty1=`./storcli64  /c0 show  |grep -i 512B |awk '{print $5$6,$7,$12, $13}'|grep -ic "$hard1"`

hard3108all=`echo "/ $hard0 *$hardqty0 / $hard1 *$hardqty1"`
let hardallc=$hardallc-$hardqty1

;;
2)
hard2=`./storcli64  /c0 show  |grep -i 512B |awk '{print $5$6,$7,$12, $13}'|grep -ve "$hard0" -e "$hard1"|head -n1 |tail -n1`

hardqty2=`./storcli64  /c0 show  |grep -i 512B |awk '{print $5$6,$7,$12, $13}'|grep -ic "$hard2"`

hard3108all=`echo "$hard0 *$hardqty0 / $hard1 *$hardqty1 / $hard2 *$hardqty2"`
let hardallc=$hardallc-$hardqty2

;;
3)
hard3=`./storcli64  /c0 show  |grep -i 512B |awk '{print $5$6,$7,$12, $13}'|grep -ve "$hard0" -e $hard1 -e $hard2 |head -n1 |tail -n1`

hardqty3=`./storcli64  /c0 show  |grep -i 512B |awk '{print $5$6,$7,$12, $13}'|grep -ic "$hard3"`

hard3108all=`echo "$hard0 *$hardqty0 / $hard1 *$hardqty1 / $hard2 *$hardqty2" / $hard3 *$hardqty3`
let hardallc=$hardallc-$hardqty3

;;
esac
let i=$i+1

done

plus3108all=`cat /proc/scsi/scsi|grep -ve LSI -e AVAGO -e D51B |grep -ic Model`
if [ "$plus3108all" != "0" ];then
plus3108all=`cat /proc/scsi/scsi|grep -ve LSI -e AVAGO -e D51B |grep -ic Model`
i=0
until [ "$plus3108all" = "0" ];
do
case $i in
0)
plus3108on=`cat /proc/scsi/scsi|grep -ve LSI -e AVAGO -e D51B |grep -i Model |awk '{print $4, $5}' |head -n1|tail -n1`
plus3108qty=`cat /proc/scsi/scsi|grep -ve LSI -e AVAGO -e D51B |grep -i Model |awk '{print $4, $5}'| grep -ic "$plus3108on"`
plus3108a=`echo "/ $plus3108on *$plus3108qty"`
let plus3108all=$plus3108all-$plus3108qty
;;
1)
plus3108on1=`cat /proc/scsi/scsi |grep -ve LSI -e AVAGO -e D51B |grep -i Model |awk '{print $4, $5}' |grep -v "$plus3108on" |head -n1|tail -n1`
plus3108qty1=`cat /proc/scsi/scsi |grep -ve LSI -e AVAGO -e D51B|grep -i Model |awk '{print $4, $5}'| grep -ic "$plus3108on1"`

plus3108a=`echo "/ $plus3108on *$plus3108qty / $plus3108on1 *$plus3108qty1"`
let plus3108all=$plus3108all-$plus3108qty1
echo "$plus3108on1 $plus3108qty1"
;;
esac
let i=$i+1
done
fi


fi
}

onhardchek(){
nohard=`lspci |grep -ie 3108 -e 3008 |wc -l`
if [ "$nohard" = "0" ];then
onhard=`cat /proc/scsi/scsi |grep -i Model |awk '{print $4, $5}' |wc -l`
i=0
until [ "$onhard" = "0" ];
do
case $i in
0)
onhard0=`cat /proc/scsi/scsi |grep -i Model |awk '{print $4, $5}' |head -n1|tail -n1`
onhardqty0=`cat /proc/scsi/scsi |grep -i Model |awk '{print $4, $5}'| grep -ic "$onhard0"`
onhardall=`echo "/ $onhard0 *$onhardqty0"`
let onhard=$onhard-$onhardqty0
;;
1)
onhard1=`cat /proc/scsi/scsi |grep -i Model |awk '{print $4, $5}' |grep -v "$onhard0" |head -n1|tail -n1`
onhardqty1=`cat /proc/scsi/scsi |grep -i Model |awk '{print $4, $5}'| grep -ic "$onhard1"`

onhardall=`echo "/ $onhard0 *$onhardqty0 / $onhard1 *$onhardqty1"`
let onhard=$onhard-$onhardqty1
;;

esac
let i=$i+1
done

fi

}

nvME(){
nvMe=`lsblk |grep -ic nvme`
if [ "$nvMe" != "0" ]; then
echo in
nvMe0=`nvme list |grep -i nvme |awk '{print $6, $7}'|head -n1`
nvName0=`nvme list |grep -i nvme |awk '{print $4}'`
nvMeqty0=`nvme list |grep -i nvme |grep -c "$nvName0"`
nvMeall=`echo "/ $nvMe0 Nvme *$nvMeqty0"`


fi
}

gpu_ck(){
gpucheck=`lspci |grep -ic nvidia`
if [ "$gpucheck" != "0" ]; then
gpuname=`nvidia-smi -a |grep -i "Product Name"|head -n1|awk '{print $4,$5}'`
gpunum=`nvidia-smi -a |grep -ic "Product Name"`
gpuall=`echo "/ $gpuname *$gpunum"`
fi
}


seri=`ipmitool fru |grep -i "product serial"|head -n1 |awk '{print $4}'`

delivery
cpu; 
meminfo; 
onbor; 
server; 
i350; 
connectx; 
x540;
hba; 
card3008; 
hard; 
onhardchek; 
nvME;
gpu_ck;

 

cd /mac_sn/spec_list
echo "$pname ||  `date +%Y-%m-%d` || $deli ||  $seri  ||  $cpuname *$cpuqty / $memory $mem_type $lsi3108 $sas3008ir $sas3008it $onhardall $hard3008all $nvMeall $hard3008tall $hard3108all $plus3108a $oncard $i350t $x540t $connX $hba16g $hba8g $gpuall" >> `date +%y-%m.txt`

 

cat -n `date +%y-%m.txt`

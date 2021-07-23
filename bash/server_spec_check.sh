#만든지 너무 오래되서 기억은 잘 안나지만
#각종 펌웨어나 무슨 카트가 꽂혀 있는지 보여주는 것으로
#HW적으로 어떤 스팩을 가지고 있는지 보여준다.+
#!/bin/bash
        ####Function#####
        #fwcpumem       #
        #hard           #
        #network        #
        #hba            #      
        #ext            #
        #################

chba=`lspci |grep -i emu`

introchek(){
clear
echo 'Wait a few seconds, Plz'
}


serverfw(){
#bios&bmc


biosF=`dmidecode |grep -m 1 'Version' |awk '{print $2}'`
#bmcF=`ipmitool mc info |grep -m 1 'Firmware' |awk '{print $4}'`
bmcF=`dmidecode |grep "String 4"|awk '{print $3}'`
echo "                                                         "
echo "====================== BIOS & BMC ======================="
echo ""
echo -e "         BIOS Firmware    :    \033[31m$biosF\e[0m"
echo -e "         BMC Firmware     :    \033[32m$bmcF\e[0m"
echo ""
echo "========================================================="
}


servercpu(){
#cpu
        cpuname0=`dmidecode -t 4|grep Version| awk '{print $4,$5}'|head -n 1`
#       cpunum=`dmidecode -t 4|grep -c Version`
        cpunum=`dmidecode |grep -c "$cpuname0"`
        if [ $cpunum = 1 ];then
        cpuname1="Empty Socket"
        elif [ $cpunum = 2 ];then
        cpuname1=`dmidecode -t 4|grep Version| awk '{print $4,$5}'|tail -n 1`

        fi
#       cpuname=`dmidecode |grep -c "$cpuname"`
#       cpuname=`lscpu |grep name |awk '{print $5, $6}'`
#       cpuso=`lscpu |grep Socket |awk '{print $2}'`
        cpucore=`lscpu |grep Core |awk '{print $4}'`
        cpuallco=`lscpu |grep 'CPU(s)' | head -n1 |awk '{print $2}'`

        let cpuhyper=$cpunum*$cpucore

if [ $cpuhyper = $cpuallco ]; then
        cpuhyper='Off'
else
        cpuhyper='On'
fi
echo "====================== CPU config ======================="
echo ""
echo -e "         CPU Socket 0     :    \033[31m$cpuname0\e[0m"
echo -e "         CPU Socket 1     :    \033[31m$cpuname1\e[0m"
echo -e "         CPU per core(s)  :    \033[32m$cpucore\e[0m"
echo -e "         CPU all core(s)  :    \033[32m$cpuallco\e[0m"
echo ""
echo -e "         Hyper Thread     :    \033[32m$cpuhyper\e[0m"
echo ""
read -p "===================== Press Enter ======================" asdf
}

servermem(){
#memory
#        memqty=`ipmitool sdr type memory |grep -i "presence detected" |wc -l`
        memtotal=`free -h |head -n 2 |tail -n1 |awk '{print $2}'`
#        memap=`ipmitool sdr type memory |grep -i presence`

memall=`dmidecode -t 17 |grep -A 7 'Size: ..... MB'`

if [ -z "$memall" ];then
       memall=`dmidecode -t 17 |grep -A 19 'Size: .. GB'  |grep -e Size -e "Locator: CPU" -e Speed -e Part |grep -v Config`
else
       memall=`dmidecode -t 17 |grep -A 19 'Size: ..... MB'  |grep -e Size -e "Locator: CPU" -e Speed -e Part |grep -v Config`
fi

memqty=`echo -e "$memall"|wc -l`
let memqty=$memqty/4

echo "====================== MEM config ======================="
echo ""
i=0
while [ "$i" -lt "$memqty"  ]
do
a=0
       while [ "$a" -lt "4" ]
       do
               case $a in
               0)
                      memsize=`echo -e "$memall"|head -n1|tail -n+1|awk '{print $2,$3}'`
               ;;

               1)
                      memlo=`echo -e "$memall"|head -n2|tail -n+2|awk '{print $2,$3}'`
               ;;
              
               2)
                      memspeed=`echo -e "$memall"|head -n3|tail -n+3|awk '{print $2,$3}'`
               ;;

               3)
                      mempart=`echo -e "$memall"|head -n4|tail -n+4|awk '{print $3}'`
               ;;
               esac
       let a=$a+1
              
       done
memall=`echo -e "$memall"|awk "NR >= 5"`

let i=$i+1
echo -e "\033[32m$memlo\e[0m :[size $memsize] [$memspeed -$mempart]"

done

echo -e "      Total Size :\033[31m$memtotal\e[0m          QTY :\033[031m$memqty\e[0m"
echo ""
echo ""
#echo -e "\033[32m $memall\e[0m"
#echo "           If you see more memory infomation, Press M          "
read -p "===================== Press Enter ======================" memin

#if [ "$memin" = "m" ]; then
#        ipmitool sdr type memory|grep -ie "cpu0_ch*" -e "cpu1_ch*"
#read -p "===================== Press Enter ======================" memin
#elif [ "$memin" = "M" ]; then
#        ipmitool sdr type memory|grep -ie "cpu0_ch*" -e "cpu1_ch*"
#read -p "===================== Press Enter ======================" memin
#fi

}


frucheck(){
#FRU
        fruN=`ipmitool fru|grep -i "Eslim"|head -n 1|awk '{print $4, $5}'`
        fruP=`ipmitool fru|grep -i 'Product name'|head -n 1|awk '{print $4}'`
echo "====================== FRU info ========================="
echo ""
echo -e "         FRU Name         :    \033[31m$fruN\e[0m"
echo -e "         FRU Product      :    \033[32m$fruP\e[0m"
echo ""
echo "========================================================="

}

powerinfo(){
#POWER
        powerst=`ipmitool sdr type 0x09|awk '{print $9, $10}'`
        powerMax=`dmidecode |grep -i "Max power"|grep -v Unknown |awk '{print $4$5}'|head -n1`
        powerqty=`dmidecode |grep -i "Max power"|grep -v Unknown |wc -l`
echo "====================== Power info ======================="
echo ""
echo -e "         Power status     :    \033[31m$powerst\e[0m"
echo -e "         Power MAX        :    \033[32m$powerMax\e[0m"
echo -e "         Power QTY        :    \033[32m$powerqty\e[0m"
}



hard(){
echo "====================== Hard info ========================="
echo ""
lsblk

#### change_firm
ins3108=`/opt/MegaRAID/storcli/storcli64 /c0 show |grep -i 0061|awk '{print $5}'`
lsi9361=`/opt/MegaRAID/storcli/storcli64 /c0 show |grep 'FW Pack'|awk '{print $5}'`

c3108=`lspci |grep -i raid |wc -l`
c3008=`lspci |grep -c 3008`
nvMe=`lsblk |grep -ic nvme`

#echo "$c3008 $c3108"

if [ "$c3108" -gt "0" ]; then

read -p "===================== Press Enter ======================" asdf
echo    "====================== Raid info ======================="
echo -e "================ FW P/B : \033[32m$lsi9361\e[0m ================"

cd /opt/MegaRAID/MegaCli
i=0
        SRCARD=`./MegaCli64 -PDList -aALL |grep -i "firmware level"|wc -l`
      
       echo -e "      size \t vend \t firm "
        while [ $i -lt $SRCARD ]
        do
        let i=$i+1
        cd /opt/MegaRAID/MegaCli
                b=`./MegaCli64 -PDList -aALL |grep -i "inq"|awk '{print $3}'|head -n $i |tail -n+$i`
                a=`./MegaCli64 -PDList -aALL |grep -i "raw size"|awk '{print $3}'|head -n $i |tail -n+$i`
                c=`./MegaCli64 -PDList -aALL |grep -i "firmware level"|awk '{print $4}'| head -n $i |tail -n+$i`
cd /opt/MegaRAID/storcli

                echo -e "     $a  $b  \033[33m$c\e[0m"
        done


cd /opt/MegaRAID/storcli/
raidnum=`./storcli64 /c0 show |grep -i optl|grep -i rwtd|wc -l`
i=0
echo "=================== Raid level ==========================="
        while [ $i -lt $raidnum ]
        do
        let i=$i+1
        cd /opt/MegaRAID/storcli/
       d=`./storcli64 /c0 show |grep -i optl|grep -i rwtd|awk '{print $2}'|head -n $i |tail -n+$i`
       d1=`./storcli64 /c0 show |grep -i optl|grep -i rwtd|awk '{print $9$10}'|head -n $i |tail -n+$i`
      
       echo -e "             \033[32m$d\e[0m - $d1"

       done

       echo "================Check the quantity of hard================"
       echo -e "          QTY   :   \033[32m$SRCARD\e[0m"
echo "====================== Card F/W =========================="
/opt/MegaRAID/storcli/storcli64 /c0 show all |grep Build

elif [ "$c3008" -gt "0" ]; then
       sas3ircu 0 display |grep -i -e "device is a" -e  firm -e "slot #" -e "protocol"  -e "maunfccturer"
else
       cat /proc/scsi/scsi
fi


if [ "$nvMe" -gt "0" ]; then
echo "====================== Nvme info ========================="
       nvme list
fi
}


network(){
echo "=====================Network Card========================="
echo ""
lspci |grep -i ether*
echo ""
aa=`ip a |grep -i mtu |grep -i eno |wc -l`
bb=`ip a |grep -i mtu |grep -i enp |wc -l`
cc=`ip a |grep -i mtu |grep -i eth |wc -l`
let ff=$aa+$bb+$cc
i=0
while [ $i -lt $ff ]
do
        let i=$i+1
        port=`ip a|grep -i mtu |grep -i 1500|awk '{print $2}'|head -n $i|tail -n+$i`
        port=${port: 0: -1}
        ethtool -i $port |grep firmware
done

echo ""
}

hba(){
echo "=====================HBA Card info========================"
echo ""
lspci |grep Fibre
echo ""
cat /sys/class/fc_host/host*/symbolic_name |grep -i "host*"
echo ""

read -p "=====================Press Enter=========================" asdf
awaw=0
j=`hbacmd listhbas |grep "10:"|wc -l`
while [ $awaw -lt $j ]
do
        let awaw=$awaw+1
        echo "$awaw"
#       hbacmd listhbas |grep -i "port wwn"|awk '{print $4}'|head -n $awaw |tail -n+$awaw


        hbaport=`hbacmd listhbas |grep -i "Port wwn" |awk '{print $4}'|head -n $awaw| tail -n+$awaw`
        echo "$hbaport"

        hbacmd hbaattributes $hbaport |grep -i emulex

done
echo ""
echo "Model desc => Emulex LPe16002B-M6 PCIe 2-port 16Gb Fiber Channel Adapter"
echo ""
}


ext(){

bip=`ipmitool lan print|grep -i "ip address"|tail -n1 |awk '{print $4}'`

echo "====================IPMI IP address======================="
echo ""
echo -e "        IPMI IP address   :    \033[32m$bip\e[0m"
echo ""
echo "=========================================================="

echo "                If you check all log, Press [a/A]"
read -p "====================Press Enter==========================" bmclog
if [ "a" = "$bmclog" ];then
echo "====================IPMI LOG ============================="
       ipmitool sel elist
elif [ "A" = "$bmclog" ]; then
echo "====================IPMI LOG ============================="
       ipmitool sel elist
else
echo "====================IPMI ERROR LOG ======================="
       ipmitool sel elist |grep -ie err -e cri -e ecc -e irr
fi
cal
date
}

################
emty=0
fimem=sys
fihard=hard
finet=net
fihelp=help
fihba=hba
fibmc=ip


if [ "$1" = "help" ]; then
echo "         Used : name.sh [option]"

echo "         Option list : sys, hard, net, hba, ip"
echo "sys      - cpu, memory, fru.."
echo "hard     - hard info"
echo "net      - network info"
echo "hba      - HBA info"
echo "ip       - bmcip info"
fi

case $1 in
$fimem)
       serverfw
       servercpu
       servermem
;;
$fihard)

       hard
;;
$finet)
       network
;;
$fihba)
       hba                  
;;
$fibmc)
       ext           
;;
esac




if [ "$#" = "$emty" ];then

       introchek
       serverfw
       servercpu
       servermem
       frucheck
       powerinfo
#      introchek
#      fwcpumem
       read -p "===================== Press Enter ======================" memin
       clear
       hard
       read -p "===================== Press Enter ======================" hardin
       clear
       network
       read -p "===================== Press Enter ======================" netin
       clear
       if [ -n "$chba" ];then
               hba
               read -p "===================== Press Enter ======================" hba
       fi

       ext
fi


ckal(){
       introchek
       fwcpumem
       read -p "===================== Press Enter ======================" memin
       clear
       hard
       read -p "===================== Press Enter ======================" hardin
       clear
       network
       read -p "===================== Press Enter ======================" netin
       clear
       if [ -n "$chba" ];then
               hba
               read -p "===================== Press Enter ======================" hba
       fi
       ext
}

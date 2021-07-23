#! /bin/bash

var_stat(){
        #리눅스버전
        linux_ver=`cat /etc/*release |grep -ie release -e DISTRIB_DESCRIPTION |tail -n1`
        #메모리 실 사용량 확인
        TOTAL=`free | grep ^Mem | awk '{print $2}'`
        USED1=`free | grep ^Mem | awk '{print $3}'`
        USED2=`free | grep ^-/+ | awk '{print $3}'`
        NOMINAL=$((100*USED1/TOTAL))
        ACTUAL=$((100*USED2/TOTAL))

        #CPU 사용량
        cpu_stat=`mpstat | tail -1 | awk '{print 100-$NF}'`

        #ps 수량
        ps_qty=` ps -aux |wc -l`

        #하드디스크 사용량
        disk_per=`df -h |grep -ie sda* -e storage*`

        #평균 부하량
        uptime_stat=`uptime |awk '{print $8,$9,$10,$11,$12}'`

        #로그 확인
        dmesg_cri=`dmesg  |grep -i criti*  |wc -l`
        sys_cri=`grep -i criti* /var/log/messages |wc -l`

        #인터넷 접속자 수
        http_u=`netstat -an | grep :80.*ESTABLISHED | wc -l`
        https_u=`netstat -an | grep :443 | grep ESTABLISHED | wc -l`
        http_user=$((http_u+$https_u))
        #내부 접속자 수
        inter_A=`ss |grep -i 192.168.|wc -l`

        #센드큐 작업확인
        recv_send=`netstat -netp | awk '$3 > 0 || $2 > 0'`

        #서버별 접속자 수
        server_acces=`netstat -netp |wc -l`

}

var_stat

echo -e "\e[32m ================================================Server status====================================================== \e[0m"
echo -e "\e[32m                                                 ||"
echo -e "\e[32m Linux Version : $linux_ver      ||       $uptime_stat   \e[0m"
echo -e "\e[32m                                                 ||"
echo -e "\e[32m =================================================================================================================== \e[0m"
echo -e "\e[32m cpu                     || Memory                       ||  HTTP user : $http_user              || Accessor : $server_acces"
echo -e "\e[32m usage $cpu_stat%                || Total : `free -h |grep -i Mem: |awk '{print $2}'`                    ||  Internal accessor : $inter_A    || system Error : $sys_cri \e[0m"
echo -e "\e[32m                 || NOMINAL=${NOMINAL}% ACTUAL=${ACTUAL}%        ||  Process QTY : $ps_qty               || Demon Error : $dmesg_cri"
echo -e "\e[32m =================================================================================================================== \e[0m"
echo -e "\e[32m-Disk Status"
echo -e "\e[32m$disk_per"
echo ""
echo -e "\e[32m =================================================================================================================== \e[0m"
echo -e "\e[32m$recv_send"
echo ""
echo -e "\e[32m =================================================================================================================== \e[0m"
echo ""
echo ""
echo ""
echo "-"

#엔서블을 이용해서 간단하게 볼려고 작정함
#nfs 서버 구축후 전부 마운트 시킨다음 사용 하였음
#ansible -a "bash /경로/server_status.sh" all




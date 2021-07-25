#!/bin/bash 


###변수
test_cpu=`lscpu |grep -i "cpu(s):" |head -1 |awk '{print $2}'`
let test_cpu=$test_cpu-2
#mem_vm=`free |head -n+2 |tail -n1 |awk '{print $4}'`
#let mem_vm=$mem_vm/2000000
#echo $mem_vm
incr=0
Count_1=1 #배열실행 while문  카운트

#다음 스텝 넘어갈때 프로세스 죽이기 포어 그라운드기 때문에 찾아서 죽여야함
#ps_num='ps -aux |grep -i stress |head -n1'|awk '{print $2}'
#kill -9 $ps_num


#테스트에 사용될 배열들
test_map_array=("dontneed" "hugepage" "mergeable" "nohugepage" "normal" "random" "sequential" "unmergeable" "willneed" "break")
#test_mem_array=( "" "" "break" )

#stress_install(){
## 파일을 같이 압축해서 인스톨 하려고 해보자 if 명령어를 쓰고 파일 있는지 없는지 확인
##파일이 있다면 넘어가고
#없으면 아래 내용 사용하기

#}



#실행될 함수
memtest(){
next=0

while [ "$next" -lt 10 ] 
do
	for x in ${test_map_array[@]}
	do
		if [ "$x" =  "break" ];then
			let next=$next+1
			break;
		fi
clear			
		#함수에 사용될 실 값들
		./stress-ng --cpu 10 --vm 10 --vm-bytes 47%  --vm-madvise $x --mmap 2 --mmap-bytes 30%  --page-in  &
		echo ""
		echo -e "[$next/10]Memory Mapping Testing ... [$x\tTEST($Count_1/${#test_map_array[@]})]"
		sleep 1;
		per;
		#다음 스텝 넘어갈때 프로세스 죽이기 포어 그라운드기 때문에 찾아서 죽여야함
		ps_num=`ps -aux |grep -i stress |head -n1|awk '{print $2}'`
		kill -9 $ps_num
		sleep 10;

		./stress-ng --vm 1 --vm-bytes 90% --vm-method all  --aggressive &
		sleep 300
		agg_num=`ps -aux |grep -ic aggressive`
		killps=1
		while [ "$killps" -le "$agg_num" ]
		do	
			ps_num=`ps -aux|grep -i aggressive |head -n1 |awk '{print $2}'`
			kill -9 $ps_num
		let killps=$killps+1
		done

		sleep 10

		let Count_1=$Count_1+1;
		if [ "$Count_1" =  "10"  ];then
			Count_1=1
		fi
	done

#echo "start memory More stress"
#sleep 10
#	if [ "$next" =  "1" ];then
#		echo "======Memory  test======="
#		#충분히 마지막 스퍼트라고 생각하면될듯 
#		./stress-ng --vm 2 --vm-bytes 80% --vm-method all  --aggressive &
#		per;
#	fi
#
done
}





function hide_cursor() {
    echo -n `tput civis`
}
 
function show_cursor() {
    echo -n `tput cvvis`
}
 
function progress () {
    # Display a progress bar
    # usage: progress percentage
    #
    # PERCENTAGE should be in range between 0 and 100.
    # If PERCENTAGE is 100, this function returns 1, otherwise returns zero.


    echo -en "\r["
 
    inc=$1
    if test $inc -gt 100; then
        inc=100;
    fi
 
    num=`expr 40 \* "$inc" / 100`
    i=0
    while test $i -le $num; do
        echo -n "="
        i=`expr $i + 1`
    done
 
    while test $i -le 40; do
        echo -n " "
        i=`expr $i + 1`
    done
 
    echo -n "] $inc%"

    if test $inc -ge 100; then
        return 1
    else
        return 0
    fi
}
 
per(){ 
while progress $incr; do
    incr=`expr $incr + 2`
    sleep 10
#echo 1
done
incr=0 
}

main_test (){
hide_cursor
trap 'show_cursor; echo ""; exit 1' INT QUIT TERM EXIT

memtest
show_cursor
}



main_test

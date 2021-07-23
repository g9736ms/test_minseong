#!/bin/bash

ip_list=(  #여기엔 관리하고 싶은 아이피를 넣는다
#예시
#192.168.4.4
#192.168.5.5
)

mail_name(){ #매일 보낼 내용을 변수로 저장함 함수로 둔 이유는 확장성 용의
        이메일변수1=`echo "system or network is down, check your server" | mail -s "$node server is down" 내아이디@도메인.com`
        이메일변수2=`echo "system or network is down, check your server" | mail -s "$node server is down" 내아이디@도메인.com`

}

#케이스 문을통해서 원하는 서버가 꺼지면 필요한 사람들에게 메일전송 
#되도록 변수 입력 여러 케이스에서 사용되도록 변수로 만듦
mail_send(){  
        echo "in"
        case $node in
                #192.168.4.4)
                        이메일변수1
                        이메일변수2
                        ;;
                *)
                        이메일변수1
                ;;
        esac
}

#실행되는 곳 해당 IP로 핑을날려 응답 없음이 연속으로 누적되면 메일 발송
#응답을 1번이라도 하면 스택 초기화
#/tmp/ping_test/에 IP형태로 로그들이 쌓인다.
ping_test(){
        for node in ${ip_list[@]}
        do
                ping -c 1 -W 1 "$node" > /dev/null
                if [ $? -eq 0 ]; then
                        #echo "$node OK"
                        echo "pass" > /tmp/ping_test/$node
                else
                        #echo "$node fail"
                        echo "fail"  >> /tmp/ping_test/$node
                        fail_num=`cat /tmp/ping_test/$node |wc -l`
                        if [ $fail_num -eq "10" ]; then
                                mail_name
                                mail_send
                        fi
                fi
        done
}

#main 
while :
do
        ping_test
       sleep 5;
done

# 프로세스 처럼 백그라운드로 실행하면 됨 
#CMD 에선 아래와 같이 실행 시켜줌
# [root@대충이름]# bash 스크립트이름.sh &
#솔직히 다른 서버에서 장애 로그를 rsyslog로 이상 있는 것만 보낸 다음 
#해당로그 정보를 이매일로 발송하고 삭제하면 될 것 같음  쉽게 확장 가능함.
#아직 쓸만한 일이 없어서 안만들고 버티는중

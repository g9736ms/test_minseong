#!/bin/bash

output_code=log_name.log
> $output_code



## root 접속 안될수 있음 신경 써야함 !!!!!!!!!!!
u01(){ #root 계정의 원격 접속 제한설정
  test_num="u01"
  test_check=`cat /etc/ssh/sshd_config |grep "PermitRootLogin no" |grep -vc '#'`

  if [ "$test_check" = "1" ]; then
    check_status="$test_num ok"
  else
    check_status="$test_num did not apply." #문구 수정 필요
    #이부분 잘못하면 애러 발생할 수 있으니 조심
    #echo "PermitRootLogin no" >> /etc/ssh/sshd_config
    test_check=`cat /etc/ssh/sshd_config |grep "PermitRootLogin no" |grep -vc '#'`
    #적용후 다시 검사
    if [ "$test_check" = "1" ]; then
      check_status="$test_num ok"
    fi
  fi

cat << EOF >> $output_code
>>$check_status[0m ( root 계정의 원격접속 제한 설정 )
==== status ====
`cat /etc/ssh/sshd_config |grep "PermitRootLogin"`


EOF
}





u01

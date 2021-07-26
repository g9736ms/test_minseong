#!/bin/bash
#현재 디렉토리의 모든 파일중 최근 24시간안에 변경된 파일들을
#+ 타르로 묶고 gzip으로 압축한 "타르볼 "로 백업


NOARGS=0
E_BADARGS=65

if [ $# = $NOARGS ];then
        echo "used : `basename $0` filename"
        exit $E_BADARGS
fi
## 이 위 까지는 사용 방법을 출력해준다  $? 인자값이 65을 리턴함
##


tar cvf - `find . -mtime -1 type f -print` > $1.tar
gzip $1.tar


##tar cvf - `find . -mtime -1 type f -print0` | xargs -0 rvf "$1.tar"
##xargs 는 효과적인 명령어로써 출력된 결과를 인자값으로 이용하여 다른 커맨드에서 활용 할 수 있게 만들어줌
##
##

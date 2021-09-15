#!/bin/bash

date_in=`date +%Y%m%d-%H%M`
file_name=`ls -t  |grep -i ami_make_name |tail -n 1`
pwd_tf='/root/terrform/auto_test/'
s_true=`cat /root/terrform/provider.tf  |grep -c true`


make_name() {
        echo 'variable "'${file_name:0:-3}'" {' > $pwd_tf$file_name
        echo '  description = "ami test name"' >> $pwd_tf$file_name
        echo '  type        = string' >> $pwd_tf$file_name
        echo '  default     = "'test_$date_in'"'  >> $pwd_tf$file_name
        echo '}'  >> $pwd_tf$file_name
}

if [ "$s_true" = "1" ]; then
        make_name
        sed -i 's/true/false/g' /root/terrform/provider.tf
else
        make_name
        sed -i 's/false/true/g' /root/terrform/provider.tf
fi

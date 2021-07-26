kill -9 $(ps -aux |grep '$(Y want PS)' |awk '{print $2}' )

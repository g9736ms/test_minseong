x=`cat test.txt |grep "id='\w\w" |cut -d '=' -f2 |tr -d "'" |awk '{print $1}' |wc -l`

for (( c=1; c<=$x; c++  ))
do

        echo $c
        get_volume_name="$(cat test.txt |grep "id='\w\w" |cut -d '=' -f2 |tr -d "'" |awk '{print $1}' |head -n+$c|tail -n+$c)"
        echo $get_volume_name
done


test.txt
| volumes_attached                    | id='aad86f2b8'                                            |
|                                     | id='f651e461'                                             |


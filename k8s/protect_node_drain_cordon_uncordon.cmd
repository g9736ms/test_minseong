#ex
#노드들에 더이상 스캐쥴링 하지 않게 해줌
k cordon $node_name
#이쪽 노드에 있는 파드들을 전부 다른 노드로 옮겨서 스캐쥴링 하지 않게함
k drain $node_name --ignore-deamonsets
#위 두개 상태를 원상태로 
k uncordon $node_name

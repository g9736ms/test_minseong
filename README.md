# test_terraform
테라폼 실 구축

test1. 
오하이오에 있는 리전에 VPC 하나를 만들고 서브넷 3개와 라우팅테이블로 연결을 하여 인터넷 게이트웨이 연결 함
그리고  EC2 쪽은 서브넷 각 존에 3개 씩 올리고 ALB 설정함 ALB 설정은 HTTP에서 HTTPS 리다이랙션이며 타겟은 자기자신이 속한 LB로 설정

test2.
PublicSubnet과 PrivateSubnet 만들어서 PrivateSubnet에는 NAT 설정과 Elacitc IP 연결

test3.
ELB 설정 
       

이것저것 써두는곳

terraform0. 
오하이오에 있는 리전에 VPC 하나를 만들고 서브넷 3개와 라우팅테이블로 연결을 하여 인터넷 게이트웨이 연결 함
그리고  EC2 쪽은 서브넷 각 존에 2개 씩 올리고 ELB 설정함 
한쪽은 ALB 설정을 하고 내용은 HTTP에서 HTTPS 리다이랙션이며 타겟은 자기자신이 속한 LB로 설정
다른쪽은 L4 로드밸런싱 구성함 80포트로 받으면 바로 자기 LB 그룹에다가 포워딩 시킴
이대로 받아가면 실행 절대 안되고 이거 기반 수정을 해야함 

terraform1.
PublicSubnet과 PrivateSubnet 만들어서 PrivateSubnet에는 NAT 설정과 Elacitc IP 연결

       

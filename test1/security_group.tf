#ec2에 적용할 보안 그룹을 생성한다.
#ingress는 들어오는 포트에 관한 것
#egress는 나가는 포트에 대한 것
#중복해서 적으려면 ingress { }를 하나 더 쓰면된다.

resource "aws_security_group" "test-default" {
  name = "default1"
  description = "default"
  ingress {
    from_port = 22      ##ssh 접속 허용
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80      ##HTTP 허용
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443      ##HTTPS 허용
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  #여기는 나가는 포트 전부 허용인데 
  #이거 기입안하면 통신 자체가 안되니 
  #웬만해선 이상태로 기입하고 수정하자
  egress {                
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  vpc_id = aws_vpc.test.id        #적용할 VPC id를 적용해준다.
}


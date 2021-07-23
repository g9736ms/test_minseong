#VPC 생성
resource "aws_vpc" "testVPC" {
  cidr_block = "172.30.0.0/16" #여긴 사용하고싶은 대역을 정해주면되고 웬만하선 서브넷 cidr를 24로 쓰고싶다면 충돌안나게 16으로 해주는것이 무난
  tags = {
    Name = "testVPC" #이름 테그에 들어갈것 넣어주면 된다
  }
}

#아래와 같이 2개도 만들 수 있음
resource "aws_vpc" "testVPC1" {
  cidr_block = "172.40.0.0/16"
  tags = {
    Name = "testVPC1"
  }
}

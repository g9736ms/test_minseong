#서브넷 생성

#aws_subnet을 사용해 각 존에 원하는 서브넷을 만들 수 있다.

resource "aws_subnet" "test-a" {
  vpc_id = aws_vpc.testVPC.id       #여기서 VPC 생성해둔 것에 id를 기입해 줘 연결 시킨다.
  cidr_block = "172.30.0.0/24"      #원하는 cidr block을 기입해준다.
  availability_zone = "us-east-2a"  #원하는 zone을 설정해줌
  tags = {
    Name = "test-a"                 #마찬가지로 테그 Name에 보여줄 이름을 기입해둔다.
  }
}

#아래는 위에 설명과같이 변형해 만들어 둔 것
resource "aws_subnet" "test-b" {
  vpc_id = aws_vpc.testVPC.id
  cidr_block = "172.30.1.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "test-b"
  }
}

resource "aws_subnet" "test-c" {
  vpc_id = aws_vpc.testVPC.id
  cidr_block = "172.30.2.0/24"
  availability_zone = "us-east-2c"
  tags = {
    Name = "test-c"
  }
}

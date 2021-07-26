#서브넷 생성

#퍼플릭
resource "aws_subnet" "PublicSubnet" {
  vpc_id = aws_vpc.testVPC.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "public-subnet"
  }
}

#프라이빗
resource "aws_subnet" "PrivateSubnet" {
  vpc_id = aws_vpc.testVPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "private-subnet"
  }
}

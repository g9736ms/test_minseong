#인터넷 게이트웨이 설정
#어떤 VPC에서 사용할 것인가? 만 기입해 주면 손쉽게 완성
resource "aws_internet_gateway" "keycut-gw" {
  vpc_id = aws_vpc.testVPC1.id    #이 부분에서 사용할 VPC를 기입해준다.
  tags = {
    Name = "test1-gw"             #마찬가지로 테그 부분 
  }
}

resource "aws_internet_gateway" "etc-gw" {
  vpc_id = aws_vpc.testVPC2.id
  tags = {
    Name = "test1-gw"
  }
}

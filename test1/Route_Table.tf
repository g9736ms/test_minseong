#라우팅 테이블을 생성한다
resource "aws_route_table" "test-route" {
  vpc_id = aws_vpc.testVPC.id                       #어떤 VPC에 설정할지 
  route {
    cidr_block = "0.0.0.0/0"                        #모든 IP들이 통신 가능
    gateway_id = aws_internet_gateway.test-gw.id    #인터넷 게이트웨이를 라우팅 시켜준다.
  }
  tags = {
    Name = "test-route"
  }
}

resource "aws_route_table" "test1-route" {
  vpc_id = aws_vpc.testVPC1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.etc-gw.id
  }
  tags = {
    Name = "test1-route"
  }
}

#각 라우팅 테이블에 서브넷들을 등록 시켜주는 작업
resource "aws_route_table_association" "test-a-routing" {
  subnet_id      = aws_subnet.test-a.id               #서브넷 아이디를 적고
  route_table_id = aws_route_table.test-route.id      #무슨 라우팅 테이블에 서브넷을 등록시킬지 적는다.
}

#위에 설명과 같이 설정 해줌
resource "aws_route_table_association" "test-b-routing" {
  subnet_id      = aws_subnet.test-b.id
  route_table_id = aws_route_table.keycut-route.id
}
resource "aws_route_table_association" "test-c-routing" {
  subnet_id      = aws_subnet.test-c.id
  route_table_id = aws_route_table.keycut-route.id
}


resource "aws_route_table_association" "test1-routing" {
  subnet_id      = aws_subnet.test1-a.id
  route_table_id = aws_route_table.etc-route.id
}

#퍼플릭 라우팅
resource "aws_route_table" "terra-public1" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }
  tags = {
    Name = "terra-public1"
  }
}

#프라이빗 라우팅
resource "aws_route_table" "terra-private1" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "terra-private1"
  }
}
resource "aws_route_table_association" "terra-routing-public1" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.terra-public1.id
}

resource "aws_route_table_association" "terra-routing-private1" {
  subnet_id      = aws_subnet.PrivateSubnet.id
  route_table_id = aws_route_table.terra-private1.id
}

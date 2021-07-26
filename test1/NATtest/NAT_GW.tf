#NAT 에서 사용할 Elasitc IP 생성
resource "aws_eip" "nat" {
  vpc = true
}
#NAT게이트웨이 생성
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.PrivateSubnet.id
  tags = {
    Name = "terra-NAT"
  }
}

resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.testVPC.id
  tags = {
    Name = "test-internet"
  }
}

#VPC 생성
resource "aws_vpc" "testVPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "test-vpc"
  }
}

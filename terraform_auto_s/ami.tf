resource "aws_ami_from_instance" "test-AMI" {
  name               = var.ami_make_name
  source_instance_id = "i-01fe9a659572cf2d4"
}

resource "aws_launch_configuration" "as_conf" {
  count = "${var.create_if_test == true ? 1 : 0}"
  name          = "web_config0"
  image_id      = aws_ami_from_instance.test-AMI.id
  instance_type = "t2.medium"
  security_groups = ["sg-" ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "as_conf1" {
  count = "${var.create_if_test == false ? 1 : 0}"
  name          = "web_config1"
  image_id      = aws_ami_from_instance.test-AMI1.id
  instance_type = "t2.medium"
  security_groups = ["sg-" ]
  lifecycle {
    create_before_destroy = true
  }
}

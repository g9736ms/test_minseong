resource "aws_autoscaling_group" "bar" {
  count = "${var.create_if_test == true ? 1 : 0}"
  name                      = "ts-terraform-test"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  #LB랑 연결 하는 곳
  target_group_arns         = [ "arn:aws:elasticloadbalancing:us-east-2::targetgroup/ts-test-lb-g/"]
  #런처 설정
  launch_configuration      = "web_config0"
  #서브넷 쓸 공간 설정
  vpc_zone_identifier       = ["subnet-3e88c757", "subnet-f4d3598f"]
  #런처 생명주기
  lifecycle {
    create_before_destroy = true
  }
  
  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }
  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}


resource "aws_autoscaling_group" "bar1" {
  count = "${var.create_if_test == false ? 1 : 0}"
  name                      = "ts-terraform-test"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  #LB랑 연결 하는 곳
  target_group_arns         = [ "arn:aws:elasticloadbalancing:us-east-2::targetgroup/ts-test-lb-g/"]
  #런처 설정
  #launch_configuration      = aws_launch_configuration.as_conf1.name
  launch_configuration      = "web_config1"
  #서브넷 쓸 공간 설정
  vpc_zone_identifier       = ["subnet-", "subnet-"]
  #런처 생명주기
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }
  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}

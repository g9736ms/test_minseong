#############www lb
resource "aws_lb" "www-lb" {
  name               = "www-lb-tf"
  internal           = false
  load_balancer_type = "network"        #여기가 L4로드밸런싱 할때 설정해 줘야하는 부분
  subnets            = [ aws_subnet.test-a.id, aws_subnet.test-b.id ]
  enable_deletion_protection = true
#  access_logs {
#    bucket  = aws_s3_bucket.lb-logs.bucket
#    prefix  = "test-lb"
#    enabled = true
#  }
  tags = {
    Name = "ELB test"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "www-lb-listener" {
  load_balancer_arn = aws_lb.www-lb.arn
  port = "80"
  protocol = "TCP"    #프로토콜도 TCP랑 UDP정도 밖에 안되는걸로 알고있음
  default_action {
    target_group_arn = aws_lb_target_group.www-lb-target.arn
    type = "forward"
  }
}

resource "aws_lb_target_group" "www-lb-target" {
  name = "www-target-group"
  port = 80
  protocol = "TCP"
  vpc_id = aws_vpc.test.id
  target_type = "instance"
  health_check {
    port = "traffic-port"
    protocol = "TCP"
  }
}

resource "aws_lb_target_group_attachment" "test-attach-www-a" {
  target_group_arn = aws_lb_target_group.www-lb-target.arn
  target_id        = aws_instance.www-a.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "test-attach-www-b" {
  target_group_arn = aws_lb_target_group.www-lb-target.arn
  target_id        = aws_instance.www-b.id
  port             = 80
}


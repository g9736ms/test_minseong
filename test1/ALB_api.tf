#전반적인 LB를 생성 틀을 만들어준다. 중요 부분은 서브넷 연결
resource "aws_lb" "api" {
  name               = "api-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test-default.id]
  subnets            = [ aws_subnet.test-a.id, aws_subnet.test-b.id ]

  enable_deletion_protection = false #이부분은 true 하면 삭제 방지가 된다.

# access_logs {   #이부분 사용하려면 S3 만들면됨 
#   bucket  = aws_s3_bucket.lb_logs.bucket
#   prefix  = "test-lb"
#   enabled = true
# }

  tags = {
    Environment = "production"
    Name = "api_LB"
  }
}

#LB에 연결될 리스너설정
#리다이랙션 부분이다 ALB니까 80으로 받은걸 443으로 보내주는것
#리스너는 규칙 ? 같은거라고 생각하면 편하다
resource "aws_lb_listener" "api80-lb-listener" {
  load_balancer_arn = aws_lb.api.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}

#여긴 443으로 받은걸 다시 어디로 보낼것인지 설정해주는것
#자기 자신에게 보내게 설정해두었다.
#그리고 인증서도 여기에 기입해주면 좋다.
#인증서 발급도 terraform 으로 쉽게 만들 수 있지만 
#빌드 테스트 하느라 만들었다 삭제가 빈번해서 따로 만들어뒀음 여긴 Route53에서 따로 적겠음
resource "aws_lb_listener" "api443-lb-listener" {
  load_balancer_arn = aws_lb.api.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-2:여기에 인증서 발급받은거 써주면됨"

  default_action {
    target_group_arn = aws_lb_target_group.api-lb-target.arn
    type = "forward"
  }
}

#인증서 들어갈 부분이 많다면 이걸써서 변수로 받아도 상관없으나 하나라서 그냥 없어배렸음
#resource "aws_lb_listener_certificate" "example" {
#  certificate_arn = "arn:aws:acm:ap-northeast-2:인증서 발급받은거 써주면됨"
#  listener_arn    = aws_lb_listener.api443-lb-listener.arn
#}

#여기는 어떤것들이 LB에 연결될건가 설정해 주는 단계이다.
#인스턴스를 타겟이랑 포트를 어떤 것을 LB로 설정해줄 것인지 설정
resource "aws_lb_target_group" "api-lb-target" {
  name = "api-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.test.id
  target_type = "instance"

  health_check {
    port = "traffic-port"
    protocol = "HTTP"
  }
}

#위에서 LB연결 규칙을 만들었다면 밑에는 LB에 연결될 실제 인스턴스 설정
resource "aws_lb_target_group_attachment" "api-attach-cms-a" {
  target_group_arn = aws_lb_target_group.api-lb-target.arn
  target_id        = aws_instance.api-a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "api-attach-cms-b" {
  target_group_arn = aws_lb_target_group.api-lb-target.arn
  target_id        = aws_instance.api-b.id
  port             = 80
}

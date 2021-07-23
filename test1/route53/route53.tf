#라우트 53에 대한 테라폼 작성버
#Route 53 Zone 등록
resource "aws_route53_zone" "mkdns" {
  name = "test.com"
  comment = "test for test"
}

#서브 도메인A레코드 등록 <<
resource "aws_route53_record" "testA" {
  zone_id = aws_route53_zone.mkdns.zone_id #이부부능ㄴ 호스팅 영역이 될 id를 적자
  name = "test.test.com" # 하고싶은 도메인 이름을 씁시다
  type = "A"
  ttl = "300"
  records = [
    "111.111.111.111" #IP주소를 기입하자
  ]
}

resource "aws_route53_record" "testCname" {
  zone_id = aws_route53_zone.mkdns.zone_id
  name = "test1.test.com"
  type = "CNAME"
  ttl = "300"
  records = [
    "test.test.com"
  ]
}


##SSL 인증서 생성
resource "aws_acm_certificate" "mkSSL" {
  domain_name = "test.com"
  subject_alternative_names = [ "*.test.com" ]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "test"
  }
}

# 기존 인증서 본문 가져오기
resource "tls_private_key" "example" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "example" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.example.private_key_pem
  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
  validity_period_hours = 12
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.example.private_key_pem
  certificate_body = tls_self_signed_cert.example.cert_pem
}

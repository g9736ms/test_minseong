resource "aws_instance" "api-a" {
  ami = "ami-대충번호"                    #원하는 AMI를 넣어준다. 여기선 yum을 사용했기에 레드햇 계열 추천..
  instance_type = "t2.micro"             #여기선 어떤 인스턴스 쓸지 기입 / 테스트기에 프리티어 선택
  key_name = aws_key_pair.web_admin.key_name  #키페어를 입력해준다.
  vpc_security_group_ids = [
    aws_security_group.test-default.id,      #여긴 보안그룹 설정 추가적으로 쓸거면 , 하고 엔터치고 쓰면 된다.
    aws_security_group.test-default1.id      # default1은 만들지 않았다
  ]
  subnet_id = aws_subnet.test-a.id           #무슨 서브넷에 만들래?
  user_data = <<-EOF                         #여기가 사용자 데이터 설정 구역임
###################################
#!/bin/bash
#여긴 EOF를 사용해서 그냥 무식하게 echo로 때려박았다.
echo '[nginx]' >> /etc/yum.repos.d/nginx.repo
echo 'name=nginx repo' >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/centos/7/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo 'gpgcheck=0' >> /etc/yum.repos.d/nginx.repo
echo 'enabled=1' >> /etc/yum.repos.d/nginx.repo
#####이후 nginx 설치와 테스트 해볼 것들을 대충 넣어준다. 
#####깃도 설치하고 당겨오면 됨
sudo yum update -y
sudo yum install nginx git -y
echo 'api111111111 to nginx!' >  /usr/share/nginx/html/index.html
systemctl enable nginx --now
echo "test" >> test.txt
###################################
                EOF
  tags = {
    Name = "api-a"
  }
  associate_public_ip_address = "true"    #이 부분 중요하다고 생각함 퍼플릭 IP를 생성해 주는 것 안되면 외부와 통신이 안된다리
}

#위와 같이 인스턴스 내용을 변경해서 기입해 준다.
resource "aws_instance" "www-a" {
  ami = "ami-대충번호" 
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.test-default.id
  ]
  subnet_id = aws_subnet.test-a.id
  user_data = <<-EOF
###################################
!/bin/bash
echo '[nginx]' >> /etc/yum.repos.d/nginx.repo
echo 'name=nginx repo' >> /etc/yum.repos.d/nginx.repo
echo 'baseurl=http://nginx.org/packages/centos/7/$basearch/' >> /etc/yum.repos.d/nginx.repo
echo 'gpgcheck=0' >> /etc/yum.repos.d/nginx.repo
echo 'enabled=1' >> /etc/yum.repos.d/nginx.repo

#####이후 nginx 설치와 테스트 해볼 것들을 대충 넣어준다.
sudo yum update -y
sudo yum install nginx -y
echo 'api111111111 to nginx!' >  /usr/share/nginx/html/index.html
systemctl enable nginx --now
echo "test" >> test.txt
###################################
                EOF
  tags = {
    Name = "www-a"
  }
  associate_public_ip_address = "true"
}


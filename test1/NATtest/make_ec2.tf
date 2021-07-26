resource "aws_instance" "web" {
  ami = "ami-00399ec92321828f5" #우분투
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh.id
  ]
  subnet_id = aws_subnet.PublicSubnet.id
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
echo 'public-web to nginx!' >  /usr/share/nginx/html/index.html
systemctl enable nginx --now
echo "test" >> test.txt
###################################
                EOF
  tags = {
    Name = "public-web"
  }
  associate_public_ip_address = "true"
}

resource "aws_instance" "web2" {
  ami = "ami-00399ec92321828f5" #우분투
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh.id
  ]
  subnet_id = aws_subnet.PrivateSubnet.id 
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
echo 'private-web to nginx!' >  /usr/share/nginx/html/index.html
systemctl enable nginx --now
echo "test" >> test.txt
###################################
                EOF
  tags = {
    Name = "private-web"
  }
}

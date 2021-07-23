#ssh-keygen -t rsa -b 4096 -C "<EMAIL_ADDRESS>" -f "$HOME/.ssh/admin" -N ""
#이런 식으로 키를 만들고 그 키를 사용하는것

resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = file("~/.ssh/web_admin.pub")   #file이란 함수로 호출 할 수 있다.
}

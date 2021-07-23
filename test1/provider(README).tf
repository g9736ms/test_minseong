#Terraform v1.0.2 으로 작성 되었습니다.
#Terraform init 으로 초기화 부탁드립니다.
#실제 테스트 한 원본을 수정하며 만들었으며
#중요 정보들을 다른 이름으로 바꾸면서 오타가 있을 수 있습니다.

provider "aws" {
  access_key = "엑세스키넣자"
  secret_key = "스키릿키넣자"
  region = "us-east-2" #리전 생성
}

#각 tf 모듈을 만듭니다.
# /test 라는 디랙터리를 만들고 거기다가 tf 파일들을 다 넣어주고 
#terraform init 을 해줘야합니다.
#디랙터리 모듈들 있는곳들을 설정해준다.
module "test" {
  source  = "./test"
}

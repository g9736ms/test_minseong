#도커에 이미지를 타르로 압축할 수 있음!
docker save [docker/images] > filename.tar
#원하는 서버로 scp 로 옮겨준 다음
#로드를 시켜주면 바로 완성~!
docker load < filename.tar

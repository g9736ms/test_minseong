#!/bin/bash
#TCP 포트로 반드시 포트 오픈 시켜줘야한다.
#6443*[쿠버네티스 API 서버], 
#2379-2380[kube-apiserver, etcd], 
#10250[컨트롤 플레인]-10252[자체]

#호스트 등록을 시켜준다.
#echo “[ip] [hostname]”  >> /etc/hosts 

#쿠버 네트워크랑 실 네트워크랑 대역폭이 겹치면 안됨
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 > kubeinit.txt

#cat kubeinit.txt |grep -e "kubeadm join *:6443" -e "--discovery-token-ca-cert-hash"
#kubeadm join 172.31.25.244:6443 --token 9zm8cu.92pz3b4vt74yugwp \
#        --discovery-token-ca-cert-hash sha256:f123474dbe0fa8115644c6336474b82a94e52cf75ad38bee0bc674ea10c50bfd

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

#칼리코 퀵스타트()
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
#여기 부분에서 init한 대역폭이롱 똑같이 수정해서 실행 시켜줘야함.
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml 
#watch kubectl get pods -n calico-system
#마스터노드 확인
#kubectl taint nodes --all node-role.kubernetes.io/master-



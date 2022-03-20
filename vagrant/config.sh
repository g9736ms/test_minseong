#!/bin/bash

curl -L https://github.com/kubesphere/kubekey/releases/download/v1.2.0-alpha.4/kubekey-v1.2.0-alpha.4-linux-amd64.tar.gz > installer.tar.gz && tar -zxf installer.tar.gz

# install bash-completion for kubectl 
yum install bash-completion -y 

alias k=kubectl
complete -F __start_kubectl k

# kubectl completion on bash-completion dir
kubectl completion bash >/etc/bash_completion.d/kubectl
echo 'source <(kubectl completion bash)' >>/root/.bashrc

# alias kubectl to k 
echo 'alias k=kubectl' >> /root/.bashrc
echo 'complete -F __start_kubectl k' >> /root/.bashrc


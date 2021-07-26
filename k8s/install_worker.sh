#!/bin/bash
#TCP 포트 오픈 시켜줘야할것
# 10250[kubelet API], 30000-32767[NodePort 서비스]

scp root@[maskterIP]/~/kubeinit.txt:/root
sh ~/kubeinit.txt

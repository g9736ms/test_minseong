#!/bin/bash

if [ $# -eq 2 ]; then
  mkdir -p ${1}
  echo "$nfsdir ${2}(rw,sync,no_root_squash)" >> /etc/exports
  if [[ $(systemctl is-enabled nfs) -eq "disabled" ]]; then
    systemctl enable nfs
  fi
   systemctl restart nfs
else
  echo "ex) mk_nfs.sh <name> <xxx.xxx.xxx.xxx/xx>"
  exit 0
fi

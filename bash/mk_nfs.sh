#!/bin/bash

if [ $# -eq 2 ]; then
  if [[ ! -d $nfsdir ]]; then
    mkdir -p $nfsdir
    echo "$nfsdir ${1}(rw,sync,no_root_squash)" >> /etc/exports
    if [[ $(systemctl is-enabled nfs) -eq "disabled" ]]; then
      systemctl enable nfs
    fi
     systemctl restart nfs
  fi
else
  echo "ex) mk_nfs.sh <name> <xxx.xxx.xxx.xxx/xx>"
  exit 0
fi

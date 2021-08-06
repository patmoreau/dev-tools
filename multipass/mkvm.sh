#!/bin/zsh

VM_NAME=$1

multipass launch -c 2 -d 40G -m 4G -n $VM_NAME --cloud-init ./cloud-config.yml
ssh ubuntu@$VM_NAME.local
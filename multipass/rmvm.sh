#!/bin/zsh

VM_NAME=$1

multipass delete $VM_NAME
multipass purge
ssh-keygen -R $VM_NAME.local
#!/bin/bash

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg 
apt-get update > /dev/null 2>&1
apt-get install -y apt-transport-https ca-certificates curl pdsh > /dev/null 2>&1
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

ssh node01 'curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg'
ssh node01 "apt-get update > /dev/null 2>&1"
ssh node01 "apt-get install -y apt-transport-https ca-certificates curl"
ssh node01 'echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" |tee /etc/apt/sources.list.d/kubernetes.list'

echo "******* 1/2 Upgrading cluster to v.1.19 *******"


#kubeadm config images pull --kubernetes-version 1.19.0 > /dev/null 2>&1

apt-get update
apt-get install -y --allow-change-held-packages kubeadm=1.19.0-00 > /dev/null 2>&1
kubeadm upgrade apply v1.19.0 --yes --ignore-preflight-errors=all > /dev/null 2>&1
apt-get install -y kubelet=1.19.0-00 kubectl=1.19.0-00 > /dev/null 2>&1
systemctl restart kubelet

ssh node01 "apt-get update -y"
ssh node01 'apt-get install -y --allow-change-held-packages kubeadm=1.19.0-00 > /dev/null 2>&1'
ssh node01 "kubeadm upgrade node > /dev/null 2>&1"
ssh node01 "apt-get install -y kubelet=1.19.0-00 kubectl=1.19.0-00 > /dev/null 2>&1"
ssh node01 "systemctl restart kubelet"

kubectl get nodes -o wide
echo

sleep 10

echo "******* 2/2  Upgrading cluster to v.1.20 *******"


apt-get update -y 
apt-get install -y --allow-change-held-packages kubeadm=1.20.4-00 > /dev/null 2>&1
kubeadm upgrade apply v1.20.4 --yes --ignore-preflight-errors=all > /dev/null 2>&1
apt-get install -y kubelet=1.20.4-00 kubectl=1.20.4-00 > /dev/null 2>&1
systemctl restart kubelet

ssh node01 'apt-get install -y --allow-change-held-packages kubeadm=1.20.4-00 > /dev/null 2>&1'
ssh node01 'skubeadm upgrade node' > /dev/null 2>&1
ssh node01 "apt-get install -y kubelet=1.20.4-00 kubectl=1.20.4-00 > /dev/null 2>&1"
ssh node01 "systemctl restart kubelet"

sleep 10

echo "-*-*-*-  Cluster v1.20.4 Ready -*-*-*"

kubectl get nodes -o wide

#!/bin/sh
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.20.0+k3s1 sh -
echo '*** k3s installed ****'
kubectl get nodes -o wide
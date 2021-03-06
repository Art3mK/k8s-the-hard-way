#!/bin/bash

KUBERNETES_PUBLIC_ADDRESS=$(grep api_public_dns_name ../../infra/data.txt | awk -F ' = ' '{print $2}')
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../../tls/ca/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=../../tls/controller-manager/kube-controller-manager.pem \
  --client-key=../../tls/controller-manager/kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-controller-manager \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
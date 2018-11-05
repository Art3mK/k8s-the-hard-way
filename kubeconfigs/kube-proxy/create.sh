#!/bin/bash

KUBERNETES_PUBLIC_ADDRESS=$(grep api_public_dns_name ../../infra/data.txt | awk -F ' = ' '{print $2}')

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../../tls/ca/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS} \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate=../../tls/kube-proxy/kube-proxy.pem \
  --client-key=../../tls/kube-proxy/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

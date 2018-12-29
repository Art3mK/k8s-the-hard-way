#!/bin/bash

KUBERNETES_PUBLIC_ADDRESS=$(grep api_public_dns_name ../../infra/data.txt | awk -F ' = ' '{print $2}')

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../../tls/ca/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS} \
  --kubeconfig=admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=../../tls/admin/admin.pem \
  --client-key=../../tls/admin/admin-key.pem \
  --embed-certs=true \
  --kubeconfig=admin.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=admin \
  --kubeconfig=admin.kubeconfig

kubectl config use-context default --kubeconfig=admin.kubeconfig
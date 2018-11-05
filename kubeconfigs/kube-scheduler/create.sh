#!/bin/bash

KUBERNETES_PUBLIC_ADDRESS=$(grep api_public_dns_name ../../infra/data.txt | awk -F ' = ' '{print $2}')
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../../tls/ca/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
  --client-certificate=../../tls/kube-scheduler/kube-scheduler.pem \
  --client-key=../../tls/kube-scheduler/kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-scheduler \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
#!/bin/bash

API_PUBLIC_NAME=$(grep api_public_dns_name ../../infra/data.txt | awk -F ' = ' '{print $2}')

for instance in worker-1 worker-2 worker-3 ctrl-1 ctrl-2 ctrl-3; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=../../tls/ca/ca.pem \
    --embed-certs=true \
    --server=https://${API_PUBLIC_NAME} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=../../tls/workers/${instance}.pem \
    --client-key=../../tls/workers/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done

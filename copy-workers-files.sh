#!/bin/bash

for instance in worker-1 worker-2 worker-3; do
    instance_ip=$(grep ${instance} infra/data.txt | awk -F ' = ' '{print $2}')
    ctrl_ip=$(grep controller_1_public_ip infra/data.txt | awk -F ' = ' '{print $2}')
    echo $instance_ip
    scp -oProxyCommand="ssh ubuntu@${ctrl_ip} -W %h:%p" kubeconfigs/kube-proxy/kube-proxy.kubeconfig kubeconfigs/kubelet/${instance}.kubeconfig tls/ca/ca.pem tls/workers/${instance}-key.pem tls/workers/${instance}.pem ubuntu@${instance_ip}:~/
done
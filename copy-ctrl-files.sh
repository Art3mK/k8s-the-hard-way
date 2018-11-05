#!/bin/bash

for instance in controller_1 controller_2 controller_3; do
    instance_ip=$(grep ${instance}_public_ip infra/data.txt | awk -F ' = ' '{print $2}')
    echo $instance_ip
    scp \
        tls/ca/ca.pem \
        tls/ca/ca-key.pem \
        tls/service-account/service-account-key.pem \
        tls/service-account/service-account.pem \
        tls/api-server/kubernetes.pem \
        tls/api-server/kubernetes-key.pem \
        kubeconfigs/kube-scheduler/kube-scheduler.kubeconfig \
        kubeconfigs/kube-controller-manager/kube-controller-manager.kubeconfig \
        tls/encryption-config/encryption-config.yaml \
        etcd/${instance}_etcd.service \
        kube-api-server-config/${instance}_kube-apiserver.service \
        kube-ctrl-manager-config/kube-controller-manager.service \
        kubeconfigs/kube-admin/admin.kubeconfig \
        ubuntu@${instance_ip}:~/
done

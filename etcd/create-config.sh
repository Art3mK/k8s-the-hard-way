#!/bin/bash

for ctrl in controller_1 controller_2 controller_3; do
    INTERNAL_IP=$(grep ${ctrl}_private_ip ../infra/data.txt | awk -F ' = ' '{print $2}')
    CTRL_1_IP=$(grep controller_1_private_ip ../infra/data.txt | awk -F ' = ' '{print $2}')
    CTRL_2_IP=$(grep controller_2_private_ip ../infra/data.txt | awk -F ' = ' '{print $2}')
    CTRL_3_IP=$(grep controller_3_private_ip ../infra/data.txt | awk -F ' = ' '{print $2}')
cat > ${ctrl}_etcd.service <<EOF
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
--name ${ctrl} \\
--cert-file=/etc/etcd/kubernetes.pem \\
--key-file=/etc/etcd/kubernetes-key.pem \\
--peer-cert-file=/etc/etcd/kubernetes.pem \\
--peer-key-file=/etc/etcd/kubernetes-key.pem \\
--trusted-ca-file=/etc/etcd/ca.pem \\
--peer-trusted-ca-file=/etc/etcd/ca.pem \\
--peer-client-cert-auth \\
--client-cert-auth \\
--initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
--listen-peer-urls https://${INTERNAL_IP}:2380 \\
--listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
--advertise-client-urls https://${INTERNAL_IP}:2379 \\
--initial-cluster-token etcd-cluster-0 \\
--initial-cluster controller_1=https://${CTRL_1_IP}:2380,controller_2=https://${CTRL_2_IP}:2380,controller_3=https://${CTRL_3_IP}:2380 \\
--initial-cluster-state new \\
--data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
done
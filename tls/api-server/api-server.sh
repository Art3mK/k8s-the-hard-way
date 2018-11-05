cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "FI",
      "L": "Tampere",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Pыrkanmaa"
    }
  ]
}
EOF

CTRL_1_IP=$(grep controller_1_private_ip ../../infra/data.txt | awk -F ' = ' '{print $2}')
CTRL_2_IP=$(grep controller_2_private_ip ../../infra/data.txt | awk -F ' = ' '{print $2}')
CTRL_3_IP=$(grep controller_3_private_ip ../../infra/data.txt | awk -F ' = ' '{print $2}')
API_PUBLIC_NAME=$(grep api_public_dns_name ../../infra/data.txt | awk -F ' = ' '{print $2}')

cfssl gencert \
  -ca=../ca/ca.pem \
  -ca-key=../ca/ca-key.pem \
  -config=../ca/ca-config.json \
  -hostname=10.32.0.1,${API_PUBLIC_NAME},${CTRL_1_IP},${CTRL_2_IP},${CTRL_3_IP},127.0.0.1,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.default.svc.cluster.local \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes
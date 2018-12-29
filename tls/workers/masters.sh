for instance in ctrl-1 ctrl-2 ctrl-3; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "FI",
      "L": "Tampere",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Pыrkanmaa"
    }
  ]
}
EOF

EXTERNAL_IP=$(grep ${instance}_public_ip ../../infra/data.txt | awk -F ' = ' '{print $2}')
INTERNAL_IP=$(grep ${instance}_private_ip ../../infra/data.txt | awk -F ' = ' '{print $2}')

cfssl gencert \
  -ca=../ca/ca.pem \
  -ca-key=../ca/ca-key.pem \
  -config=../ca/ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done
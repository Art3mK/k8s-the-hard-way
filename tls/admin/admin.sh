cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "FI",
      "L": "Tampere",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Pыrkanmaa"
    }
  ]
}
EOF

cfssl gencert \
  -ca=../ca/ca.pem \
  -ca-key=../ca/ca-key.pem \
  -config=../ca/ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin

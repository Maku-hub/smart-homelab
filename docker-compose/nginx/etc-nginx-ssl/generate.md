### Generate a private key and self-signed certificate
openssl req -x509 -nodes -new -sha512 -days 10950 -newkey rsa:4096 -keyout ca.key -out ca.pem -subj "/C=PL/CN=Maku Development Certificate Authority"

### Verify certificate data
openssl x509 -in ca.pem -text -noout

### Create a .crt certificate file
openssl x509 -outform pem -in ca.pem -out ca.crt

### Generate an x509 v3 extension file
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names 
[alt_names]
# List your domain names here
DNS.1 = maku.local
DNS.2 = *.maku.local
EOF

### Generate a private key and certificate sign request (CSR)
openssl req -new -nodes -newkey rsa:4096 -keyout tls.key -out tls.csr -subj "/C=PL/ST=Masovian/L=Warsaw/O=Maku Company SA/CN=*.maku.local"

### Generate a self-signed certificate:
openssl x509 -req -sha512 -days 365 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in tls.csr -out tls.crt

### Verify if the signed certificate is valid
openssl verify -verbose -CAfile ca.pem tls.crt

### 
cp ca.crt ../usr-share-nginx-html/share/
cp ca.crt ../../gitlab/certs-runner/

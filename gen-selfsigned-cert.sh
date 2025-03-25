#!/bin/bash

#This script is using for generate self-signed cert. Make sure you have filled in every env that required
#ENV
domain=keycloak-ssc2.amigo.vn
filename=keycloak

#Create config file
echo "[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_ca
prompt = no

[req_distinguished_name]
CN = $domain

[v3_ca]
keyUsage = critical, keyCertSign, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
basicConstraints = critical, CA:TRUE
subjectKeyIdentifier = hash
subjectAltName = @alt_names

[alt_names]
DNS.1 = $domain" > $filename.cnf

echo 'Config file generated $domain.cnf'

# Create private key
openssl genrsa -out $filename.key 4096

echo "$filename.key has been generated"

# Create cert
openssl req -new -x509 -key $filename.key -out $filename.crt -days 365 -config $filename.cnf

echo "$filename.crt has been generated"

echo "Finished"

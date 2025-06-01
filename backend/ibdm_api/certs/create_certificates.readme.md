### Reference
Article: https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/

### Dependencies
- openssl(openssl is included in the git bash windows terminal)

### Steps:

#### Create Your Own CA
this is only done once then you can reuse it to sign certificates (for other projects as well)
1. generate CA
```bash
# you should create this outside of the project folder
openssl genrsa -des3 -out myCA.key 2048

openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
```

2. install CA
    
```bash
```
    for linux
```bash
sudo apt-get install -y ca-certificates
sudo cp myCA.pem /usr/local/share/ca-certificates/myCA.crt
sudo update-ca-certificates
```

    for mac
```bash

sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" myCA.pem

```

    for windows and Ios
check the referenced [article]('https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/').

    for. android
check this [article]('https://support.google.com/pixelphone/answer/2844832?hl=en')


#### create project certificate and sign it using the CA

1. review the configuration of the certificate in [ibdm.ext](./ibdm.ext)
    
2. create and sign certificate

```bash
openssl genrsa -out ibdm.key 2048
openssl req -new -key ibdm.key -out ibdm.csr
openssl x509 -req -in ibdm.csr -CA path/to/certs/myCA.pem -CAkey path/to/certs/myCA.key \
-CAcreateserial -out ibdm.crt -days 825 -sha256 -extfile ibdm.ext
```
3. copy the CA file into ibdmCA.crt (used as target ca for downloading from the application) 

#### create pfx certificate used by the windows app installer
```bash
openssl pkcs12 -export -out ibdm.pfx -inkey ibdm.key -in ibdm.crt
```

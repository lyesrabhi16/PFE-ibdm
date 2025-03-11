### Reference
Article: https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/

### Dependencies
- openssl/winpty

### Steps:

#### Create Your Own CA
this is only done once then you can reuse it to sign certificates (for other projects as well)
1. generate CA
    1. linux/mac:
```bash
# you should create this outside of the project folder
openssl genrsa -des3 -out myCA.key 2048

openssl req -x509 -new -nodes -key myCA.key -sha256 -days 1825 -out myCA.pem
```
    2. windows:
```bash
# you should create this outside of the project folder
winpty openssl genrsa -des3 -out myCA.key 2048
```

2. install CA
    1. linux
```bash
sudo apt-get install -y ca-certificates
sudo cp myCA.pem /usr/local/share/ca-certificates/myCA.crt
sudo update-ca-certificates
```
    2. mac
```bash

sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" myCA.pem

```
    3. windows and Ios
check the referenced [article]('https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/').

    4. android
check this [article]('https://support.google.com/pixelphone/answer/2844832?hl=en')


#### create project certificate and sign it using the CA
1. cd into backend/config/certificates/

2. add your ip to [ibdm.ext](./certificates/ibdm.ext)
    
3. create and sign certificate

        1. linux/mac
```bash
openssl genrsa -out ibdm.key 2048
openssl req -new -key ibdm.key -out ibdm.csr
openssl x509 -req -in ibdm.csr -CA path/to/certs/myCA.pem -CAkey path/to/certs/myCA.key \
-CAcreateserial -out ibdm.crt -days 825 -sha256 -extfile ibdm.ext
```
        2. windows
```bash
winpty genrsa -out ibdm.key 2048
winpty req -new -key ibdm.key -out ibdm.csr
winpty x509 -req -in ibdm.csr -CA path/to/certs/myCA.pem -CAkey path/to/certs/myCA.key \
-CAcreateserial -out ibdm.crt -days 825 -sha256 -extfile ibdm.ext
```
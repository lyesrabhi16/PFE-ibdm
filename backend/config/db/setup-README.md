# Start The Mongo Cluster
1. copy paste the .env.example and rename it to .env
2. .env contains configuration you can change if you want
3. create keyfile in files directory

For linux
```
openssl rand --base64 786 > files/keyfile
```

For Windows (if OpenSSL is installed):
```
openssl rand -base64 786 | Out-File -Encoding default files\keyfile
```
Note: OpenSSL is not installed by default on Windows. You may need to install it separately or use a different method to generate the keyfile.

For Windows (using PowerShell):
```
$randomBytes = [byte[]]::new(786)
[Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($randomBytes)
[Convert]::ToBase64String($randomBytes) | Out-File -Encoding default files\keyfile
```

4. start the shards, config servers and mongos  containers 
### Shards
1. turn on the shards
```
docker compose -f shards_site1.yaml up -d
docker compose -f shards_site2.yaml up -d
docker compose -f shards_site3.yaml up -d
```

2. wait 1~2 minutes and check if all containers are healthy ( except shard_4 containers )

execute this command and check in the status column or use the docker extension(it tells you if a container is healthy between brackets)
```
docker ps
```

3. run the shards setup
```
docker compose -f shards_setup.yaml
```

4. check if the setup containers exited with 0
with this command or the docker extension
```
docker ps -a
```

5. after 30s to 1 minute check if all containers are healthy
with this command or the docker extension
```
docker ps
``` 

6. if they are not, try restarting the unhealthy container
```
docker restart container_name 
```

### Config servers
1. start the containers
```
docker compose -f config_servers.yaml up -d
```

2. wait 1 minute and check if all containers except cfg-svr-1 are healthy with this command or docker extension
```
docker ps
```

### Mongos
1. start the containers
```
docker compose -f mongos.yaml up -d
```
2. after 1 minute check if setup-mongos container exited with 0 with the extension or this command 
```
docker ps -a
```

3. at this point the mongo cluster should be up, check if all containers are healthy including
mongos with the extension or this command
```
docker ps
```


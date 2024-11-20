## Set up Sharding using Docker Containers
### Create network
```
docker network create mongo-cluster
```

### Config servers
Start config servers (3 member replica set)
```
docker-compose -f config_servers/docker-compose.yaml up -d
```
Initiate replica set
```
mongosh mongodb://172.16.103.44:60001
```
```
rs.initiate(
  {
    _id: "cfgrs",
    configsvr: true,
    members: [
      { _id : 0, host : "cfg-svr-1:27017" },
      { _id : 1, host : "cfg-svr-2:27017" },
      { _id : 2, host : "cfg-svr-3:27017" }
    ]
  }
)

rs.status()
```

### Shard servers
Start shard servers (3 member replicas set)
```
docker compose -f shards/site1/docker-compose.yaml up -d
```
Initiate replica set
```
mongosh mongodb://172.16.103.44:40101
```
```
rs.initiate(
  {
    _id: "site1rs",
    members: [
      { _id : 0, host : "site1_shard_1:27017" },
      { _id : 1, host : "site1_shard_2:27017" },
      { _id : 2, host : "site1_shard_3:27017" }
    ]
  }
)

rs.status()
```

### Mongos Router
Start mongos query router
```
docker compose -f mongos/docker-compose.yaml up -d
```

### Add shard to the cluster
Connect to mongos
```
mongosh mongodb://172.16.103.44:60000
```
Add shard
```
mongos> sh.addShard("site1rs/site1_shard_1:27017,site1_shard_2:27017,site1_shard_3:27017")
mongos> sh.status()
```
## Adding another shard
### Shard 2 servers
Start shard 2 servers (3 member replicas set)
```
docker-compose -f shard2/docker-compose.yaml up -d
```
Initiate replica set
```
mongosh mongodb://172.16.103.44:50004
```
```
rs.initiate(
  {
    _id: "site3rs",
    members: [
      { _id : 0, host : "site3_shard_1" },
      { _id : 1, host : "site3_shard_2" },
      { _id : 2, host : "site3_shard_3" }
    ]
  }
)

rs.status()
```
### Add shard to the cluster
Connect to mongos
```
mongosh mongodb://172.16.103.44:60000
```
Add shard
```
mongos> sh.addShard("site3rs/site3_shard_1:27017,site3_shard_2:27017,site3_shard_3:27017")
mongos> sh.status()
mongos> sh.addShardTag("site3rs", "site3")
mongos> sh.addTagRange("ibdm.machines", { site: "site3", _id: MinKey }, { site: "site3", _id: MaxKey}, "site3")
```


### Enable sharding for a database
```
mongos> sh.enableSharding("ibdm")
mongos> sh.shardCollection("ibdm.machines", { site: 1, _id: 1 })
```
```

### Zone sharding

#### Create zones
```
sh.disableBalancing("ibdm.machines")
sh.addShardTag("site1rs", "site1")
sh.addShardTag("site2rs", "site2")
```

#### Define zone ranges
```
sh.addTagRange("ibdm.machines", { site: "site1", _id: MinKey }, { site: "site1", _id: MaxKey }, "site1")
sh.addTagRange("ibdm.machines", { site: "site2", _id: MinKey }, { site: "site2", _id: MaxKey }, "site2")
```

#### Enable balancing
```
sh.enableBalancing("ibdm.machines")
```

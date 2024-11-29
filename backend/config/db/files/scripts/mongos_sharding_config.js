sh.addShard("site1rs/site1_shard_1:27017,site1_shard_2:27017,site1_shard_3:27017,site1_shard_4:27017");
sh.addShard("site2rs/site2_shard_1:27017,site2_shard_2:27017,site2_shard_3:27017","site2_shard_4:27017");
sh.addShard("site3rs/site3_shard_1:27017,site3_shard_2:27017,site3_shard_3:27017","site3_shard_4:27017");

sh.enableSharding("ibdm");
sh.shardCollection("ibdm.machines", { site: 1, _id: 1 });
sh.disableBalancing("ibdm.machines");

sh.addShardTag("site1rs", "site1");
sh.addShardTag("site2rs", "site2");
sh.addShardTag("site3rs", "site3");

sh.addTagRange("ibdm.machines", { site: "site1", _id: MinKey }, { site: "site1", _id: MaxKey }, "site1");
sh.addTagRange("ibdm.machines", { site: "site2", _id: MinKey }, { site: "site2", _id: MaxKey }, "site2");
sh.addTagRange("ibdm.machines", { site: "site3", _id: MinKey }, { site: "site3", _id: MaxKey }, "site3"); 

sh.enableBalancing("ibdm.machines");
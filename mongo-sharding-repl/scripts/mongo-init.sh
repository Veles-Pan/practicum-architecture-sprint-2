#!/bin/bash

docker exec -i configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
EOF

docker exec -i shard1_primary mongosh --port 27018 --quiet <<EOF
rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1_primary:27018" },
      { _id : 1, host : "shard1_secondary1:27018" },
      { _id : 2, host : "shard1_secondary2:27018" }
    ]
  }
);
EOF

docker exec -i shard2_primary mongosh --port 27019 --quiet <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 0, host : "shard2_primary:27019" },
      { _id : 1, host : "shard2_secondary1:27019" },
      { _id : 2, host : "shard2_secondary2:27019" }
    ]
  }
);
EOF

docker exec -i mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1_primary:27018,shard1_secondary1:27018,shard1_secondary2:27018");
sh.addShard("shard2/shard2_primary:27019,shard2_secondary1:27019,shard2_secondary2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );

use somedb;

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});

db.helloDoc.countDocuments();
EOF
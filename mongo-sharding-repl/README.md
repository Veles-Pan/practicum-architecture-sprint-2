# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Инициализируем сервер-конфигурацию:

```shell
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
```

Инициализируем шарды:

```shell
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
```

```shell
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
```

Инициализируем роутер, создаём базу `somedb`, коллекцию `helloDoc` и заполняем всё тестовыми данными:

```shell
docker exec -i mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1_primary:27018,shard1_secondary1:27018,shard1_secondary2:27018");
sh.addShard("shard2/shard2_primary:27019,shard2_secondary1:27019,shard2_secondary2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );

use somedb;

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});

db.helloDoc.countDocuments();
EOF
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

#### Как проверить элементы в каждом из шардов?

Для главного шарда запустите команду:

```shell
docker exec -i shard1_primary mongosh --port 27018  --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF
```

Для реплик запустите команду:

```shell
docker exec -i shard1_secondary1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF
```

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs

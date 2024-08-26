# pymongo-api

## Как запустить

переходим в папку актуального проекта и запускаем mongodb и приложение

```shell
cd sharding-repl-cache
docker compose up -d
```

Инициализируем сервер-конфигурацию:

```shell
cd sharding-repl-cache
./scripts/mongo-init.sh
```

Если вы хотите запустить все этапы отдельно, то с командами можно ознакомиться в [README](./sharding-repl-cache/README.md)

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

#### Как проверить элементы в каждом из шардов?

```shell
docker exec -i <shard_name> mongosh --port <shard_port> --quiet <<EOF
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

## Схема приложения draw.io

Схема приложения с Service Discovery, балансировкой и CDN доступна по [ссылке](https://viewer.diagrams.net/index.html?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=sprint2-task1.drawio#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1ELEBBJmMoOIYXKvBhbNbGtyVXk7VlRzi%26export%3Ddownload#%7B%22pageId%22%3A%22-H_mtQnk-PTXWXPvYvuk%22%7D)

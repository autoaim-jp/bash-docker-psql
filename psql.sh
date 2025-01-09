#!/bin/bash

##
# 接続用スクリプト
# usage: ./psql.sh
# ※ 実行前に下記変数を実際の環境に合わせて変更してください
##

# ▼ Compose コンテナ名 (例: mycontainer) 
CONTAINER_NAME="mermaid-chatgpt-editor-postgresql"

# ▼ PostgreSQL 接続情報
DB_NAME="xl_db"
DB_USER="postgres"
DB_PASSWORD="postgres"

# Dockerでpostgresコンテナに入り、psqlを実行
docker exec \
  -it ${CONTAINER_NAME}\
  psql \
    -U "${DB_USER}" \
    "${DB_NAME}"


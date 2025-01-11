#!/bin/bash

##
# 接続用スクリプト
# usage: ./backup2.sh
# ※ 実行前に下記変数を実際の環境に合わせて変更してください
##

# ▼ Compose コンテナ名 (例: mycontainer) 
CONTAINER_NAME="mermaid-chatgpt-editor-postgresql"

# ▼ PostgreSQL 接続情報
DB_NAME="xl_db"
DB_USER="postgres"
DB_PASSWORD="postgres"

# ▼ バックアップを保存するホスト側ディレクトリ
BACKUP_DIR=$(realpath "./backup")
mkdir -p $BACKUP_DIR

# ▼ バックアップファイルの日付フォーマット
DATE_STR=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_${DB_NAME}_${DATE_STR}.sql"

# Dockerでpostgresコンテナに入り、psqlを実行
docker exec \
  -it ${CONTAINER_NAME}\
  pg_dump \
    -U "${DB_USER}" \
    "${DB_NAME}" \
    > "${BACKUP_DIR}/${BACKUP_FILE}"


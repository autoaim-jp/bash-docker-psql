#!/bin/bash

##
# 削除用スクリプト
# usage: ./delete.sh
# ※ 実行前に下記変数を実際の環境に合わせて変更してください
##

echo "**************************************************"
echo "これは削除処理です。続けても構いませんか？ "
echo "**************************************************"
echo -n "入力(y/n): "
read -r answer

if [ "$answer" != "y" ]; then
  echo "処理を終了します。"
  exit 1
fi

echo "削除を実行します。"

# ▼ Compose コンテナ名 (例: mycontainer) 
CONTAINER_NAME="mermaid-chatgpt-editor-postgresql"

# ▼ PostgreSQL 接続情報
DB_NAME="xl_db"
DB_USER="postgres"
DB_PASSWORD="postgres"

# ▼ PostgreSQL スキーマ情報
DB_SCHEMA="chat_info"

# Dockerでpostgresコンテナに入り、スキーマを再作成
docker exec \
  -it ${CONTAINER_NAME}\
  psql \
    -U "${DB_USER}" \
    "${DB_NAME}" \
    -c "DROP SCHEMA ${DB_SCHEMA} CASCADE; CREATE SCHEMA ${DB_SCHEMA};"


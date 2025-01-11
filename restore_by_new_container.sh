#!/bin/bash

##
# リストア用スクリプト
# usage: ./restore.sh <restore_file.sql>
# 例: ./restore.sh backup_mydatabase_20250101_120000.sql
#
# バックアップファイルを指定せずに実行するとエラーになります。
##

echo "**************************************************"
echo "これはリストア処理です。続けても構いませんか？ "
echo "**************************************************"
echo -n "入力(y/n): "
read -r answer

if [ "$answer" != "y" ]; then
  echo "処理を終了します。"
  exit 1
fi

echo "リストアを実行します。"

# ▼ Compose プロジェクト名 (例: myproject) 
PROJECT_NAME="mermaid-chatgpt-editor"
# ▼ Docker Compose で自動生成されるネットワーク名 (例: myproject_default)
NETWORK_NAME="${PROJECT_NAME}_default"

# ▼ PostgreSQL 接続情報
DB_HOST="mermaid-chatgpt-editor-postgresql"
DB_NAME="xl_db"
DB_USER="postgres"
DB_PASSWORD="postgres"

# ▼ リストアするファイルが保存されているホスト側ディレクトリ
BACKUP_DIR=$(realpath "./backup")

# 引数チェック
if [ $# -lt 1 ]; then
  echo "Usage: $0 <backup_file.sql>"
  exit 1
fi

RESTORE_FILE="$1"

# ファイル存在チェック
if [ ! -f "${BACKUP_DIR}/${RESTORE_FILE}" ]; then
  echo "Error: File not found -> ${BACKUP_DIR}/${RESTORE_FILE}"
  exit 1
fi

echo "=== Restore Start: ${RESTORE_FILE} -> DB: ${DB_NAME} ==="

# Dockerでpostgresイメージを起動し、psqlでリストア
docker run --rm \
  --network "${NETWORK_NAME}" \
  -e PGPASSWORD="${DB_PASSWORD}" \
  -v "${BACKUP_DIR}:/backup" \
  postgres:14 \
  psql \
    -h "${DB_HOST}" \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    -f "/backup/${RESTORE_FILE}"

if [ $? -eq 0 ]; then
  echo "Restore completed successfully."
else
  echo "Restore failed."
  exit 1
fi


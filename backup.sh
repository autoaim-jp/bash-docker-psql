#!/bin/bash

##
# バックアップ用スクリプト
# usage: ./backup.sh
# ※ 実行前に下記変数を実際の環境に合わせて変更してください
##

# ▼ Compose プロジェクト名 (例: myproject) 
PROJECT_NAME="mermaid-chatgpt-editor"
# ▼ Docker Compose で自動生成されるネットワーク名 (例: myproject_default)
NETWORK_NAME="${PROJECT_NAME}_default"

# ▼ PostgreSQL 接続情報
DB_HOST="mermaid-chatgpt-editor-postgresql"
DB_NAME="xl_db"
DB_USER="xl_admin"
DB_PASSWORD="xl_pass"

# ▼ バックアップを保存するホスト側ディレクトリ
BACKUP_DIR=$(realpath "./backup")
mkdir -p $BACKUP_DIR

# ▼ バックアップファイルの日付フォーマット
DATE_STR=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_${DB_NAME}_${DATE_STR}.sql"

# ▼ 保持日数 (7日より古いバックアップを削除する例)
RETENTION_DAYS=7

echo "=== Backup Start: ${DB_NAME} ==="

# Dockerでpostgresイメージを起動し、pg_dumpでバックアップ
docker run --rm \
  --network "${NETWORK_NAME}" \
  -e PGPASSWORD="${DB_PASSWORD}" \
  -v "${BACKUP_DIR}:/backup" \
  postgres:14 \
  pg_dump \
    -h "${DB_HOST}" \
    -U "${DB_USER}" \
    "${DB_NAME}" \
    > "${BACKUP_DIR}/${BACKUP_FILE}"

if [ $? -eq 0 ]; then
  echo "Backup file created: ${BACKUP_DIR}/${BACKUP_FILE}"
else
  echo "Backup failed."
  exit 1
fi

# 古いバックアップの削除 (ローテーション)
echo "debug no cleanup"
# echo "Cleaning up old backups (older than ${RETENTION_DAYS} days)..."
# find "${BACKUP_DIR}" -type f -name "backup_${DB_NAME}_*.sql" -mtime +${RETENTION_DAYS} -exec rm -f {} \;

echo "Backup finished successfully."


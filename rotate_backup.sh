#!/bin/bash

CONTAINER_NAME="mermaid-chatgpt-editor-postgresql"
DB_NAME="xl_db"

BACKUP_DATA_DIR_PATH="./"

BACKUP_FILE_PREFIX="backup_${CONTAINER_NAME}_${DB_NAME}_"
LOG_FILE_PATH="./rotate.log"

RETENTION_DAY_N=7

echo "=============== $(date +%Y/%m/%d-%H:%M:%S) ===============" >> $LOG_FILE_PATH


# 対象となるファイルの件数をカウント -mtimeを使わない
file_count=$(find "${BACKUP_DATA_DIR_PATH}" -type f -name "${BACKUP_FILE_PREFIX}*" | wc -l)

# 対象ファイルが1個だけの場合は処理を終了
if [ "$file_count" -eq 1 ]; then
  echo "Only 1 file exists. Quit." >> $LOG_FILE_PATH
  echo "log file: ${LOG_FILE_PATH}"
  exit 0
fi


FILE_LIST=$(find "${BACKUP_DATA_DIR_PATH}" -type f -name "${BACKUP_FILE_PREFIX}*" -mtime +${RETENTION_DAY_N} -exec ls -la {} \;)

# 古いファイルをrotate
find "${BACKUP_DATA_DIR_PATH}" -type f -name "${BACKUP_FILE_PREFIX}*" -mtime +${RETENTION_DAY_N} -exec rm -f {} \;

echo "Cleaning up old backups (older than ${RETENTION_DAY_N} days)" >> $LOG_FILE_PATH
echo -e "$FILE_LIST" >> $LOG_FILE_PATH
echo "log file: ${LOG_FILE_PATH}"


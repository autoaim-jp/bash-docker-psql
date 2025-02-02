#!/bin/bash

CONTAINER_NAME="mermaid-chatgpt-editor-postgresql"
DB_NAME="xl_db"

BACKUP_DATA_DIR_PATH="./"

BACKUP_FILE_PREFIX="backup_${CONTAINER_NAME}_${DB_NAME}_"
LOG_FILE_PATH="./rotate.log"

RETENTION_DAY_N=30

FILE_LIST=$(find "${BACKUP_DATA_DIR_PATH}" -type f -name "${BACKUP_FILE_PREFIX}*" -mtime +${RETENTION_DAY_N} -exec ls -la {} \;)

# oldの中から古いものをrotate 
find "${BACKUP_DATA_DIR_PATH}" -type f -name "${BACKUP_FILE_PREFIX}*" -mtime +${RETENTION_DAY_N} -exec rm -f {} \;

echo "=============== $(date +%Y/%m/%d-%H:%M:%S) ===============" >> $LOG_FILE_PATH
echo "Cleaning up old backups (older than ${RETENTION_DAY_N} days)" >> $LOG_FILE_PATH
echo -e "$FILE_LIST" >> $LOG_FILE_PATH
echo "log file: ${LOG_FILE_PATH}"


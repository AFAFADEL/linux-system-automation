#!/bin/bash
# =================================================================
# Script Name: 03_log_archiver.sh
# Description: Archives and compresses system audit logs
# Concepts: tar, gzip, find, cron scheduling
# =================================================================

LOG_DIR="/var/log"
BACKUP_DIR="/backup/logs"
DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="logs_backup_${DATE}.tar.gz"

# إنشاء مجلد النسخ الاحتياطية إن لم يكن موجوداً
mkdir -p "$BACKUP_DIR"

echo "=== Starting Log Archival Process ==="

# أرشفة وضغط جميع ملفات audit التقارير
tar -czvf "${BACKUP_DIR}/${ARCHIVE_NAME}" ${LOG_DIR}/system_audit_*.log 2>/dev/null

if [ $? -eq 0 ]; then
    echo "[+] Backup successfully created: ${BACKUP_DIR}/${ARCHIVE_NAME}"
    # تنظيف التقارير التي يزيد عمرها عن 7 أيام من النظام
    find "$LOG_DIR" -name "system_audit_*.log" -mtime +7 -exec rm -f {} \;
    echo "[+] Old logs cleaned up."
else
    echo "[ERROR] Archiving failed!" >&2
    exit 1
fi

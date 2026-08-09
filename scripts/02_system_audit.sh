#!/bin/bash
# =================================================================
# Script Name: 02_system_audit.sh
# Description: Generates a system health check and security report
# Concepts: ps, find, grep, awk, redirection, piping, variables
# =================================================================

REPORT_FILE="/var/log/system_audit_$(date +%Y%m%d).log"

echo "==========================================" > "$REPORT_FILE"
echo "       SYSTEM AUDIT REPORT - $(date)      " >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"

# 1. معلومات النظام العامة
echo -e "\n--- 1. SYSTEM INFORMATION ---" >> "$REPORT_FILE"
echo "Hostname: $(hostname)" >> "$REPORT_FILE"
echo "Kernel Version: $(uname -r)" >> "$REPORT_FILE"
echo "Uptime: $(uptime -p)" >> "$REPORT_FILE"

# 2. أثر استهلاك الذاكرة والمعالج والعمليات الأعلى استهلاكاً
echo -e "\n--- 2. TOP 5 CPU CONSUMING PROCESSES ---" >> "$REPORT_FILE"
ps aux --sort=-%cpu | head -n 6 | awk '{print $1, $2, $3, $11}' >> "$REPORT_FILE"

# 3. التدقيق الأمني: البحث عن أي ملفات بـ صلاحيات 777 الخطرة
echo -e "\n--- 3. SECURITY AUDIT: World-Writable Files (777) ---" >> "$REPORT_FILE"
find /home /tmp -type f -perm 0777 2>/dev/null >> "$REPORT_FILE"

# 4. التقرير عن حالة المساحة التخزينية
echo -e "\n--- 4. DISK USAGE STATUS ---" >> "$REPORT_FILE"
df -h / >> "$REPORT_FILE"

echo -e "\n[+] Audit Report generated successfully at: $REPORT_FILE"
cat "$REPORT_FILE"

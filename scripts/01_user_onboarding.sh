#!/bin/bash
# =================================================================
# Script Name: 01_user_onboarding.sh
# Description: Automates creation of groups, users, and home dirs
# Concepts: Useradd, Groupadd, Chmod, Chown, Redirection, Loops
# =================================================================

CSV_FILE="../config/users_list.csv"

# التأكد من تشغيل السكربت بصلاحيات Root
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] You must run this script as root!" >&2
  exit 1
fi

if [ ! -f "$CSV_FILE" ]; then
    echo "[ERROR] Config file $CSV_FILE not found!" >&2
    exit 1
fi

echo "=== Starting User Onboarding Process ==="

# قراءة الملف خطوة بخطوة مع تجاوز السطر الأول (Header)
tail -n +2 "$CSV_FILE" | while IFS=',' read -r username group shell
do
    # 1. إنشاء المجموعة إذا لم تكن موجودة
    if ! getent group "$group" >/dev/null 2>&1; then
        groupadd "$group"
        echo "[+] Group '$group' created."
    fi

    # 2. إنشاء المستخدم مع ضبط الصلاحيات والمجلد الشخصي
    if ! id "$username" >/dev/null 2>&1; then
        useradd -m -g "$group" -s "$shell" "$username"
        # تعيين كلمة سر افتراضية وإجبار التغيير عند أول دخول
        echo "$username:Password123!" | chpasswd
        chage -d 0 "$username"
        
        # ضبط صلاحيات مجلد المستخدم ليكون آمن (700)
        chmod 700 "/home/$username"
        echo "[+] User '$username' created and added to '$group'."
    else
        echo "[!] User '$username' already exists. Skipping."
    fi
done

echo "=== Onboarding Completed Successfully ==="

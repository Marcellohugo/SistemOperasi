#!/bin/bash
BASE_DIR="/home/marcomanalu/Documents/praktikum-modul-1-b14/cloud_storage"
log_file="$BASE_DIR/cloud_log.txt"
flag_file="$BASE_DIR/.download_flag"

last_login=$(tac "$log_file" | grep -m 1 "LOGIN: INFO User .* logged in")
last_logout=$(tac "$log_file" | grep -m 1 "LOGOUT: INFO User .* logged out")

if [[ -z "$last_login" ]]; then
    rm -f "$flag_file"
else
    login_date=$(echo "$last_login" | awk '{print $1}')
    login_time=$(echo "$last_login" | awk '{print $2}')
    IFS='/' read -r yy mm dd <<< "$login_date"
    login_ts="20${yy}-${mm}-${dd} ${login_time}"
    login_epoch=$(date -d "$login_ts" +%s 2>/dev/null)

    if [[ -n "$last_logout" ]]; then
        logout_date=$(echo "$last_logout" | awk '{print $1}')
        logout_time=$(echo "$last_logout" | awk '{print $2}')
        IFS='/' read -r yy mm dd <<< "$logout_date"
        logout_ts="20${yy}-${mm}-${dd} ${logout_time}"
        logout_epoch=$(date -d "$logout_ts" +%s 2>/dev/null)
        
        if [[ $login_epoch -le $logout_epoch ]]; then
            rm -f "$flag_file"
        fi
    fi
fi

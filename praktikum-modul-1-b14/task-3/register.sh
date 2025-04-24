#!/bin/bash
BASE_DIR="/home/marcomanalu/Documents/praktikum-modul-1-b14/cloud_storage"
users_file="$BASE_DIR/users.txt"
log_file="$BASE_DIR/cloud_log.txt"

log_message() {
    echo "$(date +'%y/%m/%d %T') $1" >> "$log_file"
}

validate_password() {
    local username=$1
    local password=$2
    
    [[ ${#password} -lt 8 ]] && { echo "Password too short"; return 1; }
    [[ ! "$password" =~ [A-Z] ]] && { echo "Missing uppercase letter"; return 1; }
    [[ ! "$password" =~ [0-9] ]] && { echo "Missing number"; return 1; }
    [[ ! "$password" =~ [@#\$%\^\&*+_!] ]] && { echo "Missing special character"; return 1; }
    [[ "$password" == "$username" ]] && { echo "Password same as username"; return 1; }
    [[ "${password,,}" == *"cloud"* ]] && { echo "Contains forbidden word"; return 1; }
    [[ "${password,,}" == *"storage"* ]] && { echo "Contains forbidden word"; return 1; }
    
    return 0
}

read -p "Username: " username
read -sp "Password: " password
echo

if [[ ! "$username" =~ ^[a-zA-Z0-9_]{4,}$ ]]; then
    log_message "REGISTER: ERROR Invalid username format"
    echo "Error: Username must be alphanumeric (min 4 chars)"
    exit 1
fi

if grep -q "^$username:" "$users_file"; then
    log_message "REGISTER: ERROR User already exists"
    echo "Error: User already exists"
    exit 1
fi

error=$(validate_password "$username" "$password")
if [ $? -ne 0 ]; then
    log_message "REGISTER: ERROR $error"
    echo "Error: $error"
    exit 1
fi

echo "$username:$password" >> "$users_file"
log_message "REGISTER: INFO User registered successfully"
echo "Registration successful!"

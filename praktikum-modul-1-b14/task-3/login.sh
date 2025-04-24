#!/bin/bash
BASE_DIR="/home/marcomanalu/Documents/praktikum-modul-1-b14/cloud_storage"
users_file="$BASE_DIR/users.txt"
log_file="$BASE_DIR/cloud_log.txt"
flag_file="$BASE_DIR/.download_flag"

log_message() {
    echo "$(date +'%y/%m/%d %T') $1" >> "$log_file"
}

check_session() {
    last_event=$(tac "$log_file" | grep -m 1 -E "LOGIN: INFO User |LOGOUT: INFO User ")
    [[ "$last_event" == *"LOGIN: INFO User "* ]] && echo "$(echo "$last_event" | awk '{print $NF}')" && return 1
    return 0
}

login() {
    read -p "Username: " username
    read -sp "Password: " password
    echo

    stored_pw=$(grep "^$username:" "$users_file" | cut -d: -f2)
    if [ -z "$stored_pw" ] || [ "$password" != "$stored_pw" ]; then
        log_message "LOGIN: ERROR Failed login attempt on user $username"
        echo "Invalid credentials"
        exit 1
    fi

    echo "$username" > "$flag_file"
    log_message "LOGIN: INFO User $username logged in"
    echo "Login successful!"
    
    # Trigger download immediately after login
    "/home/marcomanalu/Documents/praktikum-modul-1-b14/task-3/download.sh"

    trap 'logout "$username"' SIGINT
    
    # Session timeout (2 hour)
    timeout=7200
    start_time=$(date +%s)

    while true; do
        current_time=$(date +%s)
        if (( current_time - start_time > timeout )); then
            logout "$username"
        fi
        echo -ne "\rSession active: $(date +'%T') (CTRL+C to logout)"
        sleep 1
    done
}

logout() {
    log_message "LOGOUT: INFO User $1 logged out"
    rm -f "$flag_file"
    echo -e "\nLogged out successfully"
    exit 0
}

current_user=$(check_session)
if [ $? -ne 0 ]; then
    echo "User $current_user is logged in!"
    echo "Another user is already logged in. Please try again later."
    exit 0
else
    login
fi

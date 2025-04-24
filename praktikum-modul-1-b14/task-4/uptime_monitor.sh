#!/bin/bash

current_hour=$(date +%Y%m%d%H)
log_dir="/home/$USER/metrics"
log_file="$log_dir/uptime_$current_hour.log"

# Get uptime and load averages
uptime_info=$(uptime | sed 's/,.*//' | sed 's/^ *//')
load_avg=$(cat /proc/loadavg | awk '{print $1","$2","$3}')

# Write to log
echo "uptime,load_avg_1min,load_avg_5min,load_avg_15min" > "$log_file"
echo "$uptime_info,$load_avg" >> "$log_file"

chmod 600 "$log_file"

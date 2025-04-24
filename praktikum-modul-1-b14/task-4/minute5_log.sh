#!/bin/bash

# Get current timestamp
timestamp=$(date +%Y%m%d%H%M%S)

# Log directory
log_dir="/home/$USER/metrics"
mkdir -p "$log_dir"

# Log file path
log_file="$log_dir/metrics_$timestamp.log"

# Collect memory and swap data
mem_info=$(free -m | awk '/^Mem:/ {print $2","$3","$4","$5","$6","$7}')
swap_info=$(free -m | awk '/^Swap:/ {print $2","$3","$4}')

# Collect directory size
target_dir="/home/$USER/"
du_output=$(du -sh "$target_dir" 2>/dev/null)
if [ $? -eq 0 ]; then
    path_size=$(echo "$du_output" | awk '{print $1}')
    path_name=$(echo "$du_output" | awk '{print $2}')
else
    path_size="0B"
    path_name="$target_dir"
fi

# Write to log file
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$log_file"
echo "$mem_info,$swap_info,$path_name,$path_size" >> "$log_file"

# Set permissions
chmod 600 "$log_file"

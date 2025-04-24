#!/bin/bash

current_hour=$(date +%Y%m%d%H)
log_dir="/home/$USER/metrics"
agg_file="$log_dir/metrics_agg_$current_hour.log"

# Collect all 5-minute logs for the current hour
files=$(ls "$log_dir"/metrics_$current_hour*.log 2>/dev/null)

[ -z "$files" ] && exit 0

# Initialize variables and arrays
declare -A data
metrics=("mem_total" "mem_used" "mem_free" "mem_shared" "mem_buff" "mem_available" "swap_total" "swap_used" "swap_free" "path_size")
declare -a path_arr

# Read data from files
for file in $files; do
    line=$(tail -1 "$file")
    IFS=',' read -r mt mu mf ms mb ma st su sf p ps <<< "$line"
    data["mem_total"]+="$mt "
    data["mem_used"]+="$mu "
    data["mem_free"]+="$mf "
    data["mem_shared"]+="$ms "
    data["mem_buff"]+="$mb "
    data["mem_available"]+="$ma "
    data["swap_total"]+="$st "
    data["swap_used"]+="$su "
    data["swap_free"]+="$sf "
    data["path_size"]+="$(echo $ps | sed 's/[^0-9.]//g') "
    path_arr+=("$p")
done

# Ensure all paths are the same
path=$(echo "${path_arr[@]}" | tr ' ' '\n' | sort -u)
[ $(echo "$path" | wc -l) -ne 1 ] && echo "Error: Multiple paths found." >&2 && exit 1

# Calculate stats
calculate_stats() {
    local nums=($1)
    local min=${nums[0]}
    local max=${nums[0]}
    local sum=0
    for n in "${nums[@]}"; do
        if (( $(echo "$n < $min" | bc -l) )); then
            min=$n
        fi
        if (( $(echo "$n > $max" | bc -l) )); then
            max=$n
        fi
        sum=$(echo "$sum + $n" | bc -l)
    done
    avg=$(echo "scale=2; $sum / ${#nums[@]}" | bc)
    echo "$min $max $avg"
}

# Generate aggregated data
echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$agg_file"
for type in minimum maximum average; do
    line="$type"
    for metric in "${metrics[@]}"; do
        if [ "$metric" == "path_size" ]; then
            nums=(${data[$metric]})
            unit=$(echo ${ps//[0-9.]/})
            case $type in
                minimum) val=$(printf "%.0f" $(echo "${nums[*]}" | tr ' ' '\n' | sort -n | head -1)) ;;
                maximum) val=$(printf "%.0f" $(echo "${nums[*]}" | tr ' ' '\n' | sort -n | tail -1)) ;;
                average) val=$(printf "%.0f" $(echo "${nums[*]}" | tr ' ' '\n' | awk '{s+=$1} END {print s/NR}')) ;;
            esac
            line+=",,$val$unit"
        else
            stats=$(calculate_stats "${data[$metric]}")
            case $type in
                minimum) val=$(echo $stats | awk '{print $1}') ;;
                maximum) val=$(echo $stats | awk '{print $2}') ;;
                average) val=$(echo $stats | awk '{print $3}') ;;
            esac
            line+=",$val"
        fi
    done
    echo "$line" | sed 's/,,/,/g' >> "$agg_file"
done

chmod 600 "$agg_file"

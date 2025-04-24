#!/bin/bash

log_dir="/home/$USER/metrics"
find "$log_dir" -name "metrics_agg_*.log" -mtime +0.5 -exec rm -f {} \;

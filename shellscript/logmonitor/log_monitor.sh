#!/bin/bash

CONFIG="monitor.conf"
STATE_DIR="./.state"
REPORT="./report.log"
mkdir -p "$STATE_DIR"

read_config() {
    in_logs=false
    in_patterns=false
    LOG_FILES=()
    PATTERNS=()

    while read -r line; do
        [[ $line =~ ^#.*$ || -z $line ]] && continue
        [[ $line == "[LOG_FILES]" ]] && { in_logs=true; in_patterns=false; continue; }
        [[ $line == "[PATTERNS]" ]] && { in_patterns=true; in_logs=false; continue; }

        if $in_logs; then LOG_FILES+=("$line"); fi
        if $in_patterns; then PATTERNS+=("$line"); fi
    done < "$CONFIG"
}

monitor_logs() {
    echo "----- $(date) -----" >> "$REPORT"

    for logfile in "${LOG_FILES[@]}"; do
        state_file="${STATE_DIR}/$(basename "$logfile").state"
        last_line=1
        [[ -f $state_file ]] && last_line=$(cat "$state_file")
        total_lines=$(wc -l < "$logfile")
        new_lines=$((total_lines - last_line + 1))

        if (( new_lines > 0 )); then
            tail -n +"$last_line" "$logfile" > /tmp/new_log_lines.txt

            for pattern in "${PATTERNS[@]}"; do
                grep -i "$pattern" /tmp/new_log_lines.txt >> "$REPORT"
            done
        fi

        echo $((total_lines + 1)) > "$state_file"
    done
}

read_config
monitor_logs


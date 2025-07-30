#!/bin/bash

REPORT="./report.log"
LOG="./remediation.log"

echo "----- $(date) -----" >> "$LOG"

handle_error() {
    error="$1"
    case "$error" in
        *OutOfMemory*)
            echo "Detected OutOfMemory. Restarting myapp service..." | tee -a "$LOG"
            systemctl restart myapp.service
            ;;
        *No\ space\ left*|*Disk\ Full*)
            echo "Disk full detected. Cleaning up /tmp..." | tee -a "$LOG"
            rm -rf /tmp/*
            ;;
        *Connection\ reset*|*Connection\ refused*)
            echo "Connection issue. Restarting nginx..." | tee -a "$LOG"
            systemctl restart nginx
            ;;
        *ERROR*)
            echo "Generic ERROR found. Logging only." | tee -a "$LOG"
            ;;
        *)
            echo "Unknown error: $error" | tee -a "$LOG"
            ;;
    esac
}

# Only scan the most recent section
tac "$REPORT" | awk '/-----/{exit} {print}' | tac | while read -r line; do
    handle_error "$line"
done

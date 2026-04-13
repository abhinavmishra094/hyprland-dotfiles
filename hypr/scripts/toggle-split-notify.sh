#!/bin/bash
# Debug version - logs to file
LOGFILE=/tmp/togglesplit-debug.log
echo "=== $(date) ===" >> $LOGFILE
echo "Running togglesplit..." >> $LOGFILE
hyprctl dispatch layoutmsg togglesplit >> $LOGFILE 2>&1
echo "Exit code: $?" >> $LOGFILE

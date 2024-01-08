#!/bin/bash

# Path to the check file
CHECK_FILE="/usr/local/bin/auto_shut.check"

# Set the shutdown date here (format YYYY-MM-DD HH:MM)
SHUTDOWN_DATETIME="2024-01-31 15:00"

# Convert datetime to unix timestamp
SHUTDOWN_TIMESTAMP=$(date -d "$SHUTDOWN_DATETIME" +%s)
echo "Shutdown timestamp: $SHUTDOWN_TIMESTAMP"

# Get the current date in the same format
CURRENT_TIMESTAMP=$(date +%s)
echo "Current timestamp: $CURRENT_TIMESTAMP"

# Check if the check file exists
if [ -f "$CHECK_FILE" ]; then
        echo "Check file exists, skipping shutdown."
        # Check file exists, removee the check file
        rm -f "$CHECK_FILE"
        # Schedule a shutdown in 1 hour as a precaution
        /sbin/shutdown -h +60

        echo "Check file found and removed. SHutdown scheduled in 1 hour."
else
        echo "No check file, proceeding with shutdown process."
        # No check file, proceed with the shutdown process
        if [ "$CURRENT_TIMESTAMP" -ge "$SHUTDOWN_TIMESTAMP" ]; then
                echo "Current time is past the shutdown time, shutting down."
                # Create a check file
                touch "$CHECK_FILE"
                # Shutdown command with 10 minutes grace-period
                /sbin/shutdown -h +10

                echo "Shutdown time reached. Shutting down now."
        else
                echo "Current time is before the shutdown time, scheduling shutdown in 1 hour."
                # Schedule a shutdown in 1 hour after reboot
                /sbin/shutdown -h +60

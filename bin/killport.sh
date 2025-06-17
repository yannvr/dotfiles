#!/bin/bash

# Check if at least one port is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 port1 [port2 ...]"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
if ! command_exists lsof; then
    echo "Error: lsof command not found. Please install it."
    exit 1
fi
if ! command_exists ps; then
    echo "Error: ps command not found."
    exit 1
fi

# Function to get process details
get_process_details() {
    local pid=$1
    # Get process details using ps
    # -p: specify PID, -o: specify output format
    # etime: elapsed time since process started
    # %cpu: CPU usage percentage
    # %mem: Memory usage percentage
    # user: effective user name
    details=$(ps -p "$pid" -o etime,%cpu,%mem,user --no-headers 2>/dev/null)
    if [ -n "$details" ]; then
        read -r etime cpu mem user <<< "$details"
        # Clean up etime format (remove leading spaces)
        etime=$(echo "$etime" | sed 's/^[[:space:]]*//')
        echo "Owner: $user, CPU: $cpu%, Memory: $mem%, Runtime: $etime"
    else
        echo "Unable to retrieve process details"
    fi
}

# Loop through all provided ports
for port in "$@"; do
    # Validate port number
    case "$port" in
        ''|*[!0-9]*)
            echo "Invalid port number: $port. Must be between 1 and 65535."
            continue
            ;;
    esac
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "Invalid port number: $port. Must be between 1 and 65535."
        continue
    fi

    # Find PIDs using the port
    pids=$(lsof -ti :"$port")

    if [ -z "$pids" ]; then
        echo "No process found running on port $port"
    else
        # Process each PID
        for pid in $pids; do
            echo "Found process $pid on port $port"
            # Get and display process details
            process_details=$(get_process_details "$pid")
            echo "Details: $process_details"
            # Attempt to kill the process
            if kill -9 "$pid" 2>/dev/null; then
                echo "Successfully killed process $pid on port $port"
            else
                echo "Failed to kill process $pid on port $port"
            fi
        done
    fi
done

exit 0

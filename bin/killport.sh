#!/bin/bash

# Check if at least one port pattern is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 port1|pattern1 [port2|pattern2 ...]"
    echo "Examples:"
    echo "  $0 3000        # Kill process on port 3000"
    echo "  $0 300*        # Kill all processes on ports starting with 300"
    echo "  $0 3000 8080   # Kill processes on ports 3000 and 8080"
    echo "  $0 80* 90*     # Kill all processes on ports starting with 80 or 90"
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
    # Try macOS/BSD-compatible ps fields first (pcpu, pmem). The '=' removes headers.
	local ps_output
	# Prefer full command with arguments; -ww avoids truncation on macOS/Linux
	ps_output=$(ps -ww -p "$pid" -o etime= -o pcpu= -o pmem= -o user= -o command= 2>/dev/null)
	# Fallbacks for different ps variants
	if [ -z "$ps_output" ]; then
		ps_output=$(ps -ww -p "$pid" -o etime= -o pcpu= -o pmem= -o user= -o args= 2>/dev/null)
	fi
	if [ -z "$ps_output" ]; then
		ps_output=$(ps -ww -p "$pid" -o etime= -o %cpu= -o %mem= -o user= -o command= 2>/dev/null)
	fi
	if [ -z "$ps_output" ]; then
		ps_output=$(ps -ww -p "$pid" -o etime= -o %cpu= -o %mem= -o user= -o args= 2>/dev/null)
	fi
	# Last resort: just the executable name
	if [ -z "$ps_output" ]; then
		ps_output=$(ps -ww -p "$pid" -o etime= -o pcpu= -o pmem= -o user= -o comm= 2>/dev/null)
	fi
	if [ -z "$ps_output" ]; then
		ps_output=$(ps -ww -p "$pid" -o etime= -o %cpu= -o %mem= -o user= -o comm= 2>/dev/null)
	fi
	if [ -n "$ps_output" ]; then
		read -r etime cpu mem user cmdline <<< "$ps_output"
		etime=$(echo "$etime" | sed 's/^[[:space:]]*//')
		echo "Owner: $user, CPU: $cpu%, Memory: $mem%, Runtime: $etime, Command: $cmdline"
	else
		echo "Unable to retrieve process details"
	fi
}

# Function to expand wildcard patterns to actual ports
expand_port_pattern() {
    local pattern=$1
    local matching_ports=()
    
    # If pattern contains wildcard characters
    if [[ $pattern == *\** ]]; then
        echo "Searching for ports matching pattern: $pattern"
        
        # Get all listening ports using lsof
        local all_ports
        all_ports=$(lsof -i -P -n | grep LISTEN | awk '{print $9}' | cut -d: -f2 | sort -u)
        
        # Convert shell pattern to regex for matching
        local regex_pattern
        regex_pattern=$(echo "$pattern" | sed 's/\*/.*/')
        
        # Find matching ports
        while IFS= read -r port; do
            if [[ $port =~ ^$regex_pattern$ ]] && [[ $port =~ ^[0-9]+$ ]]; then
                matching_ports+=("$port")
            fi
        done <<< "$all_ports"
        
        if [ ${#matching_ports[@]} -eq 0 ]; then
            echo "No ports found matching pattern: $pattern"
            return 1
        else
            echo "Found ${#matching_ports[@]} ports matching pattern $pattern: ${matching_ports[*]}"
            printf '%s\n' "${matching_ports[@]}"
            return 0
        fi
    else
        # Not a wildcard, just return the original port
        echo "$pattern"
        return 0
    fi
}

# Function to kill processes on a specific port
kill_port() {
    local port=$1
    
    # Validate port number
    case "$port" in
        ''|*[!0-9]*)
            echo "Invalid port number: $port. Must be between 1 and 65535."
            return 1
            ;;
    esac
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "Invalid port number: $port. Must be between 1 and 65535."
        return 1
    fi

    # Find PIDs using the port
    pids=$(lsof -ti :"$port")

    if [ -z "$pids" ]; then
        echo "No process found running on port $port"
        return 0
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
        return 0
    fi
}

# Main logic: Loop through all provided port patterns
for pattern in "$@"; do
    echo "Processing pattern: $pattern"
    
    # Expand pattern to actual ports
    if expanded_ports=$(expand_port_pattern "$pattern"); then
        # Kill processes on each matching port
        while IFS= read -r port; do
            if [ -n "$port" ]; then
                kill_port "$port"
            fi
        done <<< "$expanded_ports"
    fi
    
    echo "---"
done

exit 0

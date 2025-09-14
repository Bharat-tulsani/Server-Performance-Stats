#!/bin/bash

# Server Performance Statistics Script
# This script analyzes basic server performance stats on Linux systems

echo "======================================="
echo "      SERVER PERFORMANCE STATISTICS"
echo "======================================="
echo "Generated on: $(date)"
echo ""

# Function to display a separator line
separator() {
    echo "---------------------------------------"
}

# 1. Total CPU Usage
echo "1. CPU USAGE:"
separator
# Get CPU usage using top command (average across all cores)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
# Alternative method using vmstat
cpu_idle=$(vmstat 1 2 | tail -1 | awk '{print $15}')
cpu_used=$((100 - cpu_idle))

echo "   Current CPU Usage: ${cpu_used}%"
echo "   CPU Idle: ${cpu_idle}%"

# Load average
load_avg=$(uptime | awk -F'load average:' '{print $2}')
echo "   Load Average:$load_avg"
echo ""

# 2. Total Memory Usage
echo "2. MEMORY USAGE:"
separator
# Get memory information from /proc/meminfo
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
available_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
free_mem=$(grep MemFree /proc/meminfo | awk '{print $2}')

# Convert to MB and calculate used memory
total_mem_mb=$((total_mem / 1024))
available_mem_mb=$((available_mem / 1024))
free_mem_mb=$((free_mem / 1024))
used_mem_mb=$((total_mem_mb - available_mem_mb))

# Calculate percentages
used_mem_percent=$((used_mem_mb * 100 / total_mem_mb))
free_mem_percent=$((100 - used_mem_percent))

echo "   Total Memory: ${total_mem_mb} MB"
echo "   Used Memory: ${used_mem_mb} MB (${used_mem_percent}%)"
echo "   Available Memory: ${available_mem_mb} MB (${free_mem_percent}%)"
echo ""

# 3. Total Disk Usage
echo "3. DISK USAGE:"
separator
echo "   Root filesystem (/):"
df_output=$(df -h / | tail -1)
disk_size=$(echo $df_output | awk '{print $2}')
disk_used=$(echo $df_output | awk '{print $3}')
disk_available=$(echo $df_output | awk '{print $4}')
disk_percent=$(echo $df_output | awk '{print $5}')

echo "   Total: $disk_size"
echo "   Used: $disk_used ($disk_percent)"
echo "   Available: $disk_available"

# Show all mounted filesystems
echo ""
echo "   All filesystems:"
df -h | grep -E '^/dev/' | while read line; do
    echo "   $line"
done
echo ""

# 4. Top 5 Processes by CPU Usage
echo "4. TOP 5 PROCESSES BY CPU USAGE:"
separator
ps aux --sort=-%cpu | head -6 | awk 'NR==1{print "   " $0} NR>1{printf "   %-10s %-8s %-6s %-6s %-s\n", $1, $2, $3, $4, $11}'
echo ""

# 5. Top 5 Processes by Memory Usage
echo "5. TOP 5 PROCESSES BY MEMORY USAGE:"
separator
ps aux --sort=-%mem | head -6 | awk 'NR==1{print "   " $0} NR>1{printf "   %-10s %-8s %-6s %-6s %-s\n", $1, $2, $3, $4, $11}'
echo ""

# Stretch Goals - Additional Statistics
echo "6. ADDITIONAL SYSTEM INFORMATION:"
separator

# OS Version
echo "   OS Version:"
if [ -f /etc/os-release ]; then
    echo "   $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
elif [ -f /etc/redhat-release ]; then
    echo "   $(cat /etc/redhat-release)"
else
    echo "   $(uname -s) $(uname -r)"
fi

# Kernel Version
echo "   Kernel: $(uname -r)"

# System Uptime
echo "   Uptime: $(uptime -p 2>/dev/null || uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')"

# Currently logged in users
echo "   Logged in users:"
users_count=$(who | wc -l)
echo "   Total: $users_count users"
who | awk '{print "   - " $1 " (from " $5 ")"}' | sort -u

# Failed login attempts (last 10)
echo ""
echo "   Recent failed login attempts:"
if command -v lastb >/dev/null 2>&1; then
    failed_logins=$(lastb -n 10 2>/dev/null | head -10)
    if [ -n "$failed_logins" ]; then
        echo "$failed_logins" | head -5 | while read line; do
            if [[ ! "$line" =~ ^btmp ]]; then
                echo "   $line"
            fi
        done
    else
        echo "   No recent failed login attempts found"
    fi
else
    echo "   lastb command not available"
fi

# Network connections
echo ""
echo "   Active network connections:"
netstat_count=$(netstat -an 2>/dev/null | grep ESTABLISHED | wc -l)
echo "   Established connections: $netstat_count"

# System load and processes
echo ""
echo "   System load and processes:"
echo "   Running processes: $(ps aux | wc -l)"
echo "   Zombie processes: $(ps aux | awk '$8 ~ /^Z/ { count++ } END { print count+0 }')"

echo ""
echo "======================================="
echo "     END OF PERFORMANCE REPORT"
echo "======================================="

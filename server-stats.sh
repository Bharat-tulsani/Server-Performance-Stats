#!/bin/bash

#############################################
# SERVER PERFORMANCE STATISTICS SCRIPT
# This script analyzes basic server performance
# Author: DevOps Project
# Date: $(date)
#############################################

# Colors for better output readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to print colored status
print_status() {
    local usage=$1
    local threshold=$2
    if (( $(echo "$usage > $threshold" | bc -l) )); then
        echo -e "${RED}$usage%${NC}"
    elif (( $(echo "$usage > $(($threshold - 20))" | bc -l) )); then
        echo -e "${YELLOW}$usage%${NC}"
    else
        echo -e "${GREEN}$usage%${NC}"
    fi
}

echo -e "${CYAN}"
echo "  ____                          ____  _        _       "
echo " / ___|  ___ _ ____   _____ _ __/ ___|| |_ __ _| |_ ___ "
echo " \___ \ / _ \ '__\ \ / / _ \ '__\___ \| __/ _\` | __/ __|"
echo "  ___) |  __/ |   \ V /  __/ |   ___) | || (_| | |_\__ \\"
echo " |____/ \___|_|    \_/ \___|_|  |____/ \__\__,_|\__|___/"
echo -e "${NC}"
echo -e "${PURPLE}Server Performance Analysis Tool${NC}"
echo -e "Generated on: ${CYAN}$(date)${NC}"
echo -e "Hostname: ${CYAN}$(hostname)${NC}"

#############################################
# 1. SYSTEM INFORMATION (Stretch Goal)
#############################################
print_header "SYSTEM INFORMATION"

echo -e "${YELLOW}Operating System:${NC} $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2 2>/dev/null || echo "Unknown")"
echo -e "${YELLOW}Kernel Version:${NC} $(uname -r)"
echo -e "${YELLOW}Architecture:${NC} $(uname -m)"
echo -e "${YELLOW}Uptime:${NC} $(uptime -p 2>/dev/null || uptime)"

# Load Average
load_avg=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^ *//')
echo -e "${YELLOW}Load Average:${NC} $load_avg"

#############################################
# 2. CPU USAGE ANALYSIS
#############################################
print_header "CPU USAGE ANALYSIS"

# Get CPU usage using top command (more reliable than iostat)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | awk -F'%' '{print $1}')

# Calculate total CPU usage
if [ -n "$cpu_idle" ]; then
    total_cpu_usage=$(echo "100 - $cpu_idle" | bc -l | awk '{printf "%.1f", $0}')
else
    # Fallback method using vmstat
    total_cpu_usage=$(vmstat 1 2 | tail -1 | awk '{print 100-$15}' | awk '{printf "%.1f", $0}')
fi

echo -e "${YELLOW}Total CPU Usage:${NC} $(print_status $total_cpu_usage 80)"
echo -e "${YELLOW}CPU Cores:${NC} $(nproc)"

# CPU details
cpu_info=$(lscpu | grep "Model name" | cut -d':' -f2 | sed 's/^ *//')
echo -e "${YELLOW}CPU Model:${NC} $cpu_info"

#############################################
# 3. MEMORY USAGE ANALYSIS
#############################################
print_header "MEMORY USAGE ANALYSIS"

# Get memory information using free command
memory_info=$(free -h)
memory_stats=$(free | grep "Mem:")

total_mem=$(echo $memory_stats | awk '{print $2}')
used_mem=$(echo $memory_stats | awk '{print $3}')
free_mem=$(echo $memory_stats | awk '{print $4}')
available_mem=$(echo $memory_stats | awk '{print $7}')

# Calculate percentages
mem_usage_percent=$(echo "scale=1; ($used_mem * 100) / $total_mem" | bc)
mem_free_percent=$(echo "scale=1; ($available_mem * 100) / $total_mem" | bc)

echo -e "${YELLOW}Memory Overview:${NC}"
echo "$memory_info"
echo ""
echo -e "${YELLOW}Memory Usage:${NC} $(print_status $mem_usage_percent 80)"
echo -e "${YELLOW}Memory Free:${NC} ${GREEN}${mem_free_percent}%${NC}"

# Show swap usage
swap_stats=$(free | grep "Swap:")
if [ -n "$swap_stats" ]; then
    swap_total=$(echo $swap_stats | awk '{print $2}')
    swap_used=$(echo $swap_stats | awk '{print $3}')
    if [ "$swap_total" -gt 0 ]; then
        swap_usage_percent=$(echo "scale=1; ($swap_used * 100) / $swap_total" | bc)
        echo -e "${YELLOW}Swap Usage:${NC} $(print_status $swap_usage_percent 50)"
    else
        echo -e "${YELLOW}Swap:${NC} ${GREEN}Not configured${NC}"
    fi
fi

#############################################
# 4. DISK USAGE ANALYSIS
#############################################
print_header "DISK USAGE ANALYSIS"

echo -e "${YELLOW}Disk Usage by Filesystem:${NC}"
df_output=$(df -h --type=ext4 --type=ext3 --type=ext2 --type=xfs --type=btrfs 2>/dev/null || df -h)

# Print header
echo -e "${CYAN}Filesystem      Size  Used Avail Use% Mounted on${NC}"

# Process each filesystem
echo "$df_output" | grep -v "Filesystem" | while read line; do
    if [ -n "$line" ]; then
        usage_percent=$(echo "$line" | awk '{print $5}' | sed 's/%//')
        if [ -n "$usage_percent" ] && [ "$usage_percent" -gt 80 ]; then
            echo -e "${RED}$line${NC}"
        elif [ -n "$usage_percent" ] && [ "$usage_percent" -gt 60 ]; then
            echo -e "${YELLOW}$line${NC}"
        else
            echo -e "${GREEN}$line${NC}"
        fi
    fi
done

# Show largest directories in root (if accessible)
echo -e "\n${YELLOW}Largest Directories in /:${NC}"
du -h --max-depth=1 / 2>/dev/null | sort -hr | head -5 2>/dev/null || echo "Access denied to scan root directory"

#############################################
# 5. TOP 5 PROCESSES BY CPU USAGE
#############################################
print_header "TOP 5 PROCESSES BY CPU USAGE"

echo -e "${CYAN}PID       USER      CPU%    COMMAND${NC}"
ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "%-8s %-10s %-7s %s\n", $2, $1, $3"%", $11}'

#############################################
# 6. TOP 5 PROCESSES BY MEMORY USAGE
#############################################
print_header "TOP 5 PROCESSES BY MEMORY USAGE"

echo -e "${CYAN}PID       USER      MEM%    COMMAND${NC}"
ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "%-8s %-10s %-7s %s\n", $2, $1, $4"%", $11}'

#############################################
# 7. NETWORK AND USER INFORMATION (Stretch Goals)
#############################################
print_header "NETWORK & USER INFORMATION"

# Currently logged in users
echo -e "${YELLOW}Currently Logged In Users:${NC}"
who | awk '{print $1, $2, $3, $4}' | sort | uniq
echo ""

# Network connections
echo -e "${YELLOW}Active Network Connections:${NC}"
netstat_count=$(netstat -an 2>/dev/null | grep ESTABLISHED | wc -l)
echo "Established connections: $netstat_count"

# Show listening ports
echo -e "\n${YELLOW}Services Listening on Ports:${NC}"
netstat -tlnp 2>/dev/null | grep LISTEN | head -5 | awk '{print $1, $4, $7}' || ss -tlnp | grep LISTEN | head -5

#############################################
# 8. SECURITY INFORMATION (Stretch Goals)
#############################################
print_header "SECURITY INFORMATION"

# Failed login attempts (if available)
echo -e "${YELLOW}Recent Failed Login Attempts:${NC}"
if [ -f /var/log/auth.log ]; then
    failed_logins=$(grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5 | wc -l)
    echo "Failed login attempts in auth.log: $failed_logins"
    if [ "$failed_logins" -gt 0 ]; then
        echo "Recent failed attempts:"
        grep "Failed password" /var/log/auth.log 2>/dev/null | tail -3 | awk '{print $1, $2, $3, $9, $11}'
    fi
elif [ -f /var/log/secure ]; then
    failed_logins=$(grep "Failed password" /var/log/secure 2>/dev/null | tail -5 | wc -l)
    echo "Failed login attempts in secure log: $failed_logins"
else
    echo "Login logs not accessible or not found"
fi

#############################################
# 9. SYSTEM ALERTS AND RECOMMENDATIONS
#############################################
print_header "SYSTEM ALERTS & RECOMMENDATIONS"

# Check for high resource usage and provide recommendations
echo -e "${YELLOW}System Health Check:${NC}"

# CPU Alert
if (( $(echo "$total_cpu_usage > 80" | bc -l) )); then
    echo -e "${RED}⚠ WARNING: High CPU usage detected (${total_cpu_usage}%)${NC}"
    echo "  Recommendation: Check top CPU processes and consider optimization"
fi

# Memory Alert
if (( $(echo "$mem_usage_percent > 80" | bc -l) )); then
    echo -e "${RED}⚠ WARNING: High memory usage detected (${mem_usage_percent}%)${NC}"
    echo "  Recommendation: Check memory-intensive processes or add more RAM"
fi

# Disk Alert
df -h | awk 'NR>1 {gsub(/%/,"",$5); if($5>80) print "⚠ WARNING: Disk usage high on "$6" ("$5"%)"}'

# Load Average Alert
load_1min=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | sed 's/^ *//')
cpu_cores=$(nproc)
if (( $(echo "$load_1min > $cpu_cores" | bc -l) )); then
    echo -e "${RED}⚠ WARNING: High load average ($load_1min) exceeds CPU cores ($cpu_cores)${NC}"
    echo "  Recommendation: System may be overloaded"
fi

echo ""
echo -e "${GREEN}✓ Server statistics analysis complete!${NC}"
echo -e "${CYAN}For real-time monitoring, consider using: htop, iotop, or nethogs${NC}"

#############################################
# END OF SCRIPT
#############################################

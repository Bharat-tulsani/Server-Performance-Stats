# 💡 Basic Usage Examples

## Overview

This document provides practical, real-world examples of how to use the server-stats script in common scenarios. Each example includes the command, expected output, and interpretation.

## Daily Monitoring Tasks

### Example 1: Morning Health Check

**Scenario**: You're starting your workday and want to check if all servers are running normally.

**Command**:
```bash
server-stats
```

**Sample Output**:
```
Server Performance Analysis Tool
Generated on: Mon Aug 11 09:00:15 EDT 2025
Hostname: web-prod-01

================================
SYSTEM INFORMATION
================================
Operating System: Ubuntu 20.04.3 LTS
Uptime: up 23 days, 8 hours, 15 minutes
Load Average: 1.2, 1.1, 0.9

================================
CPU USAGE ANALYSIS
================================
Total CPU Usage: 35.2% [GREEN]
CPU Cores: 4

================================
MEMORY USAGE ANALYSIS
================================
Memory Usage: 62.1% [GREEN]
Memory Free: 37.9%
Swap Usage: 0.0% [GREEN]

================================
DISK USAGE ANALYSIS
================================
/dev/sda1    50G   28G   20G  58% /     [GREEN]
/dev/sdb1   100G   45G   50G  47% /var  [GREEN]

No alerts
✓ Server statistics analysis complete!
```

**Interpretation**: 
- ✅ **Healthy server**: All metrics in green
- ✅ **Good uptime**: 23 days indicates stability
- ✅ **Balanced load**: CPU and memory usage reasonable
- ✅ **No action needed**: Continue with normal operations

---

### Example 2: Quick Resource Check

**Scenario**: Your application is running slowly, and you want a quick overview of resource usage.

**Command**:
```bash
server-stats | grep -E "(CPU Usage|Memory Usage|Disk Usage)" -A 1
```

**Sample Output**:
```
Total CPU Usage: 78.3% [YELLOW]
Memory Usage: 81.2% [YELLOW]
/dev/sda1    50G   42G    6G  88% /     [RED]
```

**Interpretation**:
- ⚠️ **CPU Warning**: High but not critical
- ⚠️ **Memory Warning**: Close to threshold  
- 🔴 **Disk Critical**: Immediate attention needed
- 🎯 **Action**: Clean disk space first, then investigate CPU/memory

---

### Example 3: Process Investigation

**Scenario**: You notice high CPU usage and want to identify the culprit.

**Command**:
```bash
server-stats | grep -A 10 "TOP 5 PROCESSES BY CPU"
```

**Sample Output**:
```
================================
TOP 5 PROCESSES BY CPU USAGE
================================
PID       USER      CPU%    COMMAND
28394     www-data  45.2%   php-fpm
15629     mysql     25.1%   mysqld
22847     root      12.8%   backup-script
18392     nginx     8.7%    nginx
31045     app       6.2%    python3
```

**Interpretation**:
- 🔍 **php-fpm using 45.2%**: Web application under heavy load
- 🔍 **mysqld using 25.1%**: Database queries are intensive
- 🔍 **backup-script using 12.8%**: Scheduled backup running
- 🎯 **Action**: Check if backup timing can be optimized, investigate PHP application performance

---

## Troubleshooting Scenarios

### Example 4: Server Performance Issues

**Scenario**: Users report that the website is loading very slowly.

**Command**:
```bash
server-stats
```

**Sample Output**:
```
================================
CPU USAGE ANALYSIS
================================
Total CPU Usage: 92.5% [RED]

================================
MEMORY USAGE ANALYSIS
================================
Memory Usage: 89.3% [RED]
Swap Usage: 45.2% [RED]

================================
TOP 5 PROCESSES BY CPU USAGE
================================
PID       USER      CPU%    COMMAND
12456     www-data  55.8%   apache2
23891     www-data  22.3%   apache2
34567     www-data  18.9%   apache2
45678     mysql     15.2%   mysqld
56789     root      8.1%    gzip

================================
SYSTEM ALERTS & RECOMMENDATIONS
================================
⚠ WARNING: High CPU usage detected (92.5%)
  Recommendation: Check top CPU processes and consider optimization
⚠ WARNING: High memory usage detected (89.3%)
  Recommendation: Check memory-intensive processes or add more RAM
```

**Interpretation**:
- 🔴 **Critical CPU/Memory**: System is severely overloaded
- 🔍 **Multiple Apache processes**: Web server under extreme load
- 🔍 **High swap usage**: System running out of RAM
- 🎯 **Immediate Actions**:
  1. Restart Apache to clear potential memory leaks
  2. Check for traffic spikes or DDoS attacks
  3. Consider scaling web server resources

**Follow-up Commands**:
```bash
# Check web server connections
netstat -an | grep :80 | wc -l

# Check recent web traffic
tail -n 100 /var/log/apache2/access.log

# Restart web server if needed
sudo systemctl restart apache2
```

---

### Example 5: Disk Space Emergency

**Scenario**: Applications are failing with "disk full" errors.

**Command**:
```bash
server-stats | grep -A 15 "DISK USAGE"
```

**Sample Output**:
```
================================
DISK USAGE ANALYSIS
================================
Disk Usage by Filesystem:
/dev/sda1    20G   19G   500M  96% /     [RED]
/dev/sdb1    50G   48G   1.2G  96% /var  [RED]

Largest Directories in /:
15G	/var/log
2.8G	/tmp
1.2G	/usr
890M	/opt

⚠ WARNING: Disk usage high on / (96%)
⚠ WARNING: Disk usage high on /var (96%)
  Recommendation: Clean log files or expand storage
```

**Interpretation**:
- 🔴 **Critical disk usage**: Both filesystems nearly full
- 🔍 **Log files consuming 15G**: Primary culprit identified
- 🔍 **Temp files using 2.8G**: Secondary cleanup target
- 🎯 **Immediate Actions**:

**Emergency Cleanup Commands**:
```bash
# Check largest log files
du -h /var/log/* | sort -hr | head -10

# Compress old logs
sudo find /var/log -name "*.log" -mtime +7 -exec gzip {} \;

# Clean temp files
sudo rm -rf /tmp/*

# Clean package cache
sudo apt-get clean  # Ubuntu/Debian
sudo yum clean all  # CentOS/RHEL
```

---

### Example 6: Security Investigation

**Scenario**: You suspect unauthorized access attempts.

**Command**:
```bash
server-stats | grep -A 10 "SECURITY INFORMATION"
```

**Sample Output**:
```
================================
SECURITY INFORMATION
================================
Recent Failed Login Attempts: 127
Failed login attempts in auth.log: 127
Recent failed attempts:
Aug 11 10:45:23 Failed password for root from 45.77.185.102
Aug 11 10:45:25 Failed password for admin from 45.77.185.102
Aug 11 10:45:27 Failed password for user from 45.77.185.102
Aug 11 10:45:29 Failed password for test from 45.77.185.102
Aug 11 10:45:31 Failed password for guest from 45.77.185.102
```

**Interpretation**:
- 🔴 **127 failed attempts**: Likely brute force attack
- 🔍 **Same IP address**: Concentrated attack from 45.77.185.102
- 🔍 **Common usernames**: Typical attack pattern
- 🎯 **Security Actions**:

**Security Response Commands**:
```bash
# Block the attacking IP
sudo iptables -A INPUT -s 45.77.185.102 -j DROP

# Check all recent failed attempts
sudo grep "Failed password" /var/log/auth.log | tail -20

# Consider implementing fail2ban
sudo apt-get install fail2ban
```

---

## Routine Monitoring Examples

### Example 7: Weekly Server Report

**Scenario**: Generate a comprehensive weekly report for management.

**Command**:
```bash
# Generate timestamped report
server-stats > weekly-report-$(date +%Y%m%d).txt

# Email report (if mail is configured)
server-stats | mail -s "Weekly Server Report - $(hostname)" admin@company.com
```

**Sample Report Header**:
```
Server Performance Analysis Tool
Generated on: Fri Aug 11 17:00:00 EDT 2025
Hostname: web-prod-01

Weekly Summary:
- Uptime: 7 days, 0 hours, 0 minutes
- Average CPU: 45%
- Peak Memory Usage: 78%
- Disk Growth: +2.3GB this week
- Security Events: 3 failed logins
```

---

### Example 8: Before/After Optimization

**Scenario**: You're optimizing server performance and want to compare results.

**Before Optimization**:
```bash
server-stats > before-optimization.txt
```

**Sample "Before" Output**:
```
CPU Usage: 78.5% [YELLOW]
Memory Usage: 82.1% [YELLOW]
Load Average: 6.2, 5.9, 5.7

TOP 5 PROCESSES BY MEMORY USAGE:
PID       USER      MEM%    COMMAND
12345     mysql     35.2%   mysqld
23456     www-data  28.7%   apache2
34567     app       15.3%   python3
```

**After Optimization**:
```bash
server-stats > after-optimization.txt
```

**Sample "After" Output**:
```
CPU Usage: 42.3% [GREEN]
Memory Usage: 58.9% [GREEN]
Load Average: 2.1, 2.3, 2.5

TOP 5 PROCESSES BY MEMORY USAGE:
PID       USER      MEM%    COMMAND
12345     mysql     22.1%   mysqld
23456     www-data  18.2%   apache2
34567     app       12.1%   python3
```

**Comparison Analysis**:
- ✅ **CPU reduced**: 78.5% → 42.3% (46% improvement)
- ✅ **Memory reduced**: 82.1% → 58.9% (28% improvement)
- ✅ **Load normalized**: From overloaded to normal
- ✅ **Optimization successful**: Significant performance gains

---

## Automation Examples

### Example 9: Automated Alert Script

**Scenario**: Create a script that only alerts when there are problems.

**Create Alert Script**:
```bash
cat > alert-check.sh << 'EOF'
#!/bin/bash

# Run server-stats and capture output
output=$(server-stats 2>/dev/null)

# Check for warnings or critical issues
if echo "$output" | grep -q "WARNING\|CRITICAL"; then
    echo "ALERT: Server issues detected on $(hostname)"
    echo "$output" | grep -A 2 "WARNING\|CRITICAL"
    
    # Send email alert (if configured)
    echo "$output" | mail -s "Server Alert - $(hostname)" admin@company.com
else
    echo "$(date): All systems normal"
fi
EOF

chmod +x alert-check.sh
```

**Sample Alert Output**:
```
ALERT: Server issues detected on web-prod-01
⚠ WARNING: High CPU usage detected (87.2%)
  Recommendation: Check top CPU processes and consider optimization
⚠ WARNING: Disk usage high on /var (91%)
  Recommendation: Clean log files or expand storage
```

---

### Example 10: Performance Trending

**Scenario**: Track performance metrics over time.

**Create Trending Script**:
```bash
cat > trend-monitor.sh << 'EOF'
#!/bin/bash

# Extract key metrics and log them
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
cpu=$(server-stats 2>/dev/null | grep "Total CPU Usage" | awk '{print $4}' | sed 's/%//')
memory=$(server-stats 2>/dev/null | grep "Memory Usage" | awk '{print $3}' | sed 's/%//')
load=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | sed 's/^ *//')

# Log to CSV file
echo "$timestamp,$cpu,$memory,$load" >> /var/log/server-trends.csv

# Check if header exists
if [ ! -s /var/log/server-trends.csv ]; then
    echo "Timestamp,CPU%,Memory%,Load" > /var/log/server-trends.csv
fi
EOF

chmod +x trend-monitor.sh

# Run every 5 minutes via cron
echo "*/5 * * * * /path/to/trend-monitor.sh" | crontab -
```

**Sample Trend Data**:
```
Timestamp,CPU%,Memory%,Load
2025-08-11 09:00:00,45.2,62.1,1.2
2025-08-11 09:05:00,48.7,64.3,1.4
2025-08-11 09:10:00,52.1,67.8,1.7
2025-08-11 09:15:00,87.3,82.1,3.2  # Spike detected
```

---

## Integration Examples

### Example 11: Dashboard Integration

**Scenario**: Extract specific metrics for a monitoring dashboard.

**Extract CPU and Memory**:
```bash
# Get just the numbers for dashboard
cpu_percent=$(server-stats 2>/dev/null | grep "Total CPU Usage" | awk '{print $4}' | sed 's/%//')
mem_percent=$(server-stats 2>/dev/null | grep "Memory Usage" | awk '{print $3}' | sed 's/%//')
disk_percent=$(server-stats 2>/dev/null | grep "%" | grep "/" | head -1 | awk '{print $5}' | sed 's/%//')

echo "CPU: ${cpu_percent}%"
echo "Memory: ${mem_percent}%"
echo "Disk: ${disk_percent}%"
```

**JSON Output for APIs**:
```bash
cat > json-stats.sh << 'EOF'
#!/bin/bash

# Extract metrics
cpu=$(server-stats 2>/dev/null | grep "Total CPU Usage" | awk '{print $4}' | sed 's/%//')
memory=$(server-stats 2>/dev/null | grep "Memory Usage" | awk '{print $3}' | sed 's/%//')
hostname=$(hostname)
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Generate JSON
cat << JSON
{
  "hostname": "$hostname",
  "timestamp": "$timestamp",
  "metrics": {
    "cpu_percent": $cpu,
    "memory_percent": $memory
  },
  "status": "$([ $cpu -lt 70 ] && [ $memory -lt 70 ] && echo "healthy" || echo "warning")"
}
JSON
EOF
```

---

## Quick Commands Reference

### Essential One-Liners
```bash
# Quick health check - just the important stuff
server-stats | grep -E "(CPU Usage|Memory Usage|WARNING|CRITICAL)"

# Get top resource users
server-stats | grep -A 10 "TOP 5 PROCESSES"

# Check only disk usage
server-stats | grep -A 20 "DISK USAGE"

# Security check only
server-stats | grep -A 10 "SECURITY"

# Extract just the numbers
server-stats | grep -E "Usage:" | awk '{print $3}' | paste -sd ' '
```

### Useful Filters
```bash
# Show only problems
server-stats | grep -E "WARNING|CRITICAL|RED" -A 1

# Show only green status
server-stats | grep "GREEN"

# Get system summary
server-stats | head -20

# Get alerts only
server-stats | tail -20
```

## Next Steps

Now that you've seen practical examples:
1. **Learn troubleshooting**: [Troubleshooting Guide](../tutorials/04-troubleshooting.md)
2. **Set up automation**: [Automation Examples](automation-examples.md)
3. **Explore advanced features**: [Advanced Usage](advanced-usage.md)

---

**Practice with these examples to become proficient at server monitoring! 🎯**

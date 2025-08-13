# 🚨 Troubleshooting Guide

## Overview

This guide helps you diagnose and resolve common issues with the server-stats script and the servers you're monitoring. It's organized by problem category for quick reference.

## Installation Issues

### Problem: Permission Denied

**Symptoms:**
```bash
$ ./server-stats.sh
bash: ./server-stats.sh: Permission denied
```

**Cause:** Script file is not executable

**Solution:**
```bash
# Make the script executable
chmod +x server-stats.sh

# Verify permissions
ls -la server-stats.sh
# Should show: -rwxr-xr-x
```

**Alternative Solution:**
```bash
# Run with bash directly
bash server-stats.sh
```

---

### Problem: Command Not Found

**Symptoms:**
```bash
$ server-stats
server-stats: command not found
```

**Cause:** Script not in PATH or not installed system-wide

**Solutions:**

1. **Use full path:**
```bash
/usr/local/bin/server-stats
~/bin/server-stats
./server-stats.sh
```

2. **Add to PATH:**
```bash
export PATH="/usr/local/bin:$PATH"
# Add to ~/.bashrc for permanent effect
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
```

3. **Install system-wide:**
```bash
sudo ./install.sh
```

---

### Problem: Missing Dependencies

**Symptoms:**
```bash
$ ./server-stats.sh
./server-stats.sh: line 45: bc: command not found
```

**Cause:** Required commands not installed

**Solutions by OS:**

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install bc net-tools procps
```

**CentOS/RHEL:**
```bash
sudo yum install bc net-tools procps
# Or for newer versions:
sudo dnf install bc net-tools procps
```

**Alpine Linux:**
```bash
apk add bc net-tools procps
```

**Verify Installation:**
```bash
# Test all required commands
for cmd in ps top free df uptime who bc netstat awk grep; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd - Available"
    else
        echo "❌ $cmd - Missing"
    fi
done
```

---

## Script Execution Issues

### Problem: Incomplete Output

**Symptoms:**
- Script runs but missing sections
- Some metrics show "N/A" or are blank
- Security section empty

**Cause:** Insufficient permissions or missing log files

**Diagnosis:**
```bash
# Check what files the script can access
ls -la /var/log/auth.log
ls -la /var/log/secure
ls -la /proc/meminfo
ls -la /proc/stat
```

**Solutions:**

1. **For security logs:**
```bash
# Grant read permission to log files
sudo chmod +r /var/log/auth.log
sudo chmod +r /var/log/secure

# Or run with sudo for full access
sudo ./server-stats.sh
```

2. **For system information:**
```bash
# Ensure /proc is mounted
mount | grep proc
# Should show: proc on /proc type proc

# If missing, mount it
sudo mount -t proc proc /proc
```

---

### Problem: Script Hangs or Takes Too Long

**Symptoms:**
- Script doesn't complete
- Hangs for several minutes
- High CPU usage during execution

**Cause:** Large log files, many processes, or slow disk I/O

**Solutions:**

1. **Run in fast mode:**
```bash
# Skip expensive operations
./server-stats.sh --no-processes --no-network --no-security
```

2. **Check for large log files:**
```bash
# Find large files that might slow down processing
find /var/log -type f -size +100M -exec ls -lh {} \;
```

3. **Monitor script execution:**
```bash
# Run with timeout
timeout 60 ./server-stats.sh

# Run with verbose output to see where it hangs
bash -x ./server-stats.sh
```

---

### Problem: Incorrect Output or Garbled Text

**Symptoms:**
- Strange characters in output
- Numbers don't make sense
- Color codes visible as text

**Cause:** Terminal encoding issues or unsupported terminal

**Solutions:**

1. **Disable colors:**
```bash
./server-stats.sh --no-color
```

2. **Check terminal encoding:**
```bash
echo $LANG
echo $LC_ALL
# Set UTF-8 encoding if needed
export LANG=en_US.UTF-8
```

3. **Use simple output:**
```bash
./server-stats.sh --quiet
```

---

## Performance Issues

### Problem: High CPU Usage Alerts

**Symptoms:**
```
⚠ WARNING: High CPU usage detected (87.2%)
```

**Diagnosis Steps:**

1. **Identify CPU-hungry processes:**
```bash
# Real-time process monitor
top -o %CPU

# Or use htop if available
htop

# One-time process snapshot
ps aux --sort=-%cpu | head -10
```

2. **Check system load:**
```bash
uptime
# Compare load average to number of CPU cores
nproc
```

3. **Investigate specific processes:**
```bash
# Get detailed info about high-CPU process
ps -p PID -o pid,ppid,cmd,%cpu,%mem,etime

# Check if it's a legitimate process
which PROCESS_NAME
```

**Common Solutions:**

1. **Restart problematic services:**
```bash
sudo systemctl restart apache2
sudo systemctl restart nginx
sudo systemctl restart mysql
```

2. **Kill runaway processes:**
```bash
# Find the process ID
ps aux | grep problematic_process

# Kill gracefully
kill PID

# Force kill if needed
kill -9 PID
```

3. **Optimize applications:**
```bash
# For web servers - reduce worker processes
# For databases - tune configuration
# For applications - check for memory leaks
```

---

### Problem: High Memory Usage Alerts

**Symptoms:**
```
⚠ WARNING: High memory usage detected (89.3%)
Swap Usage: 45.2% [RED]
```

**Diagnosis Steps:**

1. **Check memory details:**
```bash
free -h
cat /proc/meminfo | head -10
```

2. **Find memory-hungry processes:**
```bash
ps aux --sort=-%mem | head -10

# More detailed memory usage
sudo cat /proc/*/status | grep -E "(Name|VmRSS)" | paste - -
```

3. **Check for memory leaks:**
```bash
# Monitor memory usage over time
watch -n 5 'free -h'

# Check if memory usage keeps growing
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -10
```

**Solutions:**

1. **Free up memory:**
```bash
# Clear system caches (safe operation)
sudo sync && sudo echo 3 > /proc/sys/vm/drop_caches

# Restart memory-heavy services
sudo systemctl restart service_name
```

2. **Add swap space (temporary solution):**
```bash
# Create swap file
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

3. **Optimize applications:**
```bash
# For databases - reduce buffer sizes
# For web servers - limit worker memory
# For applications - check for memory leaks
```

---

### Problem: Disk Space Alerts

**Symptoms:**
```
⚠ WARNING: Disk usage high on /var (91%)
```

**Immediate Actions:**

1. **Find large files:**
```bash
# Find largest directories
du -h / 2>/dev/null | sort -hr | head -10

# Find large files in specific directory
find /var -type f -size +100M -exec ls -lh {} \; | sort -k5 -hr

# Find recently created large files
find /var -type f -size +50M -mtime -7 -exec ls -lh {} \;
```

2. **Clean up common culprits:**
```bash
# Clean log files
sudo find /var/log -name "*.log" -mtime +30 -delete
sudo find /var/log -name "*.log.*" -mtime +7 -delete

# Compress old logs
sudo find /var/log -name "*.log" -mtime +7 -exec gzip {} \;

# Clean package caches
sudo apt-get clean        # Ubuntu/Debian
sudo yum clean all        # CentOS/RHEL

# Clean temp files
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Clean core dumps
sudo find / -name "core.*" -type f -delete 2>/dev/null
```

3. **Emergency space recovery:**
```bash
# Truncate large log files (preserve file handles)
sudo truncate -s 0 /var/log/large-log-file.log

# Remove old kernel versions (Ubuntu)
sudo apt-get autoremove --purge

# Clean journal logs
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=100M
```

---

## Security Issues

### Problem: High Failed Login Attempts

**Symptoms:**
```
Recent Failed Login Attempts: 127
Failed password for root from 203.0.113.42
```

**Immediate Actions:**

1. **Block attacking IPs:**
```bash
# Block specific IP
sudo iptables -A INPUT -s 203.0.113.42 -j DROP

# Block IP range (if attack is from subnet)
sudo iptables -A INPUT -s 203.0.113.0/24 -j DROP

# Save iptables rules
sudo iptables-save > /etc/iptables/rules.v4
```

2. **Analyze attack patterns:**
```bash
# Count failed attempts by IP
sudo grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -nr

# Check attack timeframe
sudo grep "Failed password" /var/log/auth.log | tail -20

# Look for successful logins from same IPs
sudo grep "Accepted password" /var/log/auth.log | grep "203.0.113.42"
```

3. **Strengthen security:**
```bash
# Install and configure fail2ban
sudo apt-get install fail2ban

# Change SSH port (edit /etc/ssh/sshd_config)
sudo nano /etc/ssh/sshd_config
# Change: Port 22 to Port 2222
sudo systemctl restart sshd

# Disable root login
# In /etc/ssh/sshd_config: PermitRootLogin no

# Use key-based authentication only
# In /etc/ssh/sshd_config: PasswordAuthentication no
```

---

## Network Issues

### Problem: High Network Connections

**Symptoms:**
```
Established connections: 2847
```

**Diagnosis:**

1. **Analyze connections:**
```bash
# Count connections by state
netstat -an | awk '{print $6}' | sort | uniq -c

# Find connections by remote IP
netstat -an | grep ESTABLISHED | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr

# Check listening services
netstat -tlnp | grep LISTEN
```

2. **Identify suspicious activity:**
```bash
# Look for unusual ports
netstat -an | grep ESTABLISHED | awk '{print $4}' | cut -d: -f2 | sort | uniq -c | sort -nr

# Check for connections to unusual IPs
netstat -an | grep ESTABLISHED | awk '{print $5}' | cut -d: -f1 | sort | uniq | while read ip; do
    echo -n "$ip: "
    whois $ip | grep -i country || echo "Unknown"
done
```

**Solutions:**

1. **Limit connections:**
```bash
# For web servers - adjust MaxClients/worker_connections
# For databases - set max_connections

# Use connection rate limiting
sudo iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
```

2. **Block malicious traffic:**
```bash
# Block port scanners
sudo iptables -A INPUT -m recent --name portscan --rcheck --seconds 86400 -j DROP
sudo iptables -A INPUT -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
```

---

## System-Specific Issues

### Problem: Different Linux Distributions

**Issue:** Commands vary between distributions

**Solutions by Distribution:**

**Ubuntu/Debian:**
```bash
# Package management
sudo apt-get update
sudo apt-get install package-name

# Service management
sudo systemctl status service-name
sudo service service-name restart

# Log locations
/var/log/auth.log
/var/log/syslog
```

**CentOS/RHEL:**
```bash
# Package management
sudo yum update
sudo yum install package-name
# Or: sudo dnf install package-name

# Service management
sudo systemctl status service-name
sudo service service-name restart

# Log locations
/var/log/secure
/var/log/messages
```

**Alpine Linux:**
```bash
# Package management
apk update
apk add package-name

# Service management
rc-service service-name status
rc-service service-name restart

# Log locations
/var/log/messages
```

---

### Problem: Container Environments

**Issue:** Limited access in Docker/container environments

**Solutions:**

1. **Run with appropriate permissions:**
```bash
# Docker with host system access
docker run -v /proc:/host/proc -v /sys:/host/sys your-image

# Modify script to use /host/proc instead of /proc
```

2. **Use container-specific metrics:**
```bash
# Monitor container resources instead of host
docker stats container-name

# Use container-aware monitoring
cat /sys/fs/cgroup/memory/memory.usage_in_bytes
cat /sys/fs/cgroup/cpu/cpuacct.usage
```

---

## Quick Diagnostic Checklist

When the script isn't working properly, run through this checklist:

### ✅ Basic Checks
```bash
# 1. Check if script exists and is executable
ls -la server-stats.sh

# 2. Test basic execution
./server-stats.sh --help

# 3. Check dependencies
./test-server-stats.sh

# 4. Verify system access
ls -la /proc/meminfo /proc/stat
```

### ✅ Permission Checks
```bash
# 1. Check current user
whoami

# 2. Check file permissions
ls -la /var/log/auth.log

# 3. Test with sudo if needed
sudo ./server-stats.sh
```

### ✅ System Health
```bash
# 1. Check basic system commands
ps aux | head -5
free -h
df -h

# 2. Check system logs
tail /var/log/syslog
dmesg | tail
```

## Getting Help

### Debug Mode
```bash
# Enable verbose output
bash -x ./server-stats.sh

# Enable debug mode (if supported)
export DEBUG=1
./server-stats.sh
```

### Log Analysis
```bash
# Check system logs for errors
sudo grep -i error /var/log/syslog | tail -10
sudo grep -i "server-stats" /var/log/syslog

# Check for permission issues
sudo grep -i "permission denied" /var/log/syslog
```

### Community Support
- Check documentation: `README.md`
- Review examples: `docs/examples/`
- Search known issues: GitHub repository
- Ask for help: Community forums

---

**Remember: Most issues are related to permissions, missing dependencies, or system-specific differences. Start with the basics and work your way up! 🔧**

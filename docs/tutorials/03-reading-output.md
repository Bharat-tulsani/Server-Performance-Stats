# 📊 Reading Output: Understanding Your Server Statistics

## Overview

This guide teaches you how to interpret the output from the server-stats script. Understanding what each section means will help you make informed decisions about your server's health and performance.

## Output Structure

The server-stats script organizes information into clear sections:

1. **Header & System Information**
2. **CPU Usage Analysis**
3. **Memory Usage Analysis**
4. **Disk Usage Analysis**
5. **Top Processes (CPU & Memory)**
6. **Network & User Information**
7. **Security Information**
8. **System Alerts & Recommendations**

## Understanding the Header

```
  ____                          ____  _        _       
 / ___|  ___ _ ____   _____ _ __/ ___|| |_ __ _| |_ ___ 
 \___ \ / _ \ '__\ \ / / _ \ '__\___ \| __/ _` | __/ __|
  ___) |  __/ |   \ V /  __/ |   ___) | || (_| | |_\__ \
 |____/ \___|_|    \_/ \___|_|  |____/ \__\__,_|\__|___/

Server Performance Analysis Tool
Generated on: Sun Aug 11 10:30:45 EDT 2025
Hostname: web-server-01
```

**What this tells you:**
- **Generated on**: When the report was created
- **Hostname**: Which server this report is from (important in multi-server environments)

## System Information Section

```
================================
SYSTEM INFORMATION
================================
Operating System: Ubuntu 20.04.3 LTS
Kernel Version: 5.4.0-91-generic
Architecture: x86_64
Uptime: up 15 days, 3 hours, 22 minutes
Load Average:  0.25, 0.30, 0.28
```

### How to Read This:

**Operating System**: Shows your Linux distribution and version
- Helps with compatibility and security planning
- Older versions may need updates

**Uptime**: How long the server has been running
- `up 15 days, 3 hours, 22 minutes` means no recent reboots
- Very short uptime might indicate recent problems or maintenance

**Load Average**: System activity over 1, 5, and 15 minutes
- Format: `1-min, 5-min, 15-min`
- Compare to number of CPU cores:
  - `0.25` on 4-core system = 6.25% loaded ✅
  - `4.0` on 4-core system = 100% loaded ⚠️
  - `8.0` on 4-core system = 200% loaded 🔴

## CPU Usage Analysis

```
================================
CPU USAGE ANALYSIS
================================
Total CPU Usage: 25.3%  [GREEN]
CPU Cores: 4
CPU Model: Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz
```

### Color Coding:
- 🟢 **Green (0-70%)**: Normal usage, system responsive
- 🟡 **Yellow (70-85%)**: Moderate usage, monitor closely
- 🔴 **Red (85%+)**: High usage, may impact performance

### What This Means:
**25.3% CPU Usage**: Healthy level
- System has plenty of processing power available
- Applications should respond quickly
- Good headroom for traffic spikes

**CPU Cores: 4**: Processing capacity
- More cores = can handle more simultaneous tasks
- Important for understanding load average context

## Memory Usage Analysis

```
================================
MEMORY USAGE ANALYSIS
================================
Memory Overview:
              total        used        free      shared  buff/cache   available
Mem:           7.8G        2.1G        3.2G        180M        2.5G        5.3G
Swap:          2.0G          0B        2.0G

Memory Usage: 68.2%  [YELLOW]
Memory Free: 31.8%
Swap Usage: 0.0%  [GREEN]
```

### Understanding Memory Output:

**Memory Overview Table**:
- **total**: Total RAM installed (7.8G = 7.8 gigabytes)
- **used**: Memory actively used by applications (2.1G)
- **free**: Completely unused memory (3.2G)
- **buff/cache**: Memory used for system optimization (2.5G)
- **available**: Memory available for applications (5.3G)

### Key Insights:
**Memory Usage: 68.2%**: Close to warning threshold
- Yellow indicates monitoring needed
- Still acceptable but trending toward caution

**Swap Usage: 0.0%**: Excellent
- No swap usage means sufficient RAM
- Swap usage >0% indicates memory pressure

### When to Be Concerned:
- Memory usage >80% consistently
- Swap usage >10%
- Available memory <500MB on busy servers

## Disk Usage Analysis

```
================================
DISK USAGE ANALYSIS
================================
Disk Usage by Filesystem:
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G   12G  7.2G  63% /           [GREEN]
/dev/xvdb        100G   85G   10G  90% /var/log    [RED]
/dev/xvdc        50G    5G   42G  11% /home       [GREEN]

Largest Directories in /:
12G	/var
3.2G	/usr
1.8G	/opt
890M	/boot
156M	/etc
```

### Reading Disk Information:

**Color Coding**:
- 🟢 **Green (0-70%)**: Plenty of space
- 🟡 **Yellow (70-85%)**: Should plan for cleanup/expansion
- 🔴 **Red (85%+)**: Critical - immediate action needed

### Critical Example:
`/dev/xvdb 100G 85G 10G 90% /var/log [RED]`
- **90% full** is critical
- Only **10G remaining**
- **Action needed**: Clean log files or expand storage

### Safe Example:
`/dev/xvda1 20G 12G 7.2G 63% / [GREEN]`
- **63% usage** is healthy
- **7.2G available** provides good buffer

## Process Analysis

```
================================
TOP 5 PROCESSES BY CPU USAGE
================================
PID       USER      CPU%    COMMAND
12543     www-data  15.2%   nginx
8921      mysql     12.1%   mysqld
15632     root      8.7%    python3
22198     app-user  6.3%    node
7744      root      3.9%    systemd

================================
TOP 5 PROCESSES BY MEMORY USAGE
================================
PID       USER      MEM%    COMMAND
8921      mysql     25.4%   mysqld
15632     root      18.2%   python3
12543     www-data  12.8%   nginx
22198     app-user  9.7%    node
31445     postgres  7.3%    postgres
```

### Understanding Process Lists:

**Key Columns**:
- **PID**: Process ID (unique identifier)
- **USER**: Which user account runs the process
- **CPU%/MEM%**: Percentage of resource usage
- **COMMAND**: Program name

### Analysis Tips:

**High CPU Usage (15.2% nginx)**:
- Normal for web server under load
- Investigate if >50% for single process

**High Memory Usage (25.4% mysqld)**:
- Database using 25% of total RAM
- Normal for database servers
- Concern if >60% for single process

**What to Look For**:
- Unknown processes with high usage
- Processes you don't recognize
- Unexpectedly high resource consumption

## Network & User Information

```
================================
NETWORK & USER INFORMATION
================================
Currently Logged In Users:
admin    pts/0    2025-08-11 09:15
deploy   pts/1    2025-08-11 10:22

Established connections: 47

Services Listening on Ports:
tcp    0.0.0.0:22      sshd
tcp    0.0.0.0:80      nginx
tcp    127.0.0.1:3306  mysqld
```

### Key Information:

**Logged In Users**:
- Shows who has active sessions
- Monitor for unauthorized access
- `pts/0`, `pts/1` indicate terminal sessions

**Network Connections**:
- `47 established connections` shows activity level
- High numbers might indicate heavy load or attacks

**Listening Services**:
- Port 22: SSH (remote access)
- Port 80: Web server (HTTP)
- Port 3306: MySQL database (local only - 127.0.0.1)

## Security Information

```
================================
SECURITY INFORMATION
================================
Recent Failed Login Attempts: 3
Failed login attempts in auth.log: 3
Recent failed attempts:
Aug 11 08:45:23 Failed password for invalid user admin from 192.168.1.100
Aug 11 09:12:45 Failed password for root from 203.0.113.42
Aug 11 10:05:12 Failed password for invalid user test from 198.51.100.25
```

### Security Analysis:

**3 Failed Login Attempts**: Moderate concern
- Normal: 0-5 attempts per day
- Suspicious: >20 attempts per hour
- Critical: Hundreds of attempts (brute force attack)

**IP Address Patterns**:
- `192.168.1.100`: Internal network (might be legitimate mistake)
- `203.0.113.42`: External IP (more concerning)
- Multiple external IPs: Possible attack

## System Alerts & Recommendations

```
================================
SYSTEM ALERTS & RECOMMENDATIONS
================================
System Health Check:
⚠ WARNING: Disk usage high on /var/log (90%)
  Recommendation: Clean log files or expand storage

✓ Server statistics analysis complete!
For real-time monitoring, consider using: htop, iotop, or nethogs
```

### Alert Types:

**⚠️ Warnings**:
- Yellow-level issues that need attention
- Not immediately critical but should be addressed

**🔴 Critical Alerts**:
- Red-level issues requiring immediate action
- Can cause system failures if ignored

**✅ All Good**:
- No alerts means system is healthy
- Continue regular monitoring

## Practical Reading Examples

### Example 1: Healthy Server
```
CPU Usage: 25% [GREEN]
Memory Usage: 45% [GREEN]
Disk Usage: 55% [GREEN]
Load Average: 0.8, 0.9, 1.1  (on 4-core system)
No alerts
```
**Assessment**: Server is running smoothly, no action needed.

### Example 2: Warning Signs
```
CPU Usage: 78% [YELLOW]
Memory Usage: 82% [YELLOW]
Disk Usage: 88% [RED]
Load Average: 6.2, 5.8, 5.1  (on 4-core system)
WARNING: High disk usage
```
**Assessment**: Multiple warning signs, immediate attention needed for disk space.

### Example 3: Critical Issues
```
CPU Usage: 95% [RED]
Memory Usage: 94% [RED]
Swap Usage: 75% [RED]
Load Average: 12.5, 15.2, 18.1  (on 4-core system)
CRITICAL: Multiple resource exhaustion
```
**Assessment**: System is severely overloaded, investigate immediately.

## Action Guidelines

### 🟢 Green Status (0-70%)
**What to do**: Continue monitoring
- Regular daily/weekly checks
- Document baseline metrics
- Plan for future growth

### 🟡 Yellow Status (70-85%)
**What to do**: Investigate and plan
- Increase monitoring frequency
- Identify resource-heavy processes
- Plan optimization or upgrades
- Set up automated alerts

### 🔴 Red Status (85%+)
**What to do**: Take immediate action
- Identify and stop unnecessary processes
- Clean up disk space if needed
- Consider emergency resource allocation
- Investigate root cause
- Plan permanent solution

## Common Patterns and What They Mean

### Pattern 1: High CPU, Normal Memory
**Likely cause**: CPU-intensive tasks (calculations, compression)
**Action**: Optimize code or upgrade CPU

### Pattern 2: High Memory, Normal CPU
**Likely cause**: Memory leaks or large datasets
**Action**: Restart applications or add RAM

### Pattern 3: High Disk Usage
**Likely cause**: Log files, temporary files, or data growth
**Action**: Clean files or expand storage

### Pattern 4: High Load Average
**Likely cause**: Too many processes or I/O wait
**Action**: Reduce concurrent tasks or improve disk performance

## Quick Decision Reference

| Metric | Green | Yellow | Red | Immediate Action |
|--------|-------|--------|-----|------------------|
| CPU | 0-70% | 70-85% | 85%+ | Kill unnecessary processes |
| Memory | 0-70% | 70-85% | 85%+ | Restart memory-heavy apps |
| Disk | 0-70% | 70-85% | 85%+ | Clean files immediately |
| Load | <cores | 1-2x cores | >2x cores | Reduce system load |

## Next Steps

Now that you can read the output:
1. **Practice with examples**: [Basic Usage Examples](../examples/basic-usage.md)
2. **Learn troubleshooting**: [Troubleshooting Guide](04-troubleshooting.md)
3. **Set up automation**: [Automation Guide](05-automation.md)

---

**Remember: Regular monitoring and understanding your server's patterns is key to maintaining optimal performance! 📈**

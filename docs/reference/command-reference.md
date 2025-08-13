# 🔧 Command Reference

## Overview

Complete reference guide for all server-stats commands, options, and features. This document serves as the definitive guide for command-line usage and script parameters.

## Basic Command Syntax

```bash
server-stats [OPTIONS]
```

## Command Options

### Core Options

| Option | Description | Example |
|--------|-------------|---------|
| `--help`, `-h` | Show help information | `server-stats --help` |
| `--version`, `-v` | Display version information | `server-stats --version` |
| `--config FILE` | Use custom configuration file | `server-stats --config /etc/myconfig.conf` |
| `--no-color` | Disable colored output | `server-stats --no-color` |
| `--quiet`, `-q` | Suppress headers and decorations | `server-stats --quiet` |
| `--json` | Output in JSON format | `server-stats --json` |
| `--csv` | Output in CSV format | `server-stats --csv` |

### Section Control Options

| Option | Description | Default |
|--------|-------------|---------|
| `--no-cpu` | Skip CPU analysis | Enabled |
| `--no-memory` | Skip memory analysis | Enabled |
| `--no-disk` | Skip disk analysis | Enabled |
| `--no-processes` | Skip process analysis | Enabled |
| `--no-network` | Skip network information | Enabled |
| `--no-security` | Skip security information | Enabled |
| `--no-alerts` | Skip system alerts | Enabled |

### Advanced Options

| Option | Description | Example |
|--------|-------------|---------|
| `--interval SECONDS` | Continuous monitoring mode | `server-stats --interval 30` |
| `--count NUMBER` | Number of iterations in continuous mode | `server-stats --interval 10 --count 6` |
| `--output FILE` | Save output to file | `server-stats --output report.txt` |
| `--append` | Append to output file instead of overwrite | `server-stats --output log.txt --append` |
| `--timestamp` | Add timestamp to each line | `server-stats --timestamp` |

## Configuration File Options

### Location Priority
1. Command line specified: `--config /path/to/config`
2. User configuration: `~/.server-stats/server-stats.conf`
3. System configuration: `/etc/server-stats/server-stats.conf`
4. Built-in defaults

### Configuration Format

```bash
# server-stats.conf example

# Threshold Settings
CPU_WARNING_THRESHOLD=80
CPU_CRITICAL_THRESHOLD=90
MEMORY_WARNING_THRESHOLD=80
MEMORY_CRITICAL_THRESHOLD=90
DISK_WARNING_THRESHOLD=80
DISK_CRITICAL_THRESHOLD=90

# Display Settings
ENABLE_COLORS=true
TOP_PROCESSES_COUNT=5
SHOW_SWAP_INFO=true
SHOW_NETWORK_STATS=true
SHOW_SECURITY_LOGS=true

# Output Settings
OUTPUT_FORMAT="console"  # console, json, csv
TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"
```

## Command Examples

### Basic Usage

```bash
# Standard server statistics
server-stats

# Quiet mode (minimal output)
server-stats --quiet

# No colored output (for logging)
server-stats --no-color

# JSON output for integration
server-stats --json
```

### Selective Monitoring

```bash
# Only CPU and memory
server-stats --no-disk --no-processes --no-network --no-security

# Only security information
server-stats --no-cpu --no-memory --no-disk --no-processes --no-network

# Skip resource-intensive sections
server-stats --no-processes --no-network
```

### Continuous Monitoring

```bash
# Monitor every 30 seconds indefinitely
server-stats --interval 30

# Monitor every 10 seconds, 6 times (1 minute total)
server-stats --interval 10 --count 6

# Continuous monitoring with output to file
server-stats --interval 60 --output /var/log/server-monitor.log --append
```

### Output and Logging

```bash
# Save to file
server-stats --output daily-report-$(date +%Y%m%d).txt

# Append to log file with timestamp
server-stats --timestamp --output /var/log/server-stats.log --append

# JSON output to file
server-stats --json --output stats.json

# CSV output for spreadsheet
server-stats --csv --output stats.csv
```

## Return Codes

The script returns different exit codes based on system status:

| Exit Code | Meaning | Description |
|-----------|---------|-------------|
| 0 | Success | Normal execution, no critical issues |
| 1 | Warning | One or more warnings detected |
| 2 | Critical | Critical issues found |
| 3 | Error | Script execution error |
| 4 | Permission | Insufficient permissions |
| 5 | Dependency | Missing required commands |

### Using Return Codes

```bash
# Check script exit status
server-stats
case $? in
    0) echo "System healthy" ;;
    1) echo "Warnings detected" ;;
    2) echo "Critical issues found" ;;
    *) echo "Script error" ;;
esac

# Use in conditional statements
if server-stats --quiet >/dev/null; then
    echo "All systems normal"
else
    echo "Issues detected, check logs"
fi
```

## Environment Variables

### Configuration Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SERVER_STATS_CONFIG` | Path to configuration file | Auto-detected |
| `SERVER_STATS_NO_COLOR` | Disable colors (any value) | false |
| `SERVER_STATS_QUIET` | Enable quiet mode | false |
| `SERVER_STATS_DEBUG` | Enable debug output | false |

### Usage Examples

```bash
# Disable colors via environment
export SERVER_STATS_NO_COLOR=1
server-stats

# Use custom config location
export SERVER_STATS_CONFIG=/opt/monitoring/server-stats.conf
server-stats

# Enable debug mode
export SERVER_STATS_DEBUG=1
server-stats
```

## Output Formats

### Console Format (Default)

```
================================
SYSTEM INFORMATION
================================
Operating System: Ubuntu 20.04.3 LTS
Uptime: up 5 days, 2 hours, 30 minutes
```

### JSON Format

```bash
server-stats --json
```

```json
{
  "timestamp": "2025-08-11T15:30:45Z",
  "hostname": "web-server-01",
  "system": {
    "os": "Ubuntu 20.04.3 LTS",
    "uptime": "up 5 days, 2 hours, 30 minutes",
    "load_average": [1.2, 1.1, 0.9]
  },
  "cpu": {
    "usage_percent": 35.2,
    "cores": 4,
    "status": "normal"
  },
  "memory": {
    "usage_percent": 62.1,
    "free_percent": 37.9,
    "swap_percent": 0.0,
    "status": "normal"
  },
  "alerts": []
}
```

### CSV Format

```bash
server-stats --csv
```

```csv
timestamp,hostname,cpu_percent,memory_percent,disk_percent,status
2025-08-11T15:30:45Z,web-server-01,35.2,62.1,58.0,normal
```

### Quiet Format

```bash
server-stats --quiet
```

```
CPU: 35.2% Memory: 62.1% Disk: 58.0% Status: Normal
```

## Advanced Command Combinations

### Monitoring Specific Metrics

```bash
# CPU monitoring only
server-stats --no-memory --no-disk --no-processes --no-network --no-security --quiet

# Memory and disk only
server-stats --no-cpu --no-processes --no-network --no-security --quiet

# Process analysis only
server-stats --no-cpu --no-memory --no-disk --no-network --no-security
```

### Alert-Only Mode

```bash
# Show only if there are problems
server-stats --quiet | grep -E "WARNING|CRITICAL" || echo "All systems normal"

# JSON alerts only
server-stats --json | jq '.alerts[] | select(.level == "warning" or .level == "critical")'
```

### Integration with Other Tools

```bash
# Send to syslog
server-stats --quiet --timestamp | logger -t server-stats

# Monitor via cron with email alerts
server-stats --quiet | grep -q "CRITICAL" && server-stats | mail -s "Server Alert" admin@example.com

# Integration with monitoring systems
server-stats --json | curl -X POST -H "Content-Type: application/json" -d @- http://monitoring.example.com/api/stats
```

## Customization Options

### Custom Thresholds

```bash
# Via configuration file
cat > ~/.server-stats/server-stats.conf << EOF
CPU_WARNING_THRESHOLD=70
CPU_CRITICAL_THRESHOLD=85
MEMORY_WARNING_THRESHOLD=75
MEMORY_CRITICAL_THRESHOLD=85
DISK_WARNING_THRESHOLD=85
DISK_CRITICAL_THRESHOLD=95
EOF

# Via environment variables
export CPU_WARNING_THRESHOLD=70
export MEMORY_WARNING_THRESHOLD=75
server-stats
```

### Custom Output Format

```bash
# Custom timestamp format
export TIMESTAMP_FORMAT="%Y%m%d_%H%M%S"
server-stats --timestamp

# Custom process count
export TOP_PROCESSES_COUNT=10
server-stats
```

## Performance Considerations

### Execution Time Optimization

```bash
# Fast mode (skip expensive operations)
server-stats --no-processes --no-network --no-security

# Minimal mode (only critical metrics)
server-stats --quiet --no-processes --no-network --no-security --no-alerts

# Background monitoring (reduced impact)
server-stats --interval 300 --quiet --output /dev/null &
```

### Resource Usage

| Operation | CPU Impact | I/O Impact | Time |
|-----------|------------|------------|------|
| CPU check | Low | None | <1s |
| Memory check | Low | None | <1s |
| Disk check | Low | Low | 1-2s |
| Process list | Medium | Low | 2-3s |
| Network stats | Medium | Low | 1-2s |
| Security logs | Low | High | 2-5s |

## Troubleshooting Commands

### Debug Mode

```bash
# Enable debug output
export SERVER_STATS_DEBUG=1
server-stats

# Verbose bash execution
bash -x server-stats
```

### Dependency Check

```bash
# Check required commands
for cmd in ps top free df uptime who bc awk grep; do
    command -v "$cmd" >/dev/null && echo "✅ $cmd" || echo "❌ $cmd"
done
```

### Permission Issues

```bash
# Check file permissions
ls -la server-stats

# Check execution permissions
test -x server-stats && echo "Executable" || echo "Not executable"

# Check log file access
ls -la /var/log/auth.log 2>/dev/null || echo "Log file not accessible"
```

## Scripting Integration

### Bash Functions

```bash
# Function for regular health checks
check_server_health() {
    local status
    if server-stats --quiet >/dev/null 2>&1; then
        status=$?
        case $status in
            0) echo "healthy" ;;
            1) echo "warning" ;;
            2) echo "critical" ;;
            *) echo "error" ;;
        esac
    else
        echo "error"
    fi
}

# Usage
health=$(check_server_health)
echo "Server status: $health"
```

### Monitoring Scripts

```bash
#!/bin/bash
# monitoring-wrapper.sh

# Configuration
ALERT_EMAIL="admin@example.com"
LOG_FILE="/var/log/server-monitoring.log"
CRITICAL_THRESHOLD=2

# Run server-stats and capture exit code
server-stats --timestamp >> "$LOG_FILE" 2>&1
exit_code=$?

# Handle different status levels
case $exit_code in
    0)
        echo "$(date): System healthy" >> "$LOG_FILE"
        ;;
    1)
        echo "$(date): Warnings detected" >> "$LOG_FILE"
        ;;
    2)
        echo "$(date): Critical issues detected" >> "$LOG_FILE"
        server-stats | mail -s "CRITICAL: Server Alert - $(hostname)" "$ALERT_EMAIL"
        ;;
    *)
        echo "$(date): Monitoring script error" >> "$LOG_FILE"
        ;;
esac
```

## API Integration

### REST API Format

```bash
# JSON output suitable for REST APIs
server-stats --json --quiet | jq '{
    timestamp: .timestamp,
    host: .hostname,
    metrics: {
        cpu: .cpu.usage_percent,
        memory: .memory.usage_percent,
        disk: .disk.max_usage_percent
    },
    status: (.alerts | length > 0 | if . then "alert" else "normal" end)
}'
```

### Webhook Integration

```bash
# Send to webhook
webhook_url="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
data=$(server-stats --json --quiet)
curl -X POST -H "Content-Type: application/json" -d "$data" "$webhook_url"
```

## Version Information

```bash
# Show version
server-stats --version

# Show detailed version info
server-stats --version --verbose

# Show configuration and version
server-stats --version --show-config
```

---

**This command reference covers all available options and usage patterns for the server-stats script! 📚**

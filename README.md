# Server Performance Stats

A simple bash script to analyze server performance statistics on Linux systems.

## Features

- **CPU Usage**: Current usage percentage and load averages
- **Memory Usage**: Free vs used memory with percentages
- **Disk Usage**: Free vs used disk space with percentages  
- **Top Processes**: Top 5 processes by CPU and memory usage
- **System Info**: OS version, uptime, logged users, and more

## Quick Start

1. Make the script executable:
   ```bash
   chmod +x server-stats.sh
   ```

2. Run the script:
   ```bash
   ./server-stats.sh
   ```

## Usage Options

```bash
./server-stats.sh [OPTIONS]

Options:
  -h, --help          Show help message
  --cpu-only          Show only CPU statistics  
  --memory-only       Show only memory statistics
  --disk-only         Show only disk statistics
  --basic             Show basic stats only
```

## Configuration

Copy `server-stats.conf.example` to `server-stats.conf` and customize settings as needed.

## Requirements

- Linux operating system
- Bash shell
- Standard system utilities (ps, df, free, etc.)

## Example Output

```
================================
SERVER PERFORMANCE STATISTICS  
================================
Generated on: 2025-09-14 10:30:45
Hostname: server01

📊 CPU USAGE
----------------------------------------
Current CPU Usage: 15.50%
Load Average:  0.45, 0.32, 0.28
CPU Cores: 4

💾 MEMORY USAGE  
----------------------------------------
Total Memory: 8.00 GB
Used Memory: 4.20 GB (52.50%)
Available Memory: 3.80 GB (47.50%)
```
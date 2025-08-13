# 🛠️ Installation Guide: Setting Up Server-Stats

## Overview

This guide will walk you through installing the server-stats monitoring script on your Linux system. We'll cover different installation methods and troubleshoot common issues.

## Prerequisites

### System Requirements
- **Operating System**: Any modern Linux distribution
  - Ubuntu 16.04+
  - CentOS 7+
  - Debian 9+
  - RHEL 7+
  - Amazon Linux 2
  - Alpine Linux 3.x

- **Shell**: Bash 4.0 or newer
- **Permissions**: Regular user account (sudo for system-wide install)
- **Disk Space**: ~10MB for installation and logs

### Required Commands
The following commands must be available on your system:

| Command | Purpose | Usually Available |
|---------|---------|-------------------|
| `bash` | Shell interpreter | ✅ Always |
| `ps` | Process information | ✅ Always |
| `top` | System monitoring | ✅ Always |
| `free` | Memory information | ✅ Always |
| `df` | Disk usage | ✅ Always |
| `uptime` | System uptime | ✅ Always |
| `who` | User information | ✅ Always |
| `bc` | Calculator | ⚠️ May need install |
| `netstat` | Network statistics | ⚠️ May need install |

## Installation Methods

### Method 1: Quick Installation (Recommended)

#### Step 1: Download the Files
```bash
# If you have the files locally
cd /path/to/server-stats-files

# Or download from repository
# git clone https://github.com/your-repo/server-stats.git
# cd server-stats
```

#### Step 2: Make Scripts Executable
```bash
chmod +x server-stats.sh
chmod +x install.sh
chmod +x test-server-stats.sh
```

#### Step 3: Test Before Installing
```bash
# Run the test script to check dependencies
./test-server-stats.sh
```

#### Step 4: Install System-Wide (Optional)
```bash
# For all users (requires sudo)
sudo ./install.sh

# Or install for current user only
./install.sh
```

### Method 2: Manual Installation

#### Step 1: Create Directory Structure
```bash
# For system-wide installation
sudo mkdir -p /usr/local/bin
sudo mkdir -p /etc/server-stats

# For user installation
mkdir -p ~/bin
mkdir -p ~/.server-stats
```

#### Step 2: Copy Files
```bash
# System-wide
sudo cp server-stats.sh /usr/local/bin/server-stats
sudo cp server-stats.conf.example /etc/server-stats/
sudo cp README.md /etc/server-stats/

# User installation
cp server-stats.sh ~/bin/server-stats
cp server-stats.conf.example ~/.server-stats/
cp README.md ~/.server-stats/
```

#### Step 3: Set Permissions
```bash
# System-wide
sudo chmod +x /usr/local/bin/server-stats

# User installation
chmod +x ~/bin/server-stats
```

#### Step 4: Update PATH (if needed)
```bash
# Add to ~/.bashrc for user installation
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Installing Missing Dependencies

### Ubuntu/Debian Systems
```bash
# Update package list
sudo apt-get update

# Install missing dependencies
sudo apt-get install bc net-tools procps

# Optional: Enhanced tools
sudo apt-get install htop iotop nethogs
```

### CentOS/RHEL Systems
```bash
# Install missing dependencies
sudo yum install bc net-tools procps

# For CentOS 8+/RHEL 8+
sudo dnf install bc net-tools procps

# Optional: Enhanced tools
sudo yum install htop iotop
```

### Alpine Linux
```bash
# Install missing dependencies
apk add bc net-tools procps

# Optional: Enhanced tools
apk add htop iotop
```

### Amazon Linux 2
```bash
# Install missing dependencies
sudo yum install bc net-tools procps

# Optional: Enhanced tools
sudo amazon-linux-extras install htop
```

## Verification

### Test Installation
```bash
# Check if command is available
which server-stats

# Test basic functionality
server-stats

# Or run directly
/usr/local/bin/server-stats
~/bin/server-stats
```

### Verify Dependencies
```bash
# Run the test script
./test-server-stats.sh

# Manual verification
for cmd in ps top free df uptime who bc; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd - Available"
    else
        echo "❌ $cmd - Missing"
    fi
done
```

## Configuration

### Basic Configuration
```bash
# Copy example configuration
sudo cp /etc/server-stats/server-stats.conf.example /etc/server-stats/server-stats.conf

# Or for user installation
cp ~/.server-stats/server-stats.conf.example ~/.server-stats/server-stats.conf

# Edit configuration
sudo nano /etc/server-stats/server-stats.conf
# or
nano ~/.server-stats/server-stats.conf
```

### Key Configuration Options
```bash
# Threshold settings
CPU_WARNING_THRESHOLD=80
MEMORY_WARNING_THRESHOLD=80
DISK_WARNING_THRESHOLD=80

# Display settings
TOP_PROCESSES_COUNT=5
ENABLE_COLORS=true
SHOW_NETWORK_STATS=true
```

## Troubleshooting Installation

### Common Issues and Solutions

#### Issue 1: Permission Denied
```bash
# Error: ./server-stats.sh: Permission denied
# Solution: Make script executable
chmod +x server-stats.sh
```

#### Issue 2: Command Not Found
```bash
# Error: server-stats: command not found
# Solution: Check PATH or use full path
echo $PATH
export PATH="/usr/local/bin:$PATH"
```

#### Issue 3: Missing bc Command
```bash
# Error: bc: command not found
# Solution: Install bc calculator
sudo apt-get install bc        # Ubuntu/Debian
sudo yum install bc            # CentOS/RHEL
```

#### Issue 4: Cannot Create Directory
```bash
# Error: mkdir: cannot create directory
# Solution: Check permissions or use sudo
sudo mkdir -p /usr/local/bin
```

#### Issue 5: Script Fails to Run
```bash
# Check script syntax
bash -n server-stats.sh

# Run with debugging
bash -x server-stats.sh
```

### Compatibility Issues

#### Old Bash Versions
```bash
# Check bash version
bash --version

# If version < 4.0, some features may not work
# Upgrade bash or use compatible Linux distribution
```

#### Missing /proc Filesystem
```bash
# Check if /proc is mounted
ls /proc/

# Mount if missing (rarely needed)
sudo mount -t proc proc /proc
```

#### Limited User Permissions
```bash
# Some features require access to log files
# Grant appropriate permissions or run with sudo
sudo chmod +r /var/log/auth.log
```

## Post-Installation Setup

### 1. Create Configuration File
```bash
# Copy and customize configuration
sudo cp /etc/server-stats/server-stats.conf.example /etc/server-stats/server-stats.conf
sudo nano /etc/server-stats/server-stats.conf
```

### 2. Set Up Log Directory (Optional)
```bash
# Create log directory for reports
sudo mkdir -p /var/log/server-stats
sudo chown $(whoami) /var/log/server-stats
```

### 3. Create Desktop Shortcut (Optional)
```bash
# Create desktop entry for GUI users
cat > ~/.local/share/applications/server-stats.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Server Stats
Comment=Server Performance Monitoring
Exec=gnome-terminal -- server-stats
Icon=utilities-system-monitor
Terminal=true
Categories=System;Monitor;
EOF
```

### 4. Set Up Bash Completion (Optional)
```bash
# Create completion script
sudo tee /etc/bash_completion.d/server-stats << 'EOF'
_server_stats() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--help --version --config --no-color"
    
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _server_stats server-stats
EOF

# Reload bash completion
source /etc/bash_completion.d/server-stats
```

## Testing Your Installation

### Quick Test
```bash
# Run basic test
server-stats | head -20

# Check specific sections
server-stats | grep -A 5 "CPU USAGE"
server-stats | grep -A 10 "MEMORY USAGE"
```

### Comprehensive Test
```bash
# Run full test script
./test-server-stats.sh

# Manual comprehensive test
echo "Testing server-stats installation..."

# Test basic execution
if server-stats >/dev/null 2>&1; then
    echo "✅ Basic execution: PASS"
else
    echo "❌ Basic execution: FAIL"
fi

# Test output sections
output=$(server-stats 2>/dev/null)
for section in "CPU USAGE" "MEMORY USAGE" "DISK USAGE" "PROCESSES"; do
    if echo "$output" | grep -q "$section"; then
        echo "✅ $section section: PASS"
    else
        echo "❌ $section section: FAIL"
    fi
done
```

## Uninstallation

### Automatic Uninstallation
```bash
# If you used the installer
sudo bash /etc/server-stats/uninstall.sh
# or
bash ~/.server-stats/uninstall.sh
```

### Manual Uninstallation
```bash
# Remove system-wide installation
sudo rm -f /usr/local/bin/server-stats
sudo rm -rf /etc/server-stats

# Remove user installation
rm -f ~/bin/server-stats
rm -rf ~/.server-stats

# Remove from PATH in ~/.bashrc (if added)
sed -i '/export PATH="$HOME\/bin:$PATH"/d' ~/.bashrc
```

## Next Steps

After successful installation:

1. **Learn to use the script**: [Reading Output Guide](03-reading-output.md)
2. **Try basic examples**: [Basic Usage Examples](../examples/basic-usage.md)
3. **Set up automation**: [Automation Guide](05-automation.md)
4. **Customize settings**: [Configuration Reference](../reference/configuration.md)

## Quick Reference

### Essential Commands
```bash
# Install dependencies
sudo apt-get install bc net-tools    # Ubuntu/Debian
sudo yum install bc net-tools         # CentOS/RHEL

# Make executable
chmod +x server-stats.sh

# Install system-wide
sudo ./install.sh

# Run script
server-stats

# Test installation
./test-server-stats.sh
```

---

**Congratulations! You're ready to start monitoring your server! 🎉**

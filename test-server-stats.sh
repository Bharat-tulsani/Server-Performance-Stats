#!/bin/bash

#############################################
# TEST SCRIPT FOR SERVER-STATS.SH
# This script demonstrates the functionality
# and tests the server-stats script
#############################################

echo "=========================================="
echo "SERVER-STATS.SH TESTING SCRIPT"
echo "=========================================="
echo ""

# Check if server-stats.sh exists
if [ ! -f "server-stats.sh" ]; then
    echo "❌ server-stats.sh not found in current directory"
    echo "Please ensure the script is in the same directory"
    exit 1
fi

# Check if script is executable
if [ ! -x "server-stats.sh" ]; then
    echo "📋 Making server-stats.sh executable..."
    chmod +x server-stats.sh
    echo "✅ Script is now executable"
    echo ""
fi

# Test required commands
echo "🔍 Testing required system commands..."
echo ""

commands=("ps" "top" "free" "df" "uptime" "who" "bc" "awk" "grep")
missing_commands=()

for cmd in "${commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd - Available"
    else
        echo "❌ $cmd - Missing"
        missing_commands+=("$cmd")
    fi
done

echo ""

if [ ${#missing_commands[@]} -eq 0 ]; then
    echo "🎉 All required commands are available!"
    echo ""
    
    # Show current system info before running the script
    echo "📊 Quick System Overview:"
    echo "- Hostname: $(hostname)"
    echo "- Date: $(date)"
    echo "- User: $(whoami)"
    echo "- Shell: $SHELL"
    echo ""
    
    echo "🚀 Running server-stats.sh..."
    echo "=========================================="
    echo ""
    
    # Run the actual script
    ./server-stats.sh
    
    echo ""
    echo "=========================================="
    echo "✅ Script execution completed!"
    echo ""
    echo "💡 Tips:"
    echo "- Run this script regularly to monitor server health"
    echo "- Check the README.md for detailed usage instructions"
    echo "- Consider setting up automated monitoring with cron"
    
else
    echo "⚠️  Missing commands detected!"
    echo "Please install the following commands:"
    for cmd in "${missing_commands[@]}"; do
        echo "  - $cmd"
    done
    echo ""
    echo "Installation suggestions:"
    echo "- Ubuntu/Debian: sudo apt-get install bc procps net-tools"
    echo "- CentOS/RHEL: sudo yum install bc procps net-tools"
    echo "- Alpine: apk add bc procps net-tools"
fi

echo ""
echo "🔗 For more information, check README.md"

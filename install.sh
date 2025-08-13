#!/bin/bash

#############################################
# INSTALLATION SCRIPT FOR SERVER-STATS
# This script installs server-stats.sh system-wide
#############################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=========================================="
echo "SERVER-STATS.SH INSTALLER"
echo -e "==========================================${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    INSTALL_DIR="/usr/local/bin"
    CONFIG_DIR="/etc/server-stats"
    echo -e "${GREEN}✓ Running as root - system-wide installation${NC}"
else
    INSTALL_DIR="$HOME/bin"
    CONFIG_DIR="$HOME/.server-stats"
    echo -e "${YELLOW}! Running as user - local installation${NC}"
    echo "  Installing to: $INSTALL_DIR"
fi

echo ""

# Check if server-stats.sh exists
if [ ! -f "server-stats.sh" ]; then
    echo -e "${RED}❌ server-stats.sh not found in current directory${NC}"
    echo "Please run this installer from the directory containing server-stats.sh"
    exit 1
fi

# Create directories
echo "📁 Creating directories..."
mkdir -p "$INSTALL_DIR" 2>/dev/null
mkdir -p "$CONFIG_DIR" 2>/dev/null

if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${RED}❌ Failed to create $INSTALL_DIR${NC}"
    echo "Please check permissions or run with appropriate privileges"
    exit 1
fi

# Install main script
echo "📦 Installing server-stats script..."
cp server-stats.sh "$INSTALL_DIR/server-stats"
chmod +x "$INSTALL_DIR/server-stats"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Script installed to $INSTALL_DIR/server-stats${NC}"
else
    echo -e "${RED}❌ Failed to install script${NC}"
    exit 1
fi

# Install configuration example
if [ -f "server-stats.conf.example" ]; then
    echo "⚙️  Installing configuration example..."
    cp server-stats.conf.example "$CONFIG_DIR/"
    echo -e "${GREEN}✓ Configuration example installed to $CONFIG_DIR/${NC}"
fi

# Install README
if [ -f "README.md" ]; then
    echo "📖 Installing documentation..."
    cp README.md "$CONFIG_DIR/"
    echo -e "${GREEN}✓ Documentation installed to $CONFIG_DIR/${NC}"
fi

# Check and install dependencies
echo ""
echo "🔍 Checking dependencies..."

dependencies=("bc" "ps" "top" "free" "df" "uptime" "who" "awk" "grep")
missing_deps=()

for dep in "${dependencies[@]}"; do
    if command -v "$dep" >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} $dep"
    else
        echo -e "  ${RED}✗${NC} $dep"
        missing_deps+=("$dep")
    fi
done

if [ ${#missing_deps[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Missing dependencies detected:${NC}"
    for dep in "${missing_deps[@]}"; do
        echo "    - $dep"
    done
    echo ""
    echo "To install missing dependencies:"
    echo ""
    echo "Ubuntu/Debian:"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install bc procps net-tools"
    echo ""
    echo "CentOS/RHEL:"
    echo "  sudo yum install bc procps net-tools"
    echo ""
    echo "Alpine Linux:"
    echo "  apk add bc procps net-tools"
fi

# Add to PATH if needed
echo ""
echo "🔧 Checking PATH configuration..."

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}⚠️  $INSTALL_DIR is not in your PATH${NC}"
    echo ""
    echo "To add it to your PATH, add this line to your shell profile:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    echo ""
    echo "Shell profile locations:"
    echo "  - Bash: ~/.bashrc or ~/.bash_profile"
    echo "  - Zsh: ~/.zshrc"
    echo "  - Fish: ~/.config/fish/config.fish"
    echo ""
    
    # Offer to add to bashrc if it exists
    if [ -f "$HOME/.bashrc" ] && [ "$INSTALL_DIR" = "$HOME/bin" ]; then
        read -p "Add to ~/.bashrc automatically? (y/n): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$HOME/.bashrc"
            echo -e "${GREEN}✓ Added to ~/.bashrc${NC}"
            echo "Please run: source ~/.bashrc"
        fi
    fi
else
    echo -e "${GREEN}✓ $INSTALL_DIR is already in PATH${NC}"
fi

# Test installation
echo ""
echo "🧪 Testing installation..."

if command -v server-stats >/dev/null 2>&1; then
    echo -e "${GREEN}✓ server-stats command is available${NC}"
    echo ""
    echo "To run the script:"
    echo "  server-stats"
elif [ -x "$INSTALL_DIR/server-stats" ]; then
    echo -e "${YELLOW}! server-stats installed but not in PATH${NC}"
    echo ""
    echo "To run the script:"
    echo "  $INSTALL_DIR/server-stats"
else
    echo -e "${RED}❌ Installation verification failed${NC}"
    exit 1
fi

# Create uninstall script
echo ""
echo "📝 Creating uninstall script..."
cat > "$CONFIG_DIR/uninstall.sh" << EOF
#!/bin/bash
echo "Uninstalling server-stats..."
rm -f "$INSTALL_DIR/server-stats"
rm -rf "$CONFIG_DIR"
echo "Uninstallation complete!"
EOF

chmod +x "$CONFIG_DIR/uninstall.sh"
echo -e "${GREEN}✓ Uninstall script created at $CONFIG_DIR/uninstall.sh${NC}"

# Installation summary
echo ""
echo -e "${BLUE}=========================================="
echo "INSTALLATION COMPLETE!"
echo -e "==========================================${NC}"
echo ""
echo "📍 Installation Summary:"
echo "  Script: $INSTALL_DIR/server-stats"
echo "  Config: $CONFIG_DIR/"
echo "  Docs:   $CONFIG_DIR/README.md"
echo ""
echo "🚀 Quick Start:"
if command -v server-stats >/dev/null 2>&1; then
    echo "  server-stats"
else
    echo "  $INSTALL_DIR/server-stats"
fi
echo ""
echo "📖 For detailed usage instructions:"
echo "  cat $CONFIG_DIR/README.md"
echo ""
echo "🗑️  To uninstall:"
echo "  bash $CONFIG_DIR/uninstall.sh"
echo ""
echo -e "${GREEN}Happy monitoring! 🖥️📊${NC}"

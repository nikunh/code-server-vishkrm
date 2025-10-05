#!/usr/bin/env zsh
set -e

# Logging mechanism for debugging
LOG_FILE="/tmp/code-server-install.log"
log_debug() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [DEBUG] $*" >> "$LOG_FILE"
}

# Initialize logging
log_debug "=== CODE-SERVER INSTALL STARTED ==="
log_debug "Script path: $0"
log_debug "PWD: $(pwd)"
log_debug "Environment: USER=$USER HOME=$HOME"

# Set non-interactive environment
export DEBIAN_FRONTEND=noninteractive

# Function to get system architecture
get_architecture() {
    local arch="$(uname -m)"
    case "$arch" in
        x86_64|amd64) echo "amd64" ;;
        aarch64|arm64) echo "arm64" ;;
        armv7l) echo "armv7" ;;
        *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
    esac
}

# Install code-server using direct package installation (non-interactive)
if ! command -v code-server &> /dev/null; then
  echo "Installing code-server via direct package download..."
  VERSION="4.104.0"
  ARCH=$(get_architecture)

  # Download and install code-server package directly
  curl -fsSL "https://github.com/coder/code-server/releases/download/v${VERSION}/code-server_${VERSION}_${ARCH}.deb" -o /tmp/code-server.deb
  dpkg -i /tmp/code-server.deb || apt-get install -f -y --no-install-recommends
  rm -f /tmp/code-server.deb

  echo "code-server installed successfully"
fi

# Copy code-server config if not present
if [ ! -d "$HOME/.config/code-server" ] && [ -d /etc/static/configs/code-server ]; then
  cp -rf /etc/static/configs/code-server $HOME/.config/
fi

# Clean up
sudo apt-get clean

log_debug "=== CODE-SERVER INSTALL COMPLETED ==="
# Auto-trigger build Tue Sep 23 20:02:59 BST 2025

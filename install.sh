#!/bin/zsh
#
# Installer for sr
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/sr/main/install.sh | zsh

set -e

REPO_RAW="https://raw.githubusercontent.com/YOUR_USERNAME/sr/main"
INSTALL_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR"
curl -fsSL "$REPO_RAW/sr" -o "$INSTALL_DIR/sr"
chmod +x "$INSTALL_DIR/sr"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo '' >> "$HOME/.zshrc"
  echo '# added by sr installer' >> "$HOME/.zshrc"
  echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$HOME/.zshrc"
  echo "Added $INSTALL_DIR to PATH in ~/.zshrc"
fi

echo ""
echo "Installed. Run 'source ~/.zshrc' or restart your terminal."
echo "Then just type: sr"

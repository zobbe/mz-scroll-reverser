#!/bin/zsh
#
# Installer for sr
# Usage: curl -fsSL https://raw.githubusercontent.com/zobbe/mz-scroll-reverser/main/install.sh | zsh

set -e

REPO_RAW="https://raw.githubusercontent.com/zobbe/mz-scroll-reverser/main"
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
echo "Installed. Then just type: sr"
echo ""

# Only prompt if running interactively (not piped)
if [[ -t 0 ]]; then
  read "reply?Do you want to restart your terminal? (Y/n) "
  reply="${reply:-Y}"
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    source "$HOME/.zshrc"
    echo "Terminal reloaded."
  fi
else
  echo "Run 'source ~/.zshrc' or restart your terminal to apply changes."
fi

#!/bin/zsh
#
# Uninstaller for sr

INSTALL_DIR="$HOME/.local/bin"

if [ -f "$INSTALL_DIR/sr" ]; then
  rm "$INSTALL_DIR/sr"
  echo "Removed $INSTALL_DIR/sr"
else
  echo "sr not found in $INSTALL_DIR, nothing to remove"
fi

echo "Note: the PATH line added to ~/.zshrc was left in place, remove it manually if you want"

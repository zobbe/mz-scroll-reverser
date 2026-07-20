#!/bin/zsh
#
# Uninstaller for sr

INSTALL_DIR="$HOME/.local/bin"
STATE_DIR="$HOME/.local/share/sr"
PID_FILE="$STATE_DIR/sr.pid"

# Stop the daemon if it's running
if [ -f "$PID_FILE" ]; then
  pid=$(cat "$PID_FILE")
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null
    echo "Stopped mz-scroll-reverser (pid $pid)"
  fi
  rm -f "$PID_FILE"
fi

if [ -f "$INSTALL_DIR/sr" ]; then
  rm "$INSTALL_DIR/sr"
  echo "Removed $INSTALL_DIR/sr"
else
  echo "sr not found in $INSTALL_DIR, nothing to remove"
fi

# Clean up state directory (contains the app bundle, PID file, log)
rm -rf "$STATE_DIR"
echo "Removed $STATE_DIR"

echo "Note: the PATH line added to ~/.zshrc was left in place, remove it manually if you want"

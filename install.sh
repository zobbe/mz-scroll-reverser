#!/bin/zsh
#
# Installer for sr
# Usage: curl -fsSL https://raw.githubusercontent.com/zobbe/mz-scroll-reverser/main/install.sh | zsh

set -e

REPO_RAW="https://raw.githubusercontent.com/zobbe/mz-scroll-reverser/main"
INSTALL_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR"

# Download the controller script
curl -fsSL "$REPO_RAW/sr" -o "$INSTALL_DIR/sr"
chmod +x "$INSTALL_DIR/sr"

# Download and compile the Swift daemon into an app bundle.
# Launching via open -a is what makes mz-scroll-reverser appear as its own named entry
# in System Settings -> Privacy & Security -> Accessibility.
echo "Compiling mz-scroll-reverser (requires Xcode command-line tools)..."
SHARE_DIR="$HOME/.local/share/sr"
APP_BUNDLE="$SHARE_DIR/mz-scroll-reverser.app"
mkdir -p "$APP_BUNDLE/Contents/MacOS"

TMPSWIFT="$(mktemp /tmp/mz-scroll-reverser.XXXXXX.swift)"
curl -fsSL "$REPO_RAW/mz-scroll-reverser.swift" -o "$TMPSWIFT"
swiftc -O "$TMPSWIFT" -o "$APP_BUNDLE/Contents/MacOS/mz-scroll-reverser"
rm -f "$TMPSWIFT"

cat > "$APP_BUNDLE/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>mz-scroll-reverser</string>
    <key>CFBundleIdentifier</key>
    <string>com.zobbe.mz-scroll-reverser</string>
    <key>CFBundleName</key>
    <string>mz-scroll-reverser</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>LSBackgroundOnly</key>
    <true/>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
PLIST
echo "Compiled mz-scroll-reverser."

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

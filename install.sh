#!/usr/bin/env bash
set -euo pipefail

# CCC (Claude Code Controller) — Installer
# Maps a DualSense PS5 controller to Claude Code keybindings via evdev + ydotool.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"

echo "=== CCC Installer ==="
echo ""

# 1. Check dependencies
MISSING=()
command -v python3 >/dev/null || MISSING+=("python3")
command -v ydotool >/dev/null || MISSING+=("ydotool")
python3 -c "import evdev" 2>/dev/null || MISSING+=("python-evdev")

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "Missing dependencies: ${MISSING[*]}"
    echo "On Arch Linux:  sudo pacman -S ydotool python-evdev"
    echo "On Debian/Ubuntu: sudo apt install ydotool python3-evdev"
    echo ""
    read -rp "Continue anyway? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] || exit 1
fi

# 2. Install scripts to ~/.local/bin
echo "Installing scripts to $BIN_DIR ..."
mkdir -p "$BIN_DIR"
cp "$SCRIPT_DIR/bin/ccc-daemon"  "$BIN_DIR/"
cp "$SCRIPT_DIR/bin/ccc-enter"   "$BIN_DIR/"
cp "$SCRIPT_DIR/bin/ccc-exit"    "$BIN_DIR/"
cp "$SCRIPT_DIR/bin/ccc-watcher" "$BIN_DIR/"
chmod +x "$BIN_DIR"/ccc-{daemon,enter,exit,watcher}
echo "  Done."

# 3. Ensure user is in the input group (needed for evdev access)
if ! groups | grep -qw input; then
    echo ""
    echo "Your user is not in the 'input' group (required for controller access)."
    echo "Run:  sudo usermod -aG input $USER"
    echo "Then log out and back in."
fi

# 4. Hyprland integration hint
echo ""
echo "=== Hyprland Integration ==="
echo "Add these lines to your Hyprland config:"
echo ""
echo "  # In autostart.conf:"
echo "  exec-once = ccc-watcher"
echo ""
echo "  # In bindings.conf (see hypr/ccc-bindings.conf for the full submap):"
echo "  bind = SHIFT, KP_Down, exec, ccc-enter"
echo ""
echo "See hypr/ directory for ready-to-use config snippets."
echo ""
echo "=== Installation Complete ==="
echo "Activate CCC: press PS + R3 on your DualSense, or Shift+Numpad2 on keyboard."

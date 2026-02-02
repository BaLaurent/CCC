# CCC — Claude Code Controller

Use a **DualSense PS5 controller** to drive [Claude Code](https://docs.anthropic.com/en/docs/claude-code) from your couch.

CCC maps every DualSense button, stick, and touchpad to keyboard/mouse actions via **evdev** + **ydotool**, letting you navigate, scroll, type shortcuts, and control the cursor without touching a keyboard.

## How it works

```
DualSense → evdev (Python) → ydotool → Wayland compositor
```

A background **watcher** listens passively for the **PS + R3** combo. When detected, it launches the **daemon** which grabs the controller exclusively and translates inputs in real-time. Press **PS** (or `Shift+Numpad2`) to exit back to normal mode.

## Button mapping

| Button | Action |
|---|---|
| ✕ Cross | Enter |
| ○ Circle | Escape |
| △ Triangle | Tab |
| □ Square | Shout (STT) |
| L1 (hold) | Super / Meta |
| R1 (hold) | Shift |
| L2 (hold) | Alt |
| R2 | Ctrl+Shift+V (Paste) |
| D-pad ↑↓←→ | z / " / b / f |
| Left Stick ↕ | Scroll up/down |
| Right Stick ↕ | History up/down |
| Right Stick ↔ | Cursor left/right |
| R3 (hold) | Ctrl |
| Touchpad | Mouse movement |
| Touchpad click | Left click |
| Create | Ctrl+V (Paste) |
| Options | Screenshot |
| PS | Exit CCC mode |
| L3 + R3 | Cheat sheet |

## Requirements

- Linux with Wayland (Hyprland recommended)
- `python3` + `python-evdev`
- `ydotool` (+ `ydotoold` running)
- DualSense controller (USB or Bluetooth)
- User in the `input` group

## Installation

```bash
git clone https://github.com/BaLaurent/CCC.git
cd CCC
./install.sh
```

The installer copies scripts to `~/.local/bin` and checks dependencies.

### Hyprland integration

Add to your Hyprland config:

```conf
# Autostart the watcher
exec-once = ccc-watcher

# Keyboard toggle (optional)
bind = SHIFT, KP_Down, exec, ccc-enter
```

See the `hypr/` directory for ready-to-use config snippets.

## Usage

1. Connect your DualSense controller
2. Press **PS + R3** to enter CCC mode (notification confirms activation)
3. Use the controller to interact with Claude Code
4. Press **PS** to exit CCC mode

Press **L3 + R3** at any time for the on-screen cheat sheet.

## Architecture

```
bin/
  ccc-watcher   # Passive listener — detects PS+R3 combo to activate
  ccc-daemon    # Main input translator — grabs controller, maps to keys/mouse
  ccc-enter     # Starts daemon + switches Hyprland submap
  ccc-exit      # Kills daemon + resets Hyprland submap
hypr/
  autostart.conf      # exec-once directive for the watcher
  ccc-bindings.conf   # Hyprland submap for CCC mode
```

## License

MIT

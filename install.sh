#!/bin/bash
set -e

VERSION="0.1.0"

SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SFX_BASE="https://soundfxcenter.com/video-games"

# --- Flag parsing ---

show_help() {
  cat <<EOF
agent-sounds v$VERSION — completion sounds for Claude Code

Usage: bash install.sh [OPTIONS]

Options:
  --all        Install all themes (core + extra)
  --uninstall  Remove sounds, hooks, and shell functions
  --version    Print version and exit
  --help       Show this help message

Core themes:  peon, peasant, scv
Extra themes: raynor, wraith, duke

More info: https://github.com/kearnsw/agent-sounds
EOF
  exit 0
}

show_version() {
  echo "agent-sounds v$VERSION"
  exit 0
}

INSTALL_ALL=false
UNINSTALL=false

for arg in "$@"; do
  case "$arg" in
    --all)       INSTALL_ALL=true ;;
    --uninstall) UNINSTALL=true ;;
    --version)   show_version ;;
    --help|-h)   show_help ;;
    *)           echo "Unknown option: $arg"; echo "Run 'bash install.sh --help' for usage."; exit 1 ;;
  esac
done

# --- Uninstall ---

if [ "$UNINSTALL" = true ]; then
  echo "Uninstalling agent-sounds..."
  echo ""

  # Remove sounds directory
  if [ -d "$SOUNDS_DIR" ]; then
    rm -rf "$SOUNDS_DIR"
    echo "  Removed $SOUNDS_DIR"
  else
    echo "  $SOUNDS_DIR not found (skipped)"
  fi

  # Remove stop hook from settings.json
  if [ -f "$SETTINGS_FILE" ] && grep -qE "play-(sound|random).sh" "$SETTINGS_FILE"; then
    if command -v jq &> /dev/null; then
      tmp=$(mktemp)
      jq 'del(.hooks.Stop, .hooks.Notification)' "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
      echo "  Removed hooks from $SETTINGS_FILE"
    else
      echo "  WARNING: jq not found. Manually remove the Stop and Notification hooks from $SETTINGS_FILE"
    fi
  else
    echo "  No stop hook found in settings (skipped)"
  fi

  # Remove shell functions from rc file
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    if [ -f "$rc" ] && grep -q "claude-sound-theme" "$rc"; then
      tmp=$(mktemp)
      # Remove the comment line and all theme function lines
      grep -v "claude-sound-theme" "$rc" | grep -v "^# Claude Code sound themes" > "$tmp"
      mv "$tmp" "$rc"
      echo "  Removed theme functions from $rc"
    fi
  done

  echo ""
  echo "Done. agent-sounds has been uninstalled."
  exit 0
fi

# --- Install ---

echo "agent-sounds v$VERSION"
echo ""
echo "Installing Claude Code sound themes..."
echo ""

if [ "$INSTALL_ALL" = true ]; then
  mkdir -p "$SOUNDS_DIR/peon" "$SOUNDS_DIR/peasant" "$SOUNDS_DIR/scv" "$SOUNDS_DIR/raynor" "$SOUNDS_DIR/wraith" "$SOUNDS_DIR/duke"
else
  mkdir -p "$SOUNDS_DIR/peon" "$SOUNDS_DIR/peasant" "$SOUNDS_DIR/scv"
fi

# --- Core themes ---

echo "Core themes:"

echo "  peon (Warcraft Orc Peon)"
curl -sf --max-time 15 -o "$SOUNDS_DIR/peon/work-work.mp3" \
  "https://www.myinstants.com/media/sounds/wc3-peon-says-work-work-only-.mp3" && echo "    work-work.mp3" || echo "    FAILED: work-work.mp3"

echo "  peasant (Warcraft Human Peasant)"
curl -sf --max-time 15 -o "$SOUNDS_DIR/peasant/jobs-done.mp3" \
  "https://www.myinstants.com/media/sounds/jobs-done_1.mp3" && echo "    jobs-done.mp3" || echo "    FAILED: jobs-done.mp3"

echo "  scv (StarCraft Terran SCV)"
curl -sf --max-time 15 -o "$SOUNDS_DIR/scv/good-to-go-sir.mp3" \
  "$SFX_BASE/starcraft/8d82b5_StarCraft_SCV_Good_to_Go_Sir_Sound_Effect.mp3" && echo "    good-to-go-sir.mp3" || echo "    FAILED: good-to-go-sir.mp3"

# --- Extra themes (--all) ---

if [ "$INSTALL_ALL" = true ]; then
  echo ""
  echo "Extra themes:"

  echo "  raynor (StarCraft Jim Raynor)"
  curl -sf --max-time 15 -o "$SOUNDS_DIR/raynor/any-time-youre-ready.mp3" \
    "$SFX_BASE/starcraft/8d82b5_SC_Raynor_Any_Time_You_re_Ready_Sound_Effect.mp3" && echo "    any-time-youre-ready.mp3" || echo "    FAILED: any-time-youre-ready.mp3"
  curl -sf --max-time 15 -o "$SOUNDS_DIR/raynor/go-ahead-commander.mp3" \
    "$SFX_BASE/starcraft/8d82b5_StarCraft_Raynor_Go_Ahead_Commander_Sound_Effect.mp3" && echo "    go-ahead-commander.mp3" || echo "    FAILED: go-ahead-commander.mp3"

  echo "  wraith (StarCraft Terran Wraith)"
  curl -sf --max-time 15 -o "$SOUNDS_DIR/wraith/awaiting-launch-orders.mp3" \
    "$SFX_BASE/starcraft/8d82b5_SC_Wraith_Awaiting_Launch_Orders_Sound_Effect.mp3" && echo "    awaiting-launch-orders.mp3" || echo "    FAILED: awaiting-launch-orders.mp3"
  curl -sf --max-time 15 -o "$SOUNDS_DIR/wraith/standing-by.mp3" \
    "$SFX_BASE/starcraft/8d82b5_StarCraft_Wraith_Standing_By_Sound_Effect.mp3" && echo "    standing-by.mp3" || echo "    FAILED: standing-by.mp3"

  echo "  duke (StarCraft Edmund Duke)"
  curl -sf --max-time 15 -o "$SOUNDS_DIR/duke/should-work.mp3" \
    "$SFX_BASE/starcraft/8d82b5_StarCraft_Duke_Should_Work_Sound_Effect.mp3" && echo "    should-work.mp3" || echo "    FAILED: should-work.mp3"
  curl -sf --max-time 15 -o "$SOUNDS_DIR/duke/alright-then.mp3" \
    "$SFX_BASE/starcraft/8d82b5_StarCraft_Duke_Alright_Then_Sound_Effect.mp3" && echo "    alright-then.mp3" || echo "    FAILED: alright-then.mp3"
fi

# Install play-sound.sh
cp "$SCRIPT_DIR/play-sound.sh" "$SOUNDS_DIR/play-sound.sh"
chmod +x "$SOUNDS_DIR/play-sound.sh"

# Add stop hook to settings.json
echo ""
if [ -f "$SETTINGS_FILE" ]; then
  if grep -q "play-sound.sh" "$SETTINGS_FILE"; then
    echo "Hooks already configured."
  else
    if command -v jq &> /dev/null; then
      tmp=$(mktemp)
      jq '
        .hooks.Stop = [{"hooks": [{"type": "command", "command": "bash ~/.claude/sounds/play-sound.sh"}]}]
        | .hooks.Notification = [{"matcher": "permission_prompt", "hooks": [{"type": "command", "command": "bash ~/.claude/sounds/play-sound.sh"}]}]
      ' "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
      echo "Added hooks to settings.json."
    else
      echo "WARNING: jq not found. Manually add this to $SETTINGS_FILE:"
      echo '  "hooks": { "Stop": [...], "Notification": [{"matcher": "permission_prompt", "hooks": [...]}] }'
    fi
  fi
else
  mkdir -p "$HOME/.claude"
  cat > "$SETTINGS_FILE" << 'EOF'
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/sounds/play-sound.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "permission_prompt",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/sounds/play-sound.sh"
          }
        ]
      }
    ]
  }
}
EOF
  echo "Created settings.json with hooks."
fi

# Detect shell and add functions
SHELL_RC=""
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ "$SHELL" = "/bin/bash" ]; then
  SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ] && [ -f "$SHELL_RC" ]; then
  if grep -q "claude-sound-theme" "$SHELL_RC"; then
    echo "Shell functions already in $SHELL_RC."
  else
    if [ "$INSTALL_ALL" = true ]; then
      cat >> "$SHELL_RC" << 'EOF'

# Claude Code sound themes (plays themed sounds on stop)
function peon { echo "peon" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=peon claude --dangerously-skip-permissions "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function peasant { echo "peasant" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=peasant claude --dangerously-skip-permissions "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function scv { echo "scv" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=scv claude --dangerously-skip-permissions "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function raynor { echo "raynor" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=raynor claude --dangerously-skip-permissions "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function wraith { echo "wraith" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=wraith claude --dangerously-skip-permissions "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function duke { echo "duke" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=duke claude --dangerously-skip-permissions "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
EOF
    else
      cat >> "$SHELL_RC" << 'EOF'

# Claude Code sound themes (plays themed sounds on stop)
function peon { echo "peon" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=peon claude --dangerously-skip-permissions "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function peasant { echo "peasant" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=peasant claude --dangerously-skip-permissions "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function scv { echo "scv" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=scv claude --dangerously-skip-permissions "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
EOF
    fi
    echo "Added theme functions to $SHELL_RC."
  fi
fi

echo ""
echo "Installed themes:"
for dir in "$SOUNDS_DIR"/*/; do
  [ -d "$dir" ] || continue
  theme=$(basename "$dir")
  count=$(ls "$dir"*.mp3 2>/dev/null | wc -l | tr -d ' ')
  echo "  $theme ($count sounds)"
done
echo ""
if [ "$INSTALL_ALL" = true ]; then
  echo "Usage: open a new terminal and run one of: peon, peasant, scv, raynor, wraith, duke"
else
  echo "Usage: open a new terminal and run 'peon', 'peasant', or 'scv' instead of 'claude'"
  echo "       Re-run with --all for extra themes: raynor, wraith, duke"
fi

#!/bin/bash
set -e

SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SFX_BASE="https://soundfxcenter.com/video-games"

# Parse arguments
INSTALL_ALL=false
for arg in "$@"; do
  case "$arg" in
    --all) INSTALL_ALL=true ;;
  esac
done

echo "Installing Claude Code sound themes..."
echo ""

if [ "$INSTALL_ALL" = true ]; then
  mkdir -p "$SOUNDS_DIR/peon" "$SOUNDS_DIR/scv" "$SOUNDS_DIR/raynor" "$SOUNDS_DIR/wraith" "$SOUNDS_DIR/duke"
else
  mkdir -p "$SOUNDS_DIR/peon" "$SOUNDS_DIR/scv"
fi

# --- Core themes ---

# Download peon sounds (Warcraft Orc worker - completion sounds)
echo "Downloading peon theme (Warcraft Orc worker)..."
curl -sf --max-time 15 -o "$SOUNDS_DIR/peon/work-complete.mp3" \
  "$SFX_BASE/warcraft-2/8d82b5_Warcraft_2_Peon_Work_Complete_Sound_Effect.mp3" && echo "  work-complete.mp3" || echo "  FAILED: work-complete.mp3"

# Download SCV sounds (StarCraft Terran worker - completion sounds)
echo "Downloading scv theme (StarCraft Terran SCV)..."
curl -sf --max-time 15 -o "$SOUNDS_DIR/scv/good-to-go-sir.mp3" \
  "$SFX_BASE/starcraft/8d82b5_StarCraft_SCV_Good_to_Go_Sir_Sound_Effect.mp3" && echo "  good-to-go-sir.mp3" || echo "  FAILED: good-to-go-sir.mp3"

# --- Extra themes (--all) ---

if [ "$INSTALL_ALL" = true ]; then
  echo ""
  echo "Installing extra themes..."

  # Download Raynor sounds (StarCraft Jim Raynor)
  echo "Downloading raynor theme (StarCraft Jim Raynor)..."
  curl -sf --max-time 15 -o "$SOUNDS_DIR/raynor/any-time-youre-ready.mp3" \
    "$SFX_BASE/starcraft/8d82b5_SC_Raynor_Any_Time_You_re_Ready_Sound_Effect.mp3" && echo "  any-time-youre-ready.mp3" || echo "  FAILED: any-time-youre-ready.mp3"
  curl -sf --max-time 15 -o "$SOUNDS_DIR/raynor/go-ahead-commander.mp3" \
    "$SFX_BASE/starcraft/8d82b5_StarCraft_Raynor_Go_Ahead_Commander_Sound_Effect.mp3" && echo "  go-ahead-commander.mp3" || echo "  FAILED: go-ahead-commander.mp3"

  # Download Wraith sounds (StarCraft Terran Wraith)
  echo "Downloading wraith theme (StarCraft Terran Wraith)..."
  curl -sf --max-time 15 -o "$SOUNDS_DIR/wraith/awaiting-launch-orders.mp3" \
    "$SFX_BASE/starcraft/8d82b5_SC_Wraith_Awaiting_Launch_Orders_Sound_Effect.mp3" && echo "  awaiting-launch-orders.mp3" || echo "  FAILED: awaiting-launch-orders.mp3"
  curl -sf --max-time 15 -o "$SOUNDS_DIR/wraith/standing-by.mp3" \
    "$SFX_BASE/starcraft/8d82b5_StarCraft_Wraith_Standing_By_Sound_Effect.mp3" && echo "  standing-by.mp3" || echo "  FAILED: standing-by.mp3"

  # Download Duke sounds (StarCraft Edmund Duke)
  echo "Downloading duke theme (StarCraft Edmund Duke)..."
  curl -sf --max-time 15 -o "$SOUNDS_DIR/duke/should-work.mp3" \
    "$SFX_BASE/starcraft/8d82b5_StarCraft_Duke_Should_Work_Sound_Effect.mp3" && echo "  should-work.mp3" || echo "  FAILED: should-work.mp3"
  curl -sf --max-time 15 -o "$SOUNDS_DIR/duke/alright-then.mp3" \
    "$SFX_BASE/starcraft/8d82b5_StarCraft_Duke_Alright_Then_Sound_Effect.mp3" && echo "  alright-then.mp3" || echo "  FAILED: alright-then.mp3"
fi

# Install play-random.sh
cp "$SCRIPT_DIR/play-random.sh" "$SOUNDS_DIR/play-random.sh"
chmod +x "$SOUNDS_DIR/play-random.sh"
echo "Installed play-random.sh"

# Add stop hook to settings.json
if [ -f "$SETTINGS_FILE" ]; then
  if grep -q "play-random.sh" "$SETTINGS_FILE"; then
    echo "Stop hook already configured in settings.json"
  else
    if command -v jq &> /dev/null; then
      tmp=$(mktemp)
      jq '.hooks.Stop = [{"hooks": [{"type": "command", "command": "bash ~/.claude/sounds/play-random.sh"}]}]' "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
      echo "Added stop hook to settings.json"
    else
      echo ""
      echo "WARNING: jq not found. Manually add this to $SETTINGS_FILE:"
      echo '  "hooks": { "Stop": [{ "hooks": [{ "type": "command", "command": "bash ~/.claude/sounds/play-random.sh" }] }] }'
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
            "command": "bash ~/.claude/sounds/play-random.sh"
          }
        ]
      }
    ]
  }
}
EOF
  echo "Created settings.json with stop hook"
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
    echo "Shell functions already in $SHELL_RC"
  else
    if [ "$INSTALL_ALL" = true ]; then
      cat >> "$SHELL_RC" << 'EOF'

# Claude Code sound themes (plays themed sounds on stop)
function peon { echo "peon" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=peon claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function scv { echo "scv" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=scv claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function raynor { echo "raynor" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=raynor claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function wraith { echo "wraith" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=wraith claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function duke { echo "duke" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=duke claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
EOF
    else
      cat >> "$SHELL_RC" << 'EOF'

# Claude Code sound themes (plays themed sounds on stop)
function peon { echo "peon" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=peon claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function scv { echo "scv" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=scv claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
EOF
    fi
    echo "Added theme functions to $SHELL_RC"
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
echo "TIP: Add more .mp3 files to ~/.claude/sounds/<theme>/ for variety."
echo "     Ask your AI agent to find and download more completion sounds!"
echo ""
if [ "$INSTALL_ALL" = true ]; then
  echo "Usage: Open a new terminal and run one of: peon, scv, raynor, wraith, duke"
else
  echo "Usage: Open a new terminal and run 'peon' or 'scv' instead of 'claude'"
  echo "       Re-run with --all for extra themes: raynor, wraith, duke"
fi

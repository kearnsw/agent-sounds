#!/bin/bash
set -e

SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SFX_BASE="https://soundfxcenter.com/video-games"

echo "Installing Claude Code sound themes..."
echo ""

# Create directories
mkdir -p "$SOUNDS_DIR/peon" "$SOUNDS_DIR/scv" "$SOUNDS_DIR/marine" "$SOUNDS_DIR/raynor" "$SOUNDS_DIR/wraith"

# Download peon sounds (Warcraft Orc worker - completion sounds)
echo "Downloading peon theme (Warcraft Orc worker)..."
curl -sf --max-time 15 -o "$SOUNDS_DIR/peon/work-complete.mp3" \
  "$SFX_BASE/warcraft-2/8d82b5_Warcraft_2_Peon_Work_Complete_Sound_Effect.mp3" && echo "  work-complete.mp3" || echo "  FAILED: work-complete.mp3"

# Download SCV sounds (StarCraft Terran worker - completion sounds)
echo "Downloading scv theme (StarCraft Terran SCV)..."
curl -sf --max-time 15 -o "$SOUNDS_DIR/scv/good-to-go-sir.mp3" \
  "$SFX_BASE/starcraft/8d82b5_StarCraft_SCV_Good_to_Go_Sir_Sound_Effect.mp3" && echo "  good-to-go-sir.mp3" || echo "  FAILED: good-to-go-sir.mp3"

# Download Marine sounds (StarCraft Terran Marine - completion sounds)
echo "Downloading marine theme (StarCraft Terran Marine)..."
curl -sf --max-time 15 -o "$SOUNDS_DIR/marine/jacked-up-and-good-to-go.mp3" \
  "$SFX_BASE/starcraft/8d82b5_SC_Marine_Jacked_Up_And_Good_To_Go_Sound_Effect.mp3" && echo "  jacked-up-and-good-to-go.mp3" || echo "  FAILED: jacked-up-and-good-to-go.mp3"
curl -sf --max-time 15 -o "$SOUNDS_DIR/marine/outstanding.mp3" \
  "$SFX_BASE/starcraft/8d82b5_StarCraft_Marine_Outstanding_Sound_Effect.mp3" && echo "  outstanding.mp3" || echo "  FAILED: outstanding.mp3"
curl -sf --max-time 15 -o "$SOUNDS_DIR/marine/ah-thats-the-stuff.mp3" \
  "$SFX_BASE/starcraft/8d82b5_StarCraft_Marine_Ah_Thats_The_Stuff_Sound_Effect.mp3" && echo "  ah-thats-the-stuff.mp3" || echo "  FAILED: ah-thats-the-stuff.mp3"

# Download Raynor sounds (StarCraft Jim Raynor - completion sounds)
echo "Downloading raynor theme (StarCraft Jim Raynor)..."
curl -sf --max-time 15 -o "$SOUNDS_DIR/raynor/any-time-youre-ready.mp3" \
  "$SFX_BASE/starcraft/8d82b5_SC_Raynor_Any_Time_You_re_Ready_Sound_Effect.mp3" && echo "  any-time-youre-ready.mp3" || echo "  FAILED: any-time-youre-ready.mp3"
curl -sf --max-time 15 -o "$SOUNDS_DIR/raynor/go-ahead-commander.mp3" \
  "$SFX_BASE/starcraft/8d82b5_StarCraft_Raynor_Go_Ahead_Commander_Sound_Effect.mp3" && echo "  go-ahead-commander.mp3" || echo "  FAILED: go-ahead-commander.mp3"

# Download Wraith sounds (StarCraft Terran Wraith - completion sounds)
echo "Downloading wraith theme (StarCraft Terran Wraith)..."
curl -sf --max-time 15 -o "$SOUNDS_DIR/wraith/awaiting-launch-orders.mp3" \
  "$SFX_BASE/starcraft/8d82b5_SC_Wraith_Awaiting_Launch_Orders_Sound_Effect.mp3" && echo "  awaiting-launch-orders.mp3" || echo "  FAILED: awaiting-launch-orders.mp3"
curl -sf --max-time 15 -o "$SOUNDS_DIR/wraith/standing-by.mp3" \
  "$SFX_BASE/starcraft/8d82b5_StarCraft_Wraith_Standing_By_Sound_Effect.mp3" && echo "  standing-by.mp3" || echo "  FAILED: standing-by.mp3"

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
    cat >> "$SHELL_RC" << 'EOF'

# Claude Code sound themes (plays themed sounds on stop)
function peon { echo "peon" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=peon claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function scv { echo "scv" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=scv claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function marine { echo "marine" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=marine claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function raynor { echo "raynor" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=raynor claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
function wraith { echo "wraith" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=wraith claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
EOF
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
echo "Usage: Open a new terminal and run one of: peon, scv, marine, raynor, wraith"

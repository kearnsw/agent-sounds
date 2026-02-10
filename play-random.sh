#!/bin/bash
# Play a random completion sound when Claude finishes

# Prevent infinite loops - if stop hook is already active, bail out
INPUT=$(cat)
ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [ "$ACTIVE" = "true" ]; then
  exit 0
fi

# Read theme from session file, fall back to env var, then default to peon
if [ -f "/tmp/claude-sound-theme-$PPID" ]; then
  THEME=$(cat "/tmp/claude-sound-theme-$PPID")
elif [ -n "$CLAUDE_SOUND_THEME" ]; then
  THEME="$CLAUDE_SOUND_THEME"
else
  THEME="peon"
fi

SOUNDS_DIR="$HOME/.claude/sounds/$THEME"

# Fall back to peon if theme dir doesn't exist
if [ ! -d "$SOUNDS_DIR" ]; then
  SOUNDS_DIR="$HOME/.claude/sounds/peon"
fi

SOUNDS=("$SOUNDS_DIR"/*.mp3)

# Exit if no sounds found
if [ ${#SOUNDS[@]} -eq 0 ]; then
  exit 0
fi

# Pick a random sound
RANDOM_INDEX=$((RANDOM % ${#SOUNDS[@]}))
SELECTED="${SOUNDS[$RANDOM_INDEX]}"

# Play it in the background so it doesn't block
afplay "$SELECTED" &
exit 0

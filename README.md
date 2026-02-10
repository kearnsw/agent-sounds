# Agent Sound Stop Hooks

Themed completion sounds for [Claude Code](https://claude.ai/code). Plays a random sound when your agent finishes a response. Use different themes per terminal so you can tell them apart by ear.

## Themes

### Core

| Command | Theme | Sounds |
|---------|-------|--------|
| `peon` | Warcraft Orc worker | "work complete" |
| `scv` | StarCraft Terran SCV | "good to go sir" |

### Extra (`--all`)

| Command | Theme | Sounds |
|---------|-------|--------|
| `marine` | StarCraft Terran Marine | "jacked up and good to go", "outstanding", "ah that's the stuff" |
| `raynor` | StarCraft Jim Raynor | "any time you're ready", "go ahead commander" |
| `wraith` | StarCraft Terran Wraith | "awaiting launch orders", "standing by" |
| `duke` | StarCraft Edmund Duke | "should work", "alright then", "decisive action" |

## Install

```bash
git clone https://github.com/kearnsw/agent-sound-stop-hooks.git
cd agent-sound-stop-hooks
bash install.sh        # core themes (peon, scv)
bash install.sh --all  # all themes
```

This will:
- Download sound files to `~/.claude/sounds/`
- Add a Stop hook to `~/.claude/settings.json`
- Add shell functions to your `.zshrc` or `.bashrc`

## Usage

Instead of running `claude`, use a themed command:

```bash
peon      # Warcraft orc completion sounds
scv       # StarCraft SCV completion sounds
marine    # StarCraft Marine completion sounds
raynor    # StarCraft Raynor completion sounds
wraith    # StarCraft Wraith completion sounds
duke      # StarCraft Duke completion sounds
```

Open multiple terminals with different themes to tell them apart.

## Add More Sounds

Drop more `.mp3` files into any theme folder for variety:

```bash
~/.claude/sounds/peon/      # Warcraft orc sounds
~/.claude/sounds/scv/       # StarCraft SCV sounds
~/.claude/sounds/marine/    # StarCraft Marine sounds
~/.claude/sounds/raynor/    # StarCraft Raynor sounds
~/.claude/sounds/wraith/    # StarCraft Wraith sounds
~/.claude/sounds/duke/      # StarCraft Duke sounds
```

You can ask your AI agent to help find and download more sounds:

> "Download more StarCraft Marine completion sound effects as mp3 files into ~/.claude/sounds/marine/"

## Create Your Own Theme

1. Create a folder: `mkdir ~/.claude/sounds/mytheme`
2. Add `.mp3` files to it
3. Add a shell function to your rc file:
   ```bash
   function mytheme { echo "mytheme" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=mytheme claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
   ```

## Requirements

- macOS (uses `afplay` for audio playback)
- `jq` (for install script to patch settings.json)
- [Claude Code](https://claude.ai/code)

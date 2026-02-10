# Agent Sound Stop Hooks

Themed completion sounds for [Claude Code](https://claude.ai/code). Plays a random sound when your agent finishes a response. Use different themes per terminal so you can tell them apart by ear.

## Themes

| Command | Theme | Sounds |
|---------|-------|--------|
| `peon` | Warcraft Orc worker | "work complete" |
| `scv` | StarCraft Terran SCV | "good to go sir" |
| `marine` | StarCraft Terran Marine | "jacked up and good to go", "outstanding", "ah that's the stuff" |
| `raynor` | StarCraft Jim Raynor | "any time you're ready", "go ahead commander" |
| `wraith` | StarCraft Terran Wraith | "awaiting launch orders", "standing by" |

## Install

```bash
git clone https://github.com/kearnsw/agent-sound-stop-hooks.git
cd agent-sound-stop-hooks
bash install.sh
```

This will:
- Download sound files to `~/.claude/sounds/`
- Add a Stop hook to `~/.claude/settings.json`
- Add `peon`, `scv`, `marine`, `raynor`, and `wraith` shell functions to your `.zshrc` or `.bashrc`

## Usage

Instead of running `claude`, use a themed command:

```bash
peon      # Warcraft orc completion sounds
scv       # StarCraft SCV completion sounds
marine    # StarCraft Marine completion sounds
raynor    # StarCraft Raynor completion sounds
wraith    # StarCraft Wraith completion sounds
```

Open multiple terminals with different themes to tell them apart.

## Add More Sounds

The install downloads starter sounds per theme. To add variety, drop more `.mp3` files into the theme folder:

```bash
~/.claude/sounds/peon/      # Add Warcraft orc completion sounds here
~/.claude/sounds/scv/       # Add StarCraft SCV completion sounds here
~/.claude/sounds/marine/    # Add StarCraft Marine completion sounds here
~/.claude/sounds/raynor/    # Add StarCraft Raynor completion sounds here
~/.claude/sounds/wraith/    # Add StarCraft Wraith completion sounds here
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

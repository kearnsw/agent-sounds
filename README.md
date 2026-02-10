# Agent Sounds

Completion sounds for [Claude Code](https://claude.ai/code). Each theme plays a random sound when your agent finishes — run different themes per terminal to tell them apart by ear.

## Quick Start

```bash
# Homebrew
brew install kearnsw/tap/agent-sounds

# or clone and install
git clone https://github.com/kearnsw/agent-sounds.git
cd agent-sounds
bash install.sh          # core themes only
bash install.sh --all    # all themes
```

## Themes

| Command | Theme | Sounds | Category |
|---------|-------|--------|----------|
| `peon` | Warcraft Orc Peon | "work work" | Core |
| `peasant` | Warcraft Human Peasant | "jobs done" | Core |
| `scv` | StarCraft Terran SCV | "good to go sir" | Core |
| `raynor` | StarCraft Jim Raynor | "any time you're ready", "go ahead commander" | Extra |
| `wraith` | StarCraft Terran Wraith | "awaiting launch orders", "standing by" | Extra |
| `duke` | StarCraft Edmund Duke | "should work", "alright then" | Extra |

Extra themes are installed with `--all`.

## Usage

Use a themed command instead of `claude`:

```bash
peon       # Warcraft Peon — "work work"
peasant    # Warcraft Peasant — "jobs done"
scv        # StarCraft SCV — "good to go sir"
raynor     # StarCraft Raynor completion sounds
wraith     # StarCraft Wraith completion sounds
duke       # StarCraft Duke completion sounds
```

Run multiple terminals with different themes to tell your agents apart:

```
Terminal 1 $ peon       # grunted "work work"
Terminal 2 $ peasant    # cheerful "jobs done"
Terminal 3 $ scv        # brisk "good to go sir"
```

## How It Works

1. `install.sh` registers a Claude Code [stop hook](https://docs.anthropic.com/en/docs/claude-code/hooks) in `~/.claude/settings.json`
2. When Claude finishes a response, the hook runs `play-random.sh`
3. `play-random.sh` reads the active theme, picks a random `.mp3`, and plays it with `afplay`

Theme is resolved from: session temp file > `CLAUDE_SOUND_THEME` env var > default (`peon`).

## Customization

### Add sounds to an existing theme

Drop `.mp3` files into any theme folder:

```bash
ls ~/.claude/sounds/peon/    # see existing sounds
cp my-sound.mp3 ~/.claude/sounds/peon/
```

### Create your own theme

1. Create a folder: `mkdir ~/.claude/sounds/mytheme`
2. Add `.mp3` files to it
3. Add a shell function to your rc file:
   ```bash
   function mytheme { echo "mytheme" > "/tmp/claude-sound-theme-$$" && CLAUDE_SOUND_THEME=mytheme claude "$@"; rm -f "/tmp/claude-sound-theme-$$"; }
   ```

## Uninstall

```bash
bash install.sh --uninstall
```

Or manually:

```bash
rm -rf ~/.claude/sounds/
# Remove the Stop hook from ~/.claude/settings.json
# Remove theme functions from ~/.zshrc or ~/.bashrc
```

## Requirements

- macOS (uses `afplay` for audio playback)
- `jq` (for patching `settings.json` during install)
- [Claude Code](https://claude.ai/code)

## License

[MIT](LICENSE)

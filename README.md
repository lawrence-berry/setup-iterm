# setup-iterm

iTerm's Quake-style window hotkey, the Karabiner shortcut that triggers it, and iTerm shell integration.

## Install

```sh
./install.sh
```

Then quit and reopen iTerm (⌘Q). Re-runnable.

- **Quake window**: turns on iTerm's "Show/hide all windows with a system-wide hotkey" (Settings → Keys → Hotkey) and sets it to ⌥\\. Your Default profile's window Style is "Top of Screen", so the window you have open drops down from the top. That Style isn't set by this repo: on a new Mac, set it once in Settings → Profiles → Window.
- **`karabiner.json`**: double-tap left ⌘ sends ⌥\\. Karabiner is only used for this one rule, so `install.sh` copies the whole file over `~/.config/karabiner/karabiner.json` (keeping the old one as `karabiner.json.bak`). Karabiner picks it up straight away.
- **Shell integration**: downloads iTerm's script if it's missing and adds one `# setup-iterm` line to `~/.zshrc` (or `~/.bashrc`) that sources it.

## Changing things

**The two halves share one key, ⌥\\.** If you change it, change it in both places: `to` in `karabiner.json` and the `Hotkey…` values in `install.sh`.

Karabiner itself is installed by setup-mac's Brewfile.

# setup-iterm

iTerm's Quake-style hotkey window, the Karabiner shortcut that opens it, and iTerm shell integration.

## Install

```sh
./install.sh
```

Then quit and reopen iTerm (⌘Q). Re-runnable.

- **`hotkey-window.json`**: a [Dynamic Profile](https://iterm2.com/documentation-dynamic-profiles.html) named "Hotkey Window". It drops down from the top of the screen on ⌥\\, floats over other apps and hides when it loses focus. It inherits everything else (font, colours) from your Default profile. `install.sh` copies it into `~/Library/Application Support/iTerm2/DynamicProfiles/`, and turns off iTerm's older "show/hide all windows" hotkey, which also used ⌥\\.
- **`karabiner.json`**: double-tap left ⌘ sends ⌥\\. Karabiner is only used for this one rule, so `install.sh` copies the whole file over `~/.config/karabiner/karabiner.json` (keeping the old one as `karabiner.json.bak`). Karabiner picks it up straight away.
- **Shell integration**: downloads iTerm's script if it's missing and adds one `# setup-iterm` line to `~/.zshrc` (or `~/.bashrc`) that sources it.

## Changing things

**The two halves share one key, ⌥\\.** If you change it, change it in both files: `to` in `karabiner.json` and the `HotKey …` values in `hotkey-window.json`.

Edits made in iTerm's Settings window to a Dynamic Profile aren't saved back to the JSON. Edit `hotkey-window.json` and re-run `install.sh` instead. The setting names come from iTerm's source: `sources/Settings/Profiles/ITAddressBookMgr.h`.

Karabiner itself is installed by setup-mac's Brewfile.

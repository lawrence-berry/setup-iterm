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
- **Badge** (`badge.sh`): the badge shows the current folder's name with an emoji picked from the name. Inside a Rails app with a `public/icon.png`, that icon is also set as the session's background image instead. It uses iTerm's session escape codes, so the Default profile isn't touched; set Settings → Profiles → Window → Background Image blend to taste. iTerm asks once to allow the background image change.
- **Snippets** (`snippets.plist`): one snippet, `bootstrapit`, which types the [setup](https://lawrence-berry.github.io/setup) one-liner into the current session, so it works when you SSH into a blank server. Use it from Edit → Snippets (hold ⌥ to edit before sending). macOS text replacements don't expand in a terminal, so this is the terminal-side equivalent. Like `karabiner.json`, the repo owns the whole file: `install.sh` copies it over iTerm's (keeping `snippets.plist.bak`) only when iTerm is closed, because iTerm rewrites it while running. Add snippets by editing `snippets.plist` here, or copy iTerm's file back after adding one in Settings.

## Changing things

**The two halves share one key, ⌥\\.** If you change it, change it in both places: `to` in `karabiner.json` and the `Hotkey…` values in `install.sh`.

Karabiner itself is installed by setup-mac's Brewfile.

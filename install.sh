#!/bin/sh
# Sets up iTerm's Quake-style window hotkey, the Karabiner rule that opens it
# (double-tap left ⌘ sends ⌥\), and iTerm shell integration. Safe to re-run.
set -e
dir="$(cd "$(dirname "$0")" && pwd)"

# Quake window: iTerm's "show/hide all windows" hotkey, set to ⌥\ (key code 42).
# Your Default profile's Style is "Top of Screen", so its window drops down from the top.
defaults write com.googlecode.iterm2 Hotkey -bool true
defaults write com.googlecode.iterm2 HotkeyCode -int 42
defaults write com.googlecode.iterm2 HotkeyChar -int 92
defaults write com.googlecode.iterm2 HotkeyModifiers -int 524576

# Karabiner is only used for this one rule, so this repo owns the whole file.
# Copied, not symlinked: Karabiner replaces the file when it saves.
k="$HOME/.config/karabiner/karabiner.json"
if ! cmp -s "$dir/karabiner.json" "$k"; then
  mkdir -p "$(dirname "$k")"
  [ -f "$k" ] && cp "$k" "$k.bak"
  cp "$dir/karabiner.json" "$k"
fi

# Shell integration: fetch iTerm's script if missing, and source it from the rc file.
case "$SHELL" in *zsh) sh=zsh rc="$HOME/.zshrc" ;; *) sh=bash rc="$HOME/.bashrc" ;; esac
script="$HOME/.iterm2_shell_integration.$sh"
[ -f "$script" ] || curl -fsSL "https://iterm2.com/shell_integration/$sh" -o "$script"
# Drop any older integration line (including iTerm's own, unmarked one), then add ours.
if [ -f "$rc" ]; then
  grep -v 'iterm2_shell_integration' "$rc" > "$rc.tmp" || true
  cat "$rc.tmp" > "$rc" && rm "$rc.tmp"
fi
[ -n "$(tail -c1 "$rc" 2>/dev/null)" ] && echo >> "$rc"  # add a missing final newline
printf '%s\n' "[ -f \"$script\" ] && . \"$script\"  # setup-iterm" >> "$rc"

echo "done. Quit and reopen iTerm (⌘Q) to pick up the hotkey."

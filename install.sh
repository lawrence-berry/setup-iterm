#!/bin/sh
# Sets up iTerm's Quake-style window hotkey, the Karabiner rule that opens it
# (double-tap left ⌘ sends ⌥\), iTerm shell integration, the folder-name badge and the snippets. Safe to re-run.
set -e
dir="$(cd "$(dirname "$0")" && pwd)"

# Quake window: iTerm's "show/hide all windows" hotkey, set to ⌥\ (key code 42).
# Your Default profile's Style is "Top of Screen", so its window drops down from the top.
defaults write com.googlecode.iterm2 Hotkey -bool true
defaults write com.googlecode.iterm2 HotkeyCode -int 42
defaults write com.googlecode.iterm2 HotkeyChar -int 92
defaults write com.googlecode.iterm2 HotkeyModifiers -int 524576

# Badge icon: point the Default profile's background image at the `icon` variable that
# badge.sh sets, aspect-fit and faint. PlistBuddy edits are lost if iTerm is running.
plist="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
pb=/usr/libexec/PlistBuddy
if pgrep -x iTerm2 >/dev/null; then
  echo "iTerm is running: quit it (⌘Q) and re-run to set the profile's background image."
else
  p=":'New Bookmarks':0"
  $pb -c "Set $p:'Background Image Location' '\\\\(user.icon)'" "$plist" 2>/dev/null || $pb -c "Add $p:'Background Image Location' string '\\\\(user.icon)'" "$plist"
  $pb -c "Set $p:'Background Image Mode' 3" "$plist" 2>/dev/null || $pb -c "Add $p:'Background Image Mode' integer 3" "$plist"
  $pb -c "Set $p:Blend 0.15" "$plist" 2>/dev/null || $pb -c "Add $p:Blend real 0.15" "$plist"
fi

# Karabiner is only used for this one rule, so this repo owns the whole file.
# Copied, not symlinked: Karabiner replaces the file when it saves.
k="$HOME/.config/karabiner/karabiner.json"
if ! cmp -s "$dir/karabiner.json" "$k"; then
  mkdir -p "$(dirname "$k")"
  [ -f "$k" ] && cp "$k" "$k.bak"
  cp "$dir/karabiner.json" "$k"
fi

# Snippets: this repo owns iTerm's whole snippets.plist (the `bootstrapit` one-liner).
# iTerm rewrites the file while it runs, so only copy when it's closed.
sn="$HOME/Library/Application Support/iTerm2/snippets.plist"
if ! cmp -s "$dir/snippets.plist" "$sn"; then
  if pgrep -x iTerm2 >/dev/null; then
    echo "iTerm is running: quit it (⌘Q) and re-run to install the snippets."
  else
    mkdir -p "$(dirname "$sn")"
    [ -f "$sn" ] && cp "$sn" "$sn.bak"
    cp "$dir/snippets.plist" "$sn"
  fi
fi

# Shell integration: fetch iTerm's script if missing, and source it from the rc file.
case "$SHELL" in *zsh) sh=zsh rc="$HOME/.zshrc" ;; *) sh=bash rc="$HOME/.bashrc" ;; esac
script="$HOME/.iterm2_shell_integration.$sh"
[ -f "$script" ] || curl -fsSL "https://iterm2.com/shell_integration/$sh" -o "$script"
# Drop any older integration line (including iTerm's own, unmarked one), then add ours.
if [ -f "$rc" ]; then
  grep -v -e 'iterm2_shell_integration' -e '# setup-iterm-badge' "$rc" > "$rc.tmp" || true
  cat "$rc.tmp" > "$rc" && rm "$rc.tmp"
fi
[ -n "$(tail -c1 "$rc" 2>/dev/null)" ] && echo >> "$rc"  # add a missing final newline
printf '%s\n' "[ -f \"$script\" ] && . \"$script\"  # setup-iterm" >> "$rc"
# Badge: folder name + emoji, and a Rails app's public/icon.png as the background.
printf '%s\n' ". \"$dir/badge.sh\"  # setup-iterm-badge" >> "$rc"

echo "done. Quit and reopen iTerm (⌘Q) to pick up the hotkey."

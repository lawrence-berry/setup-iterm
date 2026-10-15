# iTerm badge: current folder's name, with an emoji. In a Rails app that has
# public/icon.png, that icon is also shown as the session's background image (via the
# user variable `icon`, which install.sh points the profile's background image at).
# Sourced from your rc file by install.sh. Needs iTerm's escape codes (a no-op elsewhere).
[ "$TERM_PROGRAM" = iTerm.app ] || return 0

_setup_iterm_badge() {
  [ "$PWD" = "$_setup_iterm_last" ] && return
  _setup_iterm_last="$PWD"
  local name="${PWD##*/}" icon="" dir="$PWD"
  [ -n "$name" ] || name=/
  while [ -n "$dir" ]; do
    [ -f "$dir/config/application.rb" ] && [ -f "$dir/public/icon.png" ] && { icon="$dir/public/icon.png"; break; }
    dir="${dir%/*}"
  done
  # Emoji picked from the folder name, so each folder keeps the same one.
  local emojis=(🦊 🐙 🦉 🐢 🦋 🐝 🦄 🐳 🦀 🐧 🦖 🐬) sum
  sum=$(printf %s "$name" | cksum | cut -d' ' -f1)
  local _o=0; [ -n "$ZSH_VERSION" ] && _o=1
  local e="${emojis[$((sum % 12 + ${_o}))]}"
  [ -n "$icon" ] && e=""
  printf '\e]1337;SetBadgeFormat=%s\a' "$(printf '%s %s' "$e" "$name" | base64 | tr -d '\n')"
  # The Default profile's background image is "\(user.icon)", so this variable drives it.
  printf '\e]1337;SetUserVar=icon=%s\a' "$(printf %s "$icon" | base64 | tr -d '\n')"
}

if [ -n "$ZSH_VERSION" ]; then precmd_functions+=(_setup_iterm_badge)
else PROMPT_COMMAND="_setup_iterm_badge${PROMPT_COMMAND:+;$PROMPT_COMMAND}"; fi

#!/usr/bin/env bash
# Multi-monitor launcher for larpaper (Hyprland).
#
# Upstream launch-larpaper starts a single fullscreen Kitty window, which lands
# on whichever monitor happens to be focused, and then actively refuses to start
# a second one....

set -uo pipefail

case "${1:-}" in
  ""|--showoff) ;;
  *) printf 'Usage: %s [--showoff]\n' "${0##*/}" >&2; exit 2 ;;
esac

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
larpaper="$script_dir/larpaper.sh"
[[ -x "$larpaper" ]] || larpaper="$script_dir/larpaper"

repo_config="$script_dir/larpaper.conf"
installed_config="${XDG_CONFIG_HOME:-$HOME/.config}/larpaper/larpaper.conf"
[[ -r "$repo_config" ]] && config_file="$repo_config" || config_file="$installed_config"

if [[ ! -r "$config_file" ]]; then
  printf 'Larpaper config is missing: %s\n' "$config_file" >&2
  exit 1
fi

source "$config_file"

if ! command -v hyprctl >/dev/null 2>&1; then
  printf 'larpaper-all needs hyprctl on PATH (Hyprland session).\n' >&2
  exit 1
fi

lock_file="${XDG_RUNTIME_DIR:-/tmp}/larpaper-all.lock"
exec 9>"$lock_file"
flock -n 9 || exit 0

mapfile -t monitors < <(hyprctl monitors | awk '/^Monitor /{ print $2 }')
if (( ${#monitors[@]} == 0 )); then
  printf 'hyprctl reported no monitors.\n' >&2
  exit 1
fi

pids=()
for monitor in "${monitors[@]}"; do
  class="larpaper-$monitor"

  hyprctl eval \
    "hl.window_rule({ monitor = \"$monitor\", match = { class = \"^($class)\$\" } })" \
    >/dev/null 2>&1

  kitty \
    --class "$class" \
    --title 'Larpaper' \
    --start-as fullscreen \
    --override font_size="$FONT_SIZE" \
    --override window_padding_width=0 \
    --override background="$BACKGROUND" \
    --override background_opacity="$BACKGROUND_OPACITY" \
    --override dynamic_background_opacity=no \
    --override hide_window_decorations=yes \
    --override tab_bar_style=hidden \
    --override confirm_os_window_close=0 \
    --override mouse_hide_wait="$MOUSE_HIDE_WAIT" \
    --override cursor_shape="$CURSOR_SHAPE" \
    "$larpaper" "${1:-}" &
  pids+=("$!")
done

# Each renderer runs its own `swayidle -w timeout 1 true resume "kill -TERM $$"`,
wait "${pids[@]}" 2>/dev/null || true

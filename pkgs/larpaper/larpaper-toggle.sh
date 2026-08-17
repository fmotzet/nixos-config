#!/usr/bin/env bash
# Toggle larpaper on all monitors, for binding to a single key combination.
#
# Starts `larpaper-all --showoff` when nothing is running, and tears it down when
# it is. --showoff is the point: in that mode larpaper.sh skips both its inner
# `swayidle -w timeout 1 true resume "kill -TERM $$"` and its `read -rsn 1`, so
# the animation ignores mouse movement and keypresses and keeps running until
# something explicitly stops it.
#
# Bind this to a compositor-level combination (SUPER + ...). A Ctrl/Shift-only
# combination would be delivered to the focused Kitty window instead of reaching
# Hyprland, and so could never toggle larpaper off.

set -uo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
launcher="$script_dir/larpaper-all.sh"
[[ -x "$launcher" ]] || launcher="$script_dir/larpaper-all"

# Reuse larpaper-all's lock as the liveness probe: it holds this lock for as long
# as its child windows exist, so a failed non-blocking acquire means "running".
lock_file="${XDG_RUNTIME_DIR:-/tmp}/larpaper-all.lock"
exec 9>"$lock_file"

if flock -n 9; then
  # Lock was free -> nothing running -> start. Release first so larpaper-all can
  # take the lock itself.
  flock -u 9
  exec "$launcher" --showoff
fi

# Lock held -> running -> stop. Killing the Kitty windows is what matters:
# larpaper-all is sitting in `wait`, so it exits on its own once its children are
# gone, which releases the lock and leaves the next toggle free to start again.
pkill -f -- '--class larpaper-' 2>/dev/null || true

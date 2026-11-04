#!/usr/bin/env bash
set -uo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
launcher="$script_dir/larpaper-all.sh"
[[ -x "$launcher" ]] || launcher="$script_dir/larpaper-all"

lock_file="${XDG_RUNTIME_DIR:-/tmp}/larpaper-all.lock"
exec 9>"$lock_file"

if flock -n 9; then
  flock -u 9
  exec "$launcher" --showoff
fi

pkill -f -- '--class larpaper-' 2>/dev/null || true

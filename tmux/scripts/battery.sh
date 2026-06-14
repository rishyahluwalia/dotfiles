#!/bin/sh
# Battery percentage (macOS). Prints '?' when no battery is present (desktop).
pct=$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
[ -z "$pct" ] && { printf '?\n'; exit 0; }
printf '%s%%\n' "$pct"

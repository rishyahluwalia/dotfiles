#!/bin/sh
# Memory used % on macOS = (active + wired + compressed) / total, one decimal
# (e.g. "84.5%"). Mirrors Activity Monitor's "Memory Used" reasonably well.
total=$(sysctl -n hw.memsize)
psize=$(vm_stat | sed -n 's/.*page size of \([0-9]*\) bytes.*/\1/p')
vm_stat | awk -v total="$total" -v ps="$psize" '
  /Pages active/                 { a = $3 }
  /Pages wired down/             { w = $4 }
  /Pages occupied by compressor/ { c = $5 }
  END {
    gsub(/\./, "", a); gsub(/\./, "", w); gsub(/\./, "", c)
    printf "%.1f%%\n", (a + w + c) * ps / total * 100
  }'

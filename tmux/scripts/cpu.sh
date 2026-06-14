#!/bin/sh
# Total CPU usage on macOS = 100 - idle%, one decimal (e.g. "34.0%").
# `top -l 2` takes two samples; the first is bogus, so awk's END keeps the last.
top -l 2 -n 0 | awk '/CPU usage/ { idle = $(NF - 1); sub(/%/, "", idle) } END { printf "%.1f%%\n", 100 - idle }'

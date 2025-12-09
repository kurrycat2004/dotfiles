#!/usr/bin/env sh
set -euo pipefail

killall -q waybar
while pgrep -x waybar >/dev/null; do sleep 1; done
GTK_DEBUG=interactive waybar &

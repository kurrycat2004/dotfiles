#!/usr/bin/env bash
set -euo pipefail

if [ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    echo "No Hyprland instance running. Skipping."
    exit 0
fi

COL_FILE="$HOME/.config/hypr/matugen/colors.sh"

if [ -f "$COL_FILE" ]; then
    # shellcheck source=/dev/null
    source "$COL_FILE"
else
    echo "Noctalia color file not found: $COL_FILE" >&2
    exit 1
fi

hyprctl keyword general:col.active_border "$primary"
hyprctl keyword general:col.inactive_border "$outline_variant"

hyprctl keyword group:col.border_active "$primary_fixed"
hyprctl keyword group:col.border_inactive "$primary_fixed_dim"
hyprctl keyword group:col.border_locked_active = "$primary_fixed"
hyprctl keyword group:col.border_locked_inactive = "$primary_fixed_dim"

hyprctl keyword group:groupbar:col.active "$primary_fixed"
hyprctl keyword group:groupbar:col.inactive "$primary_fixed_dim"
hyprctl keyword group:groupbar:col.locked_active "$primary_fixed"
hyprctl keyword group:groupbar:col.locked_inactive "$primary_fixed_dim"

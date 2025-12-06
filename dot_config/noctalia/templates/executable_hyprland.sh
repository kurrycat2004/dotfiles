#!/usr/bin/env bash
set -euo pipefail

# All Colors generated with matugen
<* for name, value in colors *>
{{name}}='rgba({{value.default.hex_stripped}}ff)'
<* endfor *>

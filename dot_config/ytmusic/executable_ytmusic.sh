#!/usr/bin/env bash
set -euo pipefail

# --- config ---
PORT="${PORT:-26538}"
BASE_URL="${BASE_URL:-http://127.0.0.1:${PORT}/api/v1}"
TOKEN_FILE="${TOKEN_FILE:-$HOME/.config/ytmusic/.token}"

if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "ytmusic: token file not found at $TOKEN_FILE" >&2
  exit 1
fi
TOKEN="$(tr -d '\n' < "$TOKEN_FILE")"
AUTH_HEADER=("Authorization: Bearer $TOKEN")

# --- helpers ---
post() { curl -fsS -X POST -H "${AUTH_HEADER[@]}" "$BASE_URL/$1" ${2:+-H 'Content-Type: application/json' --data-binary "$2"} -o /dev/null; }
get()  { curl -fsS -H "${AUTH_HEADER[@]}" "$BASE_URL/$1"; }

get_state() {
  get "$1" | sed -n 's/.*"state"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p'
}

select_state() {
  sleep 0.01
  local s; s="$(get_state "$2" || true)"
  if [[ "$s" == "$1" ]]; then
    printf '%s\n' "${3-}"
  else
    printf '%s\n' "${4-}"
  fi
}

get_volume() {
  get "volume" | sed -n 's/.*"state"[[:space:]]*:[[:space:]]*\([0-9]\+\).*/\1/p'
}

relative_set_volume() {
  local delta="$1"

  if ! [[ "$delta" =~ ^[+-]?[0-9]+$ ]]; then
    echo "ytmctl: relative-set-volume requires integer delta, got '$delta'" >&2
    exit 1
  fi

  local current new
  current="$(get_volume)"
  if [[ -z "$current" ]]; then
    echo "ytmctl: failed to get current volume" >&2
    exit 1
  fi

  new=$(( current + delta ))

  # Clamp to [0,100]
  (( new < 0 )) && new=0
  (( new > 100 )) && new=100

  post "volume" "$(printf '{"volume":%d}' "$new")"
}

# --- commands ---
case "${1:-}" in
  like)            post "like" ;;
  dislike)         post "dislike" ;;
  play)            post "play" ;;
  pause)           post "pause" ;;
  toggle)          post "toggle-play" ;;
  next)            post "next" ;;
  prev|previous)   post "previous" ;;

  select-liked)    select_state "LIKE"    "like-state" "${2:-}" "${3:-}" ;;
  select-disliked) select_state "DISLIKE" "like-state" "${2:-}" "${3:-}" ;;

  get-volume)        get_volume ;;
  relative-set-volume)
      if [[ $# -lt 2 ]]; then
        echo "Usage: ytmusic relative-set-volume <delta>" >&2
        exit 1
      fi
      relative_set_volume "$2"
      ;;
  *)
    cat <<EOF
Usage:
  ytmusic {like|dislike|play|pause|toggle|next|prev}
  ytmusic select-liked <A> <B>
  ytmusic select-disliked <A> <B>
  ytmusic get-volume
  ytmusic relative-set-volume <delta>

Env:
  PORT (default 26538)
  BASE_URL (default http://127.0.0.1:\$PORT/api/v1)
  TOKEN_FILE (default ~/.config/ytmusic/.token)
EOF
    exit 1
    ;;
esac

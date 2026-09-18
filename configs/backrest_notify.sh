#!/usr/bin/env bash
# Desktop notification for backrest hook events.
# Usage: notify.sh <event> <name> [message]
# backrest runs as a systemd system service without a session, so point
# notify-send at the user's session bus explicitly.
set -u
event="$1"; name="$2"; msg="${3:-}"

export DISPLAY="${DISPLAY:-:0}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"

case "$event" in
  *SUCCESS*)  urgency=low;      title="Backup finished: $name" ;;
  *WARNING*)  urgency=normal;   title="Backup warning: $name" ;;
  *ERROR*)    urgency=critical; title="Backup failed: $name" ;;
  *)          urgency=normal;   title="Backrest $event: $name" ;;
esac

notify-send --app-name=backrest --urgency="$urgency" \
  --icon=drive-harddisk "$title" "$msg"

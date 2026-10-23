#!/usr/bin/env python3
"""Polybar module: backrest backup status.

Reads backrest's operation log (sqlite, read-only) and prints one line
for polybar with one entry per configured plan:
  running  a backup is in progress
  error    the most recent finished backup failed
  ok       the most recent finished backup succeeded
  never    no finished backup yet
"""
import json
import os
import sqlite3
import subprocess
import sys
import time

HOME = os.path.expanduser("~")
OPLOG = os.environ.get("BACKREST_OPLOG", os.path.join(HOME, ".local/share/backrest/oplog.sqlite"))
CONFIG = os.path.join(HOME, ".config/backrest/config.json")

# polybar colors (mirror [colors] in config.ini)
PRIMARY = "#F0C674"
SECONDARY = "#8ABEB7"
ALERT = "#A54242"
DISABLED = "#707880"

ICON_OK = "\U000f006f"       # nf-md-backup_restore
ICON_RUN = "\U000f0453"      # nf-md-refresh
ICON_ERR = "\U000f0026"      # nf-md-alert
ICON_CHECK = "\U000f012c"    # nf-md-check

STATUS_INPROGRESS = 2
STATUS_SUCCESS = 3
STATUS_ERROR = 4
STATUS_WARNING = 7
FINISHED = (STATUS_SUCCESS, STATUS_ERROR, STATUS_WARNING)


def icon(glyph):
    return f"%{{T2}}{glyph}%{{T-}}"


def out(glyph, text, color):
    print(f"%{{F{color}}}{icon(glyph)} {text}%{{F-}}")
    sys.exit(0)


def age(ms):
    secs = max(0, time.time() - ms / 1000)
    if secs < 3600:
        return f"{int(secs // 60)}m"
    if secs < 48 * 3600:
        return f"{int(secs // 3600)}h"
    return f"{int(secs // 86400)}d"


def service_active():
    r = subprocess.run(["systemctl", "is-active", "--quiet", "backrest"])
    return r.returncode == 0


def plan_ids():
    try:
        with open(CONFIG) as f:
            cfg = json.load(f)
    except (OSError, ValueError):
        return []
    return [plan["id"] for plan in cfg.get("plans", [])]


def load_ops():
    """Return {plan: [(status, start_ms), ...]} newest first, backups only."""
    if not os.path.exists(OPLOG):
        return {}
    conn = sqlite3.connect(f"file:{OPLOG}?mode=ro", uri=True, timeout=2)
    rows = conn.execute(
        "SELECT g.plan_id, o.status, o.start_time_ms "
        "FROM operations o JOIN operation_groups g USING (ogid) "
        "WHERE g.plan_id != '_system_' "
        "ORDER BY o.start_time_ms DESC"
    ).fetchall()
    conn.close()
    ops = {}
    for plan, status, start in rows:
        ops.setdefault(plan, []).append((status, start))
    return ops


def plan_state(mine, now_ms):
    """Return (color, glyph, suffix) for one plan's operations."""
    running = any(s == STATUS_INPROGRESS and t <= now_ms for s, t in mine)
    if running:
        return SECONDARY, ICON_RUN, ""
    done = [(s, t) for s, t in mine if s in FINISHED]
    if not done:
        return DISABLED, "", "never"
    status, start = done[0]
    if status == STATUS_ERROR:
        return ALERT, ICON_ERR, age(start)
    return None, ICON_CHECK, age(start)


def notify_summary():
    """Right-click: pop a notification listing every plan's last backup."""
    ops = load_ops()
    now_ms = time.time() * 1000
    words = {ICON_RUN: "running", ICON_ERR: "FAILED", ICON_CHECK: "ok"}
    lines = []
    for plan in plan_ids():
        _, glyph, suffix = plan_state(ops.get(plan, []), now_ms)
        word = words.get(glyph, suffix)
        lines.append(f"{plan}: {word}, {suffix} ago" if glyph and suffix else f"{plan}: {word}")
    subprocess.run(["notify-send", "--app-name=backrest", "--icon=drive-harddisk",
                    "Backrest", "\n".join(lines) or "no plans configured"])


def main():
    if "--notify" in sys.argv[1:]:
        notify_summary()
        return
    if not service_active():
        out(ICON_ERR, "backrest down", ALERT)

    plans = plan_ids()
    if not plans:
        out(ICON_OK, "no plans", DISABLED)

    ops = load_ops()
    now_ms = time.time() * 1000
    parts = []
    any_alert = False
    for plan in plans:
        color, glyph, suffix = plan_state(ops.get(plan, []), now_ms)
        any_alert |= color == ALERT
        # the bar shows only the state glyph; the age stays in the --notify popup
        text = f"{plan} {icon(glyph)}" if glyph else f"{plan} {suffix}"
        parts.append(f"%{{F{color}}}{text}%{{F-}}" if color else text)

    head = f"%{{F{ALERT if any_alert else PRIMARY}}}{icon(ICON_OK)}%{{F-}}"
    sep = f" %{{F{DISABLED}}}·%{{F-}} "
    print(f"{head} " + sep.join(parts))


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        raise
    except Exception as e:  # never leave the bar blank
        print(f"%{{F{DISABLED}}}{icon(ICON_OK)} ?%{{F-}}")
        print(e, file=sys.stderr)

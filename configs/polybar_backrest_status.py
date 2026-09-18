#!/usr/bin/env python3
"""Polybar module: backrest backup status.

Reads backrest's operation log (sqlite, read-only) and prints one line
for polybar. States, in priority order:
  down     backrest service not running
  running  a backup/prune/check is in progress
  error    most recent finished operation of a plan/repo failed
  stale    a plan's last successful backup is older than its schedule allows
  ok       everything fine; shows age of the newest successful backup
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
ICON_STALE = "\U000f00f0"    # nf-md-calendar_clock

STATUS_PENDING = 1
STATUS_INPROGRESS = 2
STATUS_SUCCESS = 3
STATUS_ERROR = 4
STATUS_WARNING = 7
FINISHED = (STATUS_SUCCESS, STATUS_ERROR, STATUS_WARNING)

STALE_GRACE = 1.5  # multiple of maxFrequencyDays before a plan counts as late


def out(icon, text="", color=PRIMARY, whole=False):
    icon = f"%{{T2}}{icon}%{{T-}}"
    if whole:
        print(f"%{{F{color}}}{icon} {text}%{{F-}}".rstrip())
    else:
        print(f"%{{F{color}}}{icon}%{{F-}} {text}".rstrip())
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


def plan_max_frequency_days():
    try:
        with open(CONFIG) as f:
            cfg = json.load(f)
    except (OSError, ValueError):
        return {}
    days = {}
    for plan in cfg.get("plans", []):
        sched = plan.get("schedule", {})
        if "maxFrequencyDays" in sched:
            days[plan["id"]] = float(sched["maxFrequencyDays"])
        elif "maxFrequencyHours" in sched:
            days[plan["id"]] = float(sched["maxFrequencyHours"]) / 24
    return days


def load_ops():
    if not os.path.exists(OPLOG):
        return []
    conn = sqlite3.connect(f"file:{OPLOG}?mode=ro", uri=True, timeout=2)
    rows = conn.execute(
        "SELECT g.plan_id, g.repo_id, o.status, o.start_time_ms "
        "FROM operations o JOIN operation_groups g USING (ogid) "
        "ORDER BY o.start_time_ms DESC"
    ).fetchall()
    conn.close()
    return rows


def notify_summary():
    """Right-click: pop a notification listing every plan's last backup."""
    ops = load_ops()
    lines = []
    for plan in plan_max_frequency_days():
        done = [o for o in ops if o[0] == plan and o[2] in FINISHED]
        if not done:
            lines.append(f"{plan}: never")
            continue
        status, start = done[0][2], done[0][3]
        word = {STATUS_SUCCESS: "ok", STATUS_WARNING: "warning"}.get(status, "FAILED")
        lines.append(f"{plan}: {word}, {age(start)} ago")
    subprocess.run(["notify-send", "--app-name=backrest", "--icon=drive-harddisk",
                    "Backrest", "\n".join(lines) or "no plans configured"])


def plan_states(ops, now_ms):
    """Return {plan: (color, text)} for every configured plan."""
    states = {}
    for plan, days in plan_max_frequency_days().items():
        mine = [o for o in ops if o[0] == plan]
        running = [o for o in mine if o[2] == STATUS_INPROGRESS and o[3] <= now_ms]
        done = [o for o in mine if o[2] in FINISHED]
        ok = [o for o in mine if o[2] == STATUS_SUCCESS]
        pending = any(o[2] == STATUS_PENDING for o in mine)

        if running:
            states[plan] = (SECONDARY, f"{plan} {ICON_RUN}")
        elif done and done[0][2] == STATUS_ERROR:
            states[plan] = (ALERT, f"{plan} {ICON_ERR}")
        elif not ok and pending:
            states[plan] = (DISABLED, f"{plan} -")
        elif not ok:
            states[plan] = (PRIMARY, f"{plan} never")
        elif now_ms - ok[0][3] > days * STALE_GRACE * 86400 * 1000:
            states[plan] = (PRIMARY, f"{plan} {ICON_STALE} {age(ok[0][3])}")
        elif done[0][2] == STATUS_WARNING:
            states[plan] = (PRIMARY, f"{plan} {age(ok[0][3])}!")
        else:
            states[plan] = (None, f"{plan} {age(ok[0][3])}")
    return states


def repo_errors(ops):
    """Repos whose latest system operation (prune/check/forget) failed."""
    seen, failed = set(), []
    for plan, repo, status, _ in ops:
        if plan != "_system_" or status not in FINISHED or repo in seen:
            continue
        seen.add(repo)
        if status == STATUS_ERROR:
            failed.append(repo)
    return failed


def main():
    if "--notify" in sys.argv[1:]:
        notify_summary()
        return
    if not service_active():
        out(ICON_ERR, "backrest down", ALERT, whole=True)

    ops = load_ops()
    now_ms = time.time() * 1000
    states = plan_states(ops, now_ms)
    if not states:
        out(ICON_OK, "no plans", DISABLED, whole=True)

    parts = []
    for color, text in states.values():
        text = text.replace(ICON_RUN, f"%{{T2}}{ICON_RUN}%{{T-}}") \
                   .replace(ICON_ERR, f"%{{T2}}{ICON_ERR}%{{T-}}") \
                   .replace(ICON_STALE, f"%{{T2}}{ICON_STALE}%{{T-}}")
        parts.append(f"%{{F{color}}}{text}%{{F-}}" if color else text)
    for repo in repo_errors(ops):
        parts.append(f"%{{F{ALERT}}}repo {repo} %{{T2}}{ICON_ERR}%{{T-}}%{{F-}}")

    any_alert = any(c == ALERT for c, _ in states.values()) or repo_errors(ops)
    icon_color = ALERT if any_alert else PRIMARY
    sep = f" %{{F{DISABLED}}}·%{{F-}} "
    print(f"%{{F{icon_color}}}%{{T2}}{ICON_OK}%{{T-}}%{{F-}} " + sep.join(parts))


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        raise
    except Exception as e:  # never leave the bar blank
        print(f"%{{F{DISABLED}}}%{{T2}}{ICON_OK}%{{T-}} ?%{{F-}}")
        print(e, file=sys.stderr)

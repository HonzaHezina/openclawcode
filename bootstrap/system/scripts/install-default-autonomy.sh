#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data}"
LOG_FILE="${DATA_DIR}/logs/install-default-autonomy.log"
MARKER_FILE="${DATA_DIR}/.default-autonomy-installed-v1"
AUTONOMY_TZ="${OPENCLAW_AUTONOMY_TIMEZONE:-Europe/Prague}"
ENABLE_DEFAULT_AUTONOMY="${OPENCLAW_ENABLE_DEFAULT_AUTONOMY:-true}"

mkdir -p "${DATA_DIR}/logs"

if [ "$ENABLE_DEFAULT_AUTONOMY" != "true" ]; then
  echo "[autonomy] OPENCLAW_ENABLE_DEFAULT_AUTONOMY=false; skipping" | tee -a "$LOG_FILE"
  exit 0
fi

if [ -f "$MARKER_FILE" ]; then
  echo "[autonomy] default autonomy already installed" | tee -a "$LOG_FILE"
  exit 0
fi

run_add() {
  echo "[autonomy] adding: $*" | tee -a "$LOG_FILE"
  openclaw cron add "$@" >>"$LOG_FILE" 2>&1
}

run_add \
  --name "Morning planning check" \
  --cron "0 8 * * *" \
  --tz "$AUTONOMY_TZ" \
  --session main \
  --system-event "Morning planning check: review pending approvals, summarize the top priorities for today, and mention any blocked staged tasks." \
  --wake next-heartbeat

run_add \
  --name "Afternoon approval reminder" \
  --cron "0 13 * * 1-5" \
  --tz "$AUTONOMY_TZ" \
  --session main \
  --system-event "Approval reminder: check whether any staged tasks are waiting for explicit approval, summarize risk briefly, and ask for a clear yes/no next step." \
  --wake next-heartbeat

run_add \
  --name "Weekly autonomy review" \
  --cron "30 9 * * 1" \
  --tz "$AUTONOMY_TZ" \
  --session main \
  --system-event "Weekly autonomy review: if the stack is stable, delegate exactly one small safe infrastructure improvement to the dev agent, prepare it as a staged approval task only, and report the task id plus risks." \
  --wake next-heartbeat

run_add \
  --name "Nightly ops recap" \
  --cron "30 20 * * *" \
  --tz "$AUTONOMY_TZ" \
  --session main \
  --system-event "Nightly ops recap: summarize what changed today, which approval tasks remain open, and which single item should be handled next." \
  --wake next-heartbeat

touch "$MARKER_FILE"
echo "[autonomy] default cron jobs installed" | tee -a "$LOG_FILE"

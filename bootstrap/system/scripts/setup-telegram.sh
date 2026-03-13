#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data}"
LOG_FILE="${DATA_DIR}/logs/setup-telegram.log"
MARKER_FILE="${DATA_DIR}/.telegram-bound-main"

mkdir -p "${DATA_DIR}/logs"

if [ -z "${TELEGRAM_BOT_TOKEN:-}" ]; then
  echo "[telegram] TELEGRAM_BOT_TOKEN is not set; skipping" | tee -a "$LOG_FILE"
  exit 0
fi

if [ -f "$MARKER_FILE" ]; then
  echo "[telegram] already initialized" | tee -a "$LOG_FILE"
  exit 0
fi

if ! openclaw agents bind --agent main --bind telegram >>"$LOG_FILE" 2>&1; then
  echo "[telegram] bind telegram -> main returned non-zero; check log" | tee -a "$LOG_FILE"
fi

cat <<MSG | tee -a "$LOG_FILE"
[telegram] Telegram channel configured.
[telegram] If dmPolicy=pairing, now DM the bot once and approve the pending code with:
[telegram]   openclaw pairing list telegram
[telegram]   openclaw pairing approve telegram <CODE>
MSG

touch "$MARKER_FILE"

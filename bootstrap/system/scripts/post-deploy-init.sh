#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data}"
LOG_FILE="${DATA_DIR}/logs/post-deploy-init.log"
mkdir -p "${DATA_DIR}/logs"

echo "[post-init] waiting for gateway health" | tee -a "$LOG_FILE"
for _ in $(seq 1 90); do
  if curl -sf http://127.0.0.1:${OPENCLAW_GATEWAY_PORT:-18789}/healthz >/dev/null 2>&1; then
    echo "[post-init] gateway healthy" | tee -a "$LOG_FILE"
    break
  fi
  sleep 2
done

/data/system/scripts/setup-telegram.sh >>"$LOG_FILE" 2>&1 || true
/data/system/scripts/install-default-autonomy.sh >>"$LOG_FILE" 2>&1 || true

echo "[post-init] done" | tee -a "$LOG_FILE"

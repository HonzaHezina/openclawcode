#!/usr/bin/env bash
set -euo pipefail

export HOME="${HOME:-/home/node}"
export OPENCLAW_CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-/data/openclaw.json}"
export OPENCLAW_STATE_DIR="${OPENCLAW_STATE_DIR:-/data/.openclaw}"
export OPENCLAW_GATEWAY_PORT="${OPENCLAW_GATEWAY_PORT:-18789}"
export OPENCLAW_GATEWAY_BIND="${OPENCLAW_GATEWAY_BIND:-lan}"
export OPENCODE_BASE_URL="${OPENCODE_BASE_URL:-http://opencode:4096}"

mkdir -p "${OPENCLAW_STATE_DIR}" "/data/logs"

echo "[startup] waiting for OpenCode at ${OPENCODE_BASE_URL}/global/health" | tee -a /data/logs/openclaw-startup.log
for _ in $(seq 1 30); do
  if curl -sf "${OPENCODE_BASE_URL}/global/health" >/dev/null 2>&1; then
    echo "[startup] OpenCode is reachable" | tee -a /data/logs/openclaw-startup.log
    break
  fi
  sleep 2
done

echo "[startup] launching OpenClaw gateway on ${OPENCLAW_GATEWAY_BIND}:${OPENCLAW_GATEWAY_PORT}" | tee -a /data/logs/openclaw-startup.log
openclaw gateway --port "${OPENCLAW_GATEWAY_PORT}" --bind "${OPENCLAW_GATEWAY_BIND}" --allow-unconfigured &
GW_PID=$!

/data/system/scripts/post-deploy-init.sh >>/data/logs/post-deploy-init.log 2>&1 &

wait "$GW_PID"

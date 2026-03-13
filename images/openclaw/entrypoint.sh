#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data}"
BOOTSTRAP_DIR="/opt/openclaw-stack/bootstrap"
OPENCLAW_CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-/data/openclaw.json}"

seed_file() {
  local src="$1"
  local dst="$2"
  if [ ! -e "$dst" ]; then
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
  fi
}

seed_dir() {
  local src="$1"
  local dst="$2"
  if [ ! -e "$dst" ]; then
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
  elif [ -d "$dst" ] && [ -z "$(find "$dst" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then
    cp -a "${src}/." "$dst/"
  fi
}

mkdir -p \
  "$DATA_DIR" \
  "$DATA_DIR/.openclaw" \
  "$DATA_DIR/logs" \
  "$DATA_DIR/approvals/tasks" \
  "$DATA_DIR/backups" \
  "$DATA_DIR/repos"

if [ ! -s "$OPENCLAW_CONFIG_PATH" ]; then
  mkdir -p "$(dirname "$OPENCLAW_CONFIG_PATH")"
  "$BOOTSTRAP_DIR/openclaw/render-openclaw-config.sh" > "$OPENCLAW_CONFIG_PATH"
fi

seed_dir "$BOOTSTRAP_DIR/workspaces" "$DATA_DIR/workspaces"
seed_dir "$BOOTSTRAP_DIR/system" "$DATA_DIR/system"
[ -d "$BOOTSTRAP_DIR/docs" ] && seed_dir "$BOOTSTRAP_DIR/docs" "$DATA_DIR/docs"
seed_dir "$BOOTSTRAP_DIR/opencode" "$DATA_DIR/opencode"

chmod +x "$DATA_DIR/system/scripts/"*.sh || true

export OPENCLAW_CONFIG_PATH
if ! openclaw config validate >/tmp/openclaw-config-check.log 2>&1; then
  cat /tmp/openclaw-config-check.log >&2 || true
  exit 1
fi

touch "$DATA_DIR/.bootstrap-seeded-openclaw"

if id node >/dev/null 2>&1; then
  chown -R node:node "$DATA_DIR"
  exec su -s /bin/bash node -c "/opt/openclaw-stack/run-openclaw.sh"
fi

exec /opt/openclaw-stack/run-openclaw.sh

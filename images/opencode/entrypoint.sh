#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data}"
BOOTSTRAP_DIR="/opt/opencode-stack/bootstrap"

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

seed_file() {
  local src="$1"
  local dst="$2"
  if [ ! -e "$dst" ]; then
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
  fi
}

mkdir -p "$DATA_DIR" "$DATA_DIR/logs" "$DATA_DIR/workspaces" "$DATA_DIR/opencode"

seed_dir "$BOOTSTRAP_DIR/workspaces" "$DATA_DIR/workspaces"
seed_dir "$BOOTSTRAP_DIR/opencode/agents" "$DATA_DIR/opencode/agents"
seed_dir "$BOOTSTRAP_DIR/opencode/commands" "$DATA_DIR/opencode/commands"
seed_file "$BOOTSTRAP_DIR/opencode/opencode.jsonc" "$DATA_DIR/opencode/opencode.jsonc"

touch "$DATA_DIR/.bootstrap-seeded-opencode"

exec /opt/opencode-stack/run-opencode.sh

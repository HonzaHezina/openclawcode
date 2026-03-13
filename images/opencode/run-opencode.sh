#!/usr/bin/env bash
set -euo pipefail

export OPENCODE_CONFIG_DIR="${OPENCODE_CONFIG_DIR:-/data/opencode}"
export OPENCODE_CONFIG="${OPENCODE_CONFIG:-/data/opencode/opencode.jsonc}"

mkdir -p /data/logs /data/workspaces/dev

echo "[startup] launching OpenCode serve on 0.0.0.0:4096" | tee -a /data/logs/opencode-startup.log
exec opencode serve --hostname 0.0.0.0 --port 4096

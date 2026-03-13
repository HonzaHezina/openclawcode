#!/usr/bin/env bash
set -euo pipefail
CODE="${1:-}"
if [ -z "$CODE" ]; then
  echo "Usage: approve-telegram-pairing.sh <CODE>" >&2
  exit 1
fi
openclaw pairing approve telegram "$CODE"

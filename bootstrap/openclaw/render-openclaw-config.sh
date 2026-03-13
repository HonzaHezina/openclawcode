#!/usr/bin/env bash
set -euo pipefail

HEARTBEAT_EVERY="${OPENCLAW_HEARTBEAT_EVERY:-30m}"
HEARTBEAT_TARGET="${OPENCLAW_HEARTBEAT_TARGET:-last}"
HEARTBEAT_DIRECT_POLICY="${OPENCLAW_HEARTBEAT_DIRECT_POLICY:-allow}"
TELEGRAM_GROUP_REQUIRE_MENTION="${TELEGRAM_GROUP_REQUIRE_MENTION:-true}"
TELEGRAM_DM_POLICY="${TELEGRAM_DM_POLICY:-}"
TELEGRAM_OWNER_ID="${TELEGRAM_OWNER_ID:-}"

if [ -z "$TELEGRAM_DM_POLICY" ]; then
  if [ -n "$TELEGRAM_OWNER_ID" ]; then
    TELEGRAM_DM_POLICY="allowlist"
  else
    TELEGRAM_DM_POLICY="pairing"
  fi
fi

cat <<JSON
{
  gateway: {
    mode: "local",
    port: 18789,
    bind: "${OPENCLAW_GATEWAY_BIND:-lan}",
    auth: {
      mode: "token",
      token: "${OPENCLAW_GATEWAY_TOKEN:-change-me}",
    },
  },

  browser: {
    cdpUrl: "${BROWSER_CDP_URL:-http://browser:9222}",
  },

  cron: {
    enabled: true,
    maxConcurrentRuns: 1,
    sessionRetention: "24h",
    runLog: {
      maxBytes: "2mb",
      keepLines: 2000,
    },
  },

  tools: {
    profile: "messaging",
  },

  agents: {
    defaults: {
      skipBootstrap: true,
      workspace: "/data/workspaces/main",
      maxConcurrent: 2,
      model: {
        primary: "${OPENCLAW_MODEL_PRIMARY:-openai/gpt-5-mini}",
      },
      heartbeat: {
        every: "${HEARTBEAT_EVERY}",
        target: "${HEARTBEAT_TARGET}",
        directPolicy: "${HEARTBEAT_DIRECT_POLICY}",
      },
      sandbox: {
        mode: "off",
        scope: "agent",
      },
    },

    list: [
      {
        id: "main",
        default: true,
        workspace: "/data/workspaces/main",
        tools: {
          profile: "messaging",
          allow: ["group:web", "group:memory", "sessions_spawn"],
        },
      },
      {
        id: "dev",
        workspace: "/data/workspaces/dev",
        heartbeat: {
          every: "0m",
          target: "none",
        },
        tools: {
          profile: "coding",
          allow: ["group:web", "group:automation"],
          deny: ["browser", "canvas", "gateway"],
        },
      },
    ],
  },
JSON

if [ -n "${TELEGRAM_BOT_TOKEN:-}" ]; then
  cat <<JSON

  channels: {
    telegram: {
      enabled: true,
      botToken: "${TELEGRAM_BOT_TOKEN}",
      dmPolicy: "${TELEGRAM_DM_POLICY}",
      groups: {
        "*": {
          requireMention: ${TELEGRAM_GROUP_REQUIRE_MENTION},
        },
      },
JSON

  if [ -n "$TELEGRAM_OWNER_ID" ]; then
    cat <<JSON
      allowFrom: ["${TELEGRAM_OWNER_ID}"],
JSON
  fi

  cat <<JSON
    },
  },
JSON
fi

cat <<JSON

}
JSON

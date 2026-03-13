#!/usr/bin/env bash
set -euo pipefail
source /data/system/scripts/common.sh

AGENT_ID="${1:-}"
shift || true
REQUEST_TEXT="${*:-}"

if [ -z "${AGENT_ID}" ] || [ -z "${REQUEST_TEXT}" ]; then
  echo "Usage: scaffold-openclaw-agent.sh <agent_id> \"<zadani>\"" >&2
  exit 1
fi

TASK_ID="$(new_task_id)"
TASK_DIR="$(prepare_task_tree "${TASK_ID}")"

seed_candidate_tree "${TASK_DIR}/baseline"
seed_candidate_tree "${TASK_DIR}/candidate"

write_request "${TASK_DIR}/candidate/REQUEST.md" "Vytvoř nového OpenClaw agenta.

agent_id: ${AGENT_ID}

Zadání:
${REQUEST_TEXT}

Požadavky:
- vytvoř workspace workspaces/${AGENT_ID}/
- připrav AGENTS.md, SOUL.md, USER.md, HEARTBEAT.md
- když je třeba, uprav openclaw.json
- drž oprávnění co nejmenší
- na konci napiš TASK_RESULT.md"

run_opencode_attached "${TASK_DIR}/candidate" --agent openclaw-agent-writer --format default \
  "Read REQUEST.md and create the requested specialized OpenClaw agent in the current working tree only." \
  | tee "${TASK_DIR}/artifacts/opencode-output.txt"

run_opencode_attached "${TASK_DIR}/candidate" --agent change-reviewer --format default \
  "Review the newly scaffolded agent and write REVIEW.md with any warnings or missing pieces." \
  | tee "${TASK_DIR}/artifacts/review-output.txt" || true

generate_patch "${TASK_DIR}/baseline" "${TASK_DIR}/candidate" "${TASK_DIR}/changes.patch"

print_task_footer "${TASK_ID}" "${TASK_DIR}"

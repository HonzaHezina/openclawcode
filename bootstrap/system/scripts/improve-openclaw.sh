#!/usr/bin/env bash
set -euo pipefail
source /data/system/scripts/common.sh

REQUEST_TEXT="${*:-}"
if [ -z "${REQUEST_TEXT}" ]; then
  echo "Usage: improve-openclaw.sh \"<zadani>\"" >&2
  exit 1
fi

TASK_ID="$(new_task_id)"
TASK_DIR="$(prepare_task_tree "${TASK_ID}")"

seed_candidate_tree "${TASK_DIR}/baseline"
seed_candidate_tree "${TASK_DIR}/candidate"

write_request "${TASK_DIR}/candidate/REQUEST.md" "Zadání:
${REQUEST_TEXT}

Úkol:
- uprav current worktree tak, aby řešil zadání
- zachovej approval-first přístup
- nepracuj s live /data
- na konci aktualizuj TASK_RESULT.md a RISKS.md"

run_opencode_attached "${TASK_DIR}/candidate" --agent openclaw-improver --format default \
  "Read REQUEST.md and implement the requested OpenClaw/OpenCode infrastructure improvement only in the current working tree." \
  | tee "${TASK_DIR}/artifacts/opencode-output.txt"

run_opencode_attached "${TASK_DIR}/candidate" --agent change-reviewer --format default \
  "Review the current staged changes, write REVIEW.md, and highlight blockers or checks before approval." \
  | tee "${TASK_DIR}/artifacts/review-output.txt" || true

generate_patch "${TASK_DIR}/baseline" "${TASK_DIR}/candidate" "${TASK_DIR}/changes.patch"

print_task_footer "${TASK_ID}" "${TASK_DIR}"

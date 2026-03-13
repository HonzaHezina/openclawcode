#!/usr/bin/env bash
set -euo pipefail

TASKS_DIR="${TASKS_DIR:-/data/approvals/tasks}"
mkdir -p "${TASKS_DIR}"

for dir in "${TASKS_DIR}"/*; do
  [ -d "${dir}" ] || continue
  task_id="$(basename "${dir}")"
  status="staged"
  [ -f "${dir}/APPLIED_AT.txt" ] && status="applied"
  echo "== ${task_id} [${status}] =="
  [ -f "${dir}/candidate/TASK_RESULT.md" ] && sed -n '1,40p' "${dir}/candidate/TASK_RESULT.md" || echo "(no TASK_RESULT.md)"
  echo
done

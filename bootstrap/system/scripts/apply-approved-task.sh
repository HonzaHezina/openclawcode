#!/usr/bin/env bash
set -euo pipefail

TASK_ID="${1:-}"
APPROVED_FLAG="${2:-}"

if [ -z "${TASK_ID}" ] || [ "${APPROVED_FLAG}" != "--approved" ]; then
  echo "Usage: apply-approved-task.sh <TASK_ID> --approved" >&2
  exit 1
fi

DATA_DIR="${DATA_DIR:-/data}"
TASK_DIR="${DATA_DIR}/approvals/tasks/${TASK_ID}"
CANDIDATE_DIR="${TASK_DIR}/candidate"

if [ ! -d "${CANDIDATE_DIR}" ]; then
  echo "Task not found: ${TASK_ID}" >&2
  exit 1
fi

backup_dir="${DATA_DIR}/backups/${TASK_ID}-$(date +%Y%m%d-%H%M%S)"
mkdir -p "${backup_dir}"

cp -a "${DATA_DIR}/openclaw.json" "${backup_dir}/openclaw.json"
[ -d "${DATA_DIR}/workspaces" ] && rsync -a "${DATA_DIR}/workspaces/" "${backup_dir}/workspaces/"
[ -d "${DATA_DIR}/system" ] && rsync -a "${DATA_DIR}/system/" "${backup_dir}/system/"
[ -d "${DATA_DIR}/opencode" ] && rsync -a "${DATA_DIR}/opencode/" "${backup_dir}/opencode/"
[ -d "${DATA_DIR}/docs" ] && rsync -a "${DATA_DIR}/docs/" "${backup_dir}/docs/"

cp -a "${CANDIDATE_DIR}/openclaw.json" "${DATA_DIR}/openclaw.json"
[ -d "${CANDIDATE_DIR}/workspaces" ] && rsync -a --delete "${CANDIDATE_DIR}/workspaces/" "${DATA_DIR}/workspaces/"
[ -d "${CANDIDATE_DIR}/system" ] && rsync -a --delete "${CANDIDATE_DIR}/system/" "${DATA_DIR}/system/"
[ -d "${CANDIDATE_DIR}/opencode" ] && rsync -a --delete "${CANDIDATE_DIR}/opencode/" "${DATA_DIR}/opencode/"
[ -d "${CANDIDATE_DIR}/docs" ] && rsync -a --delete "${CANDIDATE_DIR}/docs/" "${DATA_DIR}/docs/"

date -Iseconds > "${TASK_DIR}/APPLIED_AT.txt"

echo "Applied task ${TASK_ID}"
echo "Backup stored in ${backup_dir}"

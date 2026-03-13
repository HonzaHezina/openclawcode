#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data}"
TASKS_DIR="${TASKS_DIR:-${DATA_DIR}/approvals/tasks}"
OPENCLAW_CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-${DATA_DIR}/openclaw.json}"
OPENCODE_ATTACH_URL="${OPENCODE_ATTACH_URL:-http://${OPENCODE_SERVER_USERNAME:-opencode}:${OPENCODE_SERVER_PASSWORD:?}@opencode:4096}"

mkdir -p "${TASKS_DIR}" "${DATA_DIR}/backups" "${DATA_DIR}/logs"

new_task_id() {
  printf "%(%Y%m%d-%H%M%S)T-%s\n" -1 "$(tr -dc 'a-z0-9' </dev/urandom | head -c 6)"
}

prepare_task_tree() {
  local task_id="$1"
  local task_dir="${TASKS_DIR}/${task_id}"
  mkdir -p "${task_dir}/baseline" "${task_dir}/candidate" "${task_dir}/artifacts"
  echo "${task_dir}"
}

seed_candidate_tree() {
  local target="$1"
  mkdir -p "${target}"
  cp -a "${OPENCLAW_CONFIG_PATH}" "${target}/openclaw.json"
  [ -d "${DATA_DIR}/workspaces" ] && rsync -a "${DATA_DIR}/workspaces/" "${target}/workspaces/"
  [ -d "${DATA_DIR}/system" ] && rsync -a "${DATA_DIR}/system/" "${target}/system/"
  [ -d "${DATA_DIR}/opencode" ] && rsync -a "${DATA_DIR}/opencode/" "${target}/opencode/"
  [ -d "${DATA_DIR}/docs" ] && rsync -a "${DATA_DIR}/docs/" "${target}/docs/"
}

write_request() {
  local file="$1"
  shift
  cat >"${file}" <<EOF
$*
EOF
}

run_opencode_attached() {
  local workdir="$1"
  shift
  (
    cd "${workdir}"
    opencode run --attach "${OPENCODE_ATTACH_URL}" "$@"
  )
}

generate_patch() {
  local baseline="$1"
  local candidate="$2"
  local patch_file="$3"
  diff -ruN "${baseline}" "${candidate}" > "${patch_file}" || true
}

print_task_footer() {
  local task_id="$1"
  local task_dir="$2"
  echo "TASK_ID=${task_id}"
  echo "TASK_DIR=${task_dir}"
  echo "PATCH=${task_dir}/changes.patch"
  echo "RESULT=${task_dir}/candidate/TASK_RESULT.md"
  echo "RISKS=${task_dir}/candidate/RISKS.md"
}


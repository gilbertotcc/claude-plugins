#!/bin/bash
# PostToolUse hook for Edit/Write (see hooks/hooks.json). Runs
# markdownlint-cli2 --fix on the edited file, applying deterministic fixes
# automatically, and feeds back only issues --fix couldn't resolve (via
# exit code 2) so Claude can edit those deliberately.
#
# Only lints files that belong to the project being worked on. Without this,
# scratch/temp Markdown (e.g. a GitHub issue body drafted before pasting into
# `gh issue create`, or a plan/notes file) gets auto-fixed too, which can
# silently mangle it (e.g. MD009 stripping hard-break trailing spaces) even
# though it was never meant to follow repo conventions (#17).
set -uo pipefail

input=$(cat)
file_path=$(jq -r '.tool_input.file_path // empty' <<<"$input")

if [[ -z "$file_path" || "$file_path" != *.md ]]; then
  exit 0
fi

project_dir="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "$project_dir" ]]; then
  project_dir=$(git -C "$(dirname "$file_path")" rev-parse --show-toplevel 2>/dev/null) || project_dir=""
fi

if [[ -n "$project_dir" ]]; then
  resolved_file=$(realpath "$file_path" 2>/dev/null) || resolved_file="$file_path"
  resolved_project=$(realpath "$project_dir" 2>/dev/null) || resolved_project="$project_dir"
  case "$resolved_file" in
    "$resolved_project"/*) ;;
    *) exit 0 ;;
  esac
fi

output=$("${CLAUDE_PLUGIN_ROOT}/scripts/run-markdownlint.sh" --fix "$file_path" 2>&1)
status=$?

if [[ $status -ne 0 ]]; then
  echo "$output" >&2
  exit 2
fi

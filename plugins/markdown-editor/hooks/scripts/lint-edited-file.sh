#!/bin/bash
# PostToolUse hook for Edit/Write (see hooks/hooks.json). Advisory only: lints
# the just-edited file and, on failure, feeds the report back to Claude via
# exit code 2 so it can fix the issues deliberately (never auto-fixes here).
set -uo pipefail

input=$(cat)
file_path=$(jq -r '.tool_input.file_path // empty' <<<"$input")

if [[ -z "$file_path" || "$file_path" != *.md ]]; then
  exit 0
fi

output=$("${CLAUDE_PLUGIN_ROOT}/scripts/run-markdownlint.sh" "$file_path" 2>&1)
status=$?

if [[ $status -ne 0 ]]; then
  echo "$output" >&2
  exit 2
fi

#!/bin/bash
# PostToolUse hook for Edit/Write (see hooks/hooks.json). Runs
# markdownlint-cli2 --fix on the edited file, applying deterministic fixes
# automatically, and feeds back only issues --fix couldn't resolve (via
# exit code 2) so Claude can edit those deliberately.
set -uo pipefail

input=$(cat)
file_path=$(jq -r '.tool_input.file_path // empty' <<<"$input")

if [[ -z "$file_path" || "$file_path" != *.md ]]; then
  exit 0
fi

output=$("${CLAUDE_PLUGIN_ROOT}/scripts/run-markdownlint.sh" --fix "$file_path" 2>&1)
status=$?

if [[ $status -ne 0 ]]; then
  echo "$output" >&2
  exit 2
fi

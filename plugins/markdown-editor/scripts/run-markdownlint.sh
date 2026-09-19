#!/bin/bash
# Resolves and runs markdownlint-cli2, preferring a global/PATH install and
# falling back to `npx` (which fetches it on demand) when unavailable.
# All arguments are passed through to markdownlint-cli2 unchanged.
#
# When --fix is requested, markdownlint-cli2's --fix is not always
# idempotent in a single pass: normalizing one rule (e.g. MD004 list-marker
# style) can transiently leave another rule (e.g. MD022/MD032 blank lines)
# violated, which only gets corrected on a subsequent --fix pass. Looping
# up to 3 passes (stopping early once a pass is fully clean) avoids
# surfacing those transient, auto-fixable issues as if they needed a
# manual edit.
set -uo pipefail

resolve_cmd() {
  if command -v markdownlint-cli2 >/dev/null 2>&1; then
    echo "markdownlint-cli2"
  elif command -v npx >/dev/null 2>&1; then
    echo "npx --yes markdownlint-cli2"
  else
    return 1
  fi
}

cmd=$(resolve_cmd) || {
  echo "markdownlint-cli2 is not installed, and npx is unavailable to fetch it on demand." >&2
  echo "Install it to lint Markdown files: npm install -g markdownlint-cli2" >&2
  echo "(or install Node.js/npm so npx can run it without a global install)" >&2
  exit 1
}

max_passes=1
for arg in "$@"; do
  [[ "$arg" == "--fix" ]] && { max_passes=3; break; }
done

for ((i = 1; i <= max_passes; i++)); do
  output=$($cmd "$@" 2>&1)
  status=$?
  [[ $status -eq 0 || $i -eq $max_passes ]] && break
done

echo "$output"
exit $status

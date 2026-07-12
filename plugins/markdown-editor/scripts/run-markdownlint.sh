#!/bin/bash
# Resolves and runs markdownlint-cli2, preferring a global/PATH install and
# falling back to `npx` (which fetches it on demand) when unavailable.
# All arguments are passed through to markdownlint-cli2 unchanged.
set -uo pipefail

if command -v markdownlint-cli2 >/dev/null 2>&1; then
  markdownlint-cli2 "$@"
elif command -v npx >/dev/null 2>&1; then
  npx --yes markdownlint-cli2 "$@"
else
  echo "markdownlint-cli2 is not installed, and npx is unavailable to fetch it on demand." >&2
  echo "Install it to lint Markdown files: npm install -g markdownlint-cli2" >&2
  echo "(or install Node.js/npm so npx can run it without a global install)" >&2
  exit 1
fi

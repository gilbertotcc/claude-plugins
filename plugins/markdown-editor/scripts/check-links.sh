#!/bin/bash
# Wraps lychee for link-checking Markdown files. Run manually (not on every
# edit) since it makes network requests and can be slow or flaky.
# All arguments are passed through to lychee unchanged.
set -uo pipefail

if ! command -v lychee >/dev/null 2>&1; then
  cat >&2 <<'EOF'
lychee is not installed, so links were NOT checked.

Install it to enable link-checking, then re-run this check:
  macOS (Homebrew): brew install lychee
  Cargo:            cargo install lychee
  Other methods:    https://lychee.cli.rs/installation/
EOF
  echo "RESULT: URLs were not checked (lychee unavailable)."
  exit 0
fi

lychee "$@"

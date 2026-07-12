# markdown-editor

A Claude Code plugin for creating and editing Markdown documents that
automatically recognizes and follows a repository's own Markdown style —
even in repositories with no Markdown linting configuration at all.

## How style recognition works

This plugin never hardcodes a personal Markdown house style (a specific
line-length limit, list marker, heading style, prose dialect, etc.). Style
resolution is fully delegated to [`markdownlint-cli2`][markdownlint-cli2],
which resolves style in this order:

1. **A local config file, if one exists** — `.markdownlint-cli2.{jsonc,yaml,json}`,
   `.markdownlint.{jsonc,yaml,json}`, a `markdownlint-cli2.config.*` file, or
   a `markdownlint-cli2` key in `package.json`. That configuration is treated
   as the repository's authoritative style.
2. **`markdownlint-cli2`'s own built-in defaults, if no config exists** —
   ATX headings, ~80-char soft line length, consistent list markers, blank
   lines around block elements, fenced code blocks, a single trailing
   newline. These are widely-adopted community defaults, not an opinion
   introduced by this plugin.

## What's included

| Component                     | What it does                                            |
| ----------------------------- | ------------------------------------------------------- |
| `skills/markdown-editor/`     | Auto-triggered workflow: lint, link-check, style rules. |
| `skills/lint/`                | User-invoked `/markdown-editor:lint` sweep (see below). |
| `commands/lint.md`            | Fallback registration for the same command (see below). |
| `hooks/hooks.json`            | Advisory `PostToolUse` lint check after each edit.      |
| `scripts/run-markdownlint.sh` | Shared binary resolution (global, then `npx`).          |
| `scripts/check-links.sh`      | Manual, on-demand `lychee` link check.                  |

`skills/markdown-editor/` auto-triggers on Markdown work and documents the
lint → fix → link-check workflow plus the style-resolution principle above.

`skills/lint/` is invoked as `/markdown-editor:lint` (add `--fix` to
auto-fix) and sweeps every `.md` file in the repository. `commands/lint.md`
is a thin fallback that points at `skills/lint/` (`@`-references it, no
duplicated logic) — it exists because plugin skills don't reliably register
as slash commands when a plugin is loaded from a local/`file://` marketplace
source ([anthropics/claude-code#57737](https://github.com/anthropics/claude-code/issues/57737)),
exactly how this marketplace is typically installed. That issue was closed
as *not planned*, so treat this fallback as permanent rather than
temporary; a skill and a command sharing a name is safe (the skill wins).

`hooks/hooks.json` lints a file immediately after each `Edit`/`Write` and
reports failures back to Claude to fix — it never rewrites files on its
own. `scripts/run-markdownlint.sh` is the shared binary resolution used by
both the hook and the lint skill (see below). `scripts/check-links.sh` is a
manual, on-demand link-checking wrapper around `lychee` (not run on every
edit, since it's network-bound).

## Tool resolution (what actually runs in your repository)

**`markdownlint-cli2`** — every lint check (the per-edit hook and
`/markdown-editor:lint`) resolves the binary the same way:

1. If `markdownlint-cli2` is available on `PATH` (e.g. installed globally
   with `npm install -g markdownlint-cli2`), it is used directly.
2. Otherwise, if `npx` is available, the plugin runs `npx --yes
   markdownlint-cli2`, which downloads and caches the package on first use.
   This requires Node.js/npm and, on first run, network access.
3. If neither is available, the check fails with installation instructions
   instead of silently skipping.

**`lychee`** (link-checking only, manual step) — if not installed, the
check reports that URLs were **not** checked and prints install
instructions; it does not report success when it hasn't actually checked
anything. Install with `brew install lychee`, `cargo install lychee`, or see
the [lychee installation docs][lychee-install].

## Explicitly out of scope

Spelling/prose-style enforcement (e.g. British vs. American English) and a
style-audit subagent are intentionally not part of this plugin — those are
project-specific choices, not general Markdown-editing concerns.

[markdownlint-cli2]: https://github.com/DavidAnson/markdownlint-cli2
[lychee-install]: https://lychee.cli.rs/guides/getting-started/

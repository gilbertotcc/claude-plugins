# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This repository is a Claude Code **plugin marketplace**: a personal collection of plugins (skills,
agents, commands, hooks, etc.) for Claude Code, distributed via `.claude-plugin/marketplace.json`.
Plugins live under `plugins/<plugin-name>/` and are registered in the marketplace manifest — see
the `plugins/` directory for current examples of the structure described below.

## Architecture

- `.claude-plugin/marketplace.json` — the marketplace manifest, validated against the
  `claude-code-marketplace.json` schema. Each entry in the `plugins` array points to a plugin via
  `"source": "./plugins/<plugin-name>"`. When adding a new plugin, register it here.
- `plugins/<plugin-name>/` — **every plugin lives in its own directory under `plugins/`**, never
  at repo root. This keeps marketplace infrastructure (`.claude-plugin/`, lint/CI config, this
  file, the root README) separate from installable plugin content as the collection grows. Each
  plugin follows the structure documented at
  [Create and distribute a plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
  (referenced in README.md) — its own `.claude-plugin/plugin.json` manifest plus whichever of
  `skills/`, `agents/`, `hooks/`, `scripts/`, `.mcp.json` it needs, and its own `README.md`.
- Plugins that shell out to external tooling (e.g. linters) should resolve it with a
  global/PATH-first, `npx`-or-similar-on-demand-fallback pattern, and document that behavior
  transparently in their own `README.md` — the tooling runs in whichever repo the plugin is
  installed into, not just this one.
- **Keep root `README.md`'s `## Plugins` list in sync with `marketplace.json`'s `plugins`
  array** — one bullet per entry, using that entry's `name` and `description` verbatim, whenever a
  plugin is added, removed, or its description changes.

## Content conventions (Markdown)

All content in this repo today is Markdown, and it is linted/checked in CI:

- **markdownlint** (`.markdownlint-cli2.yaml`): ATX-style headings (`#`, not underlines), max line
  length 100 (not enforced in tables or code blocks), fenced code blocks don't require a language tag
  (MD040 disabled), sibling duplicate headings allowed (MD024 `siblings_only`).
- **lychee** link checker (`lychee.toml`, `.lycheeignore`): checks all `.md` files for broken links;
  loopback links are excluded.

## CI

`.github/workflows/check-markdown-files.yml` runs on PRs that touch `**.md`,
`.markdownlint-cli2.yaml`, the workflow file itself, or `lychee.toml`:

- `lint-markdown` job — runs `markdownlint-cli2` over the repo.
- `check-links` job — runs `lychee` over the repo (`--config lychee.toml`).

To check Markdown changes locally before pushing, run the equivalent tools if available:

```sh
markdownlint-cli2 "**/*.md"
lychee --config lychee.toml ./
```

Dependabot (`.github/dependabot.yml`) keeps GitHub Actions in the workflows up to date on a weekly
schedule.

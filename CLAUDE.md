# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This repository is a Claude Code **plugin marketplace**: a personal collection of plugins (skills,
agents, commands, etc.) for Claude Code, distributed via `.claude-plugin/marketplace.json`. It is
currently in a bootstrap state — the marketplace manifest exists but no plugins have been added yet
(`plugins: []` in the manifest).

## Architecture

- `.claude-plugin/marketplace.json` — the marketplace manifest, validated against the
  `claude-code-marketplace.json` schema. Each entry in the `plugins` array will point to a plugin
  (typically a directory elsewhere in this repo, or an external source) that Claude Code can install
  from this marketplace. When adding a new plugin, register it here.
- No plugins exist yet. When creating one, follow the plugin structure documented at
  [Create and distribute a plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces)
  (referenced in README.md) — a plugin has its own manifest plus the skills/commands/agents it
  provides.

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

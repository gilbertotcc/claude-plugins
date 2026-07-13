# Contributing

Thanks for your interest in contributing to this marketplace! This document covers how to propose
a new plugin, the checks your change needs to pass, and what to expect from the PR process.

By participating in this project you agree to abide by the [Code of Conduct](.github/CODE_OF_CONDUCT.md).

## Plugin and marketplace structure

This repository is a Claude Code plugin marketplace. The full layout — where plugins live, what a
plugin manifest needs, and the conventions each plugin should follow — is documented in
[`CLAUDE.md`](CLAUDE.md)'s Architecture section. Read that first; this document only covers the
steps for getting a change merged, not the structure itself.

## Adding a plugin

1. Create a new directory under `plugins/<plugin-name>/` with its own
   `.claude-plugin/plugin.json` manifest, plus whichever of `skills/`, `agents/`, `hooks/`,
   `scripts/`, `.mcp.json` it needs, and its own `README.md` — see any existing directory under
   [`plugins/`](plugins/) for a working example of this structure.
2. Register the plugin as a new entry in `.claude-plugin/marketplace.json`'s `plugins` array.
3. Add a matching bullet to this repo's [`README.md`](README.md) under `## Plugins`, using that
   entry's `name` and `description` **verbatim** — the two lists must stay in sync, as noted in
   `CLAUDE.md`.
4. If your plugin shells out to external tooling (e.g. a linter), resolve it with a
   global/PATH-first, `npx`-or-similar-on-demand-fallback pattern, and document that behavior in
   the plugin's own `README.md`.

## Before opening a PR

Run the same checks CI runs, from the repo root:

```sh
markdownlint-cli2 "**/*.md"
lychee --config lychee.toml ./
```

CI (`.github/workflows/check-markdown-files.yml`) re-runs both automatically on any PR that
touches a `.md` file, `.markdownlint-cli2.yaml`, the workflow file itself, or `lychee.toml`.

## Opening a PR

- Keep PRs small and focused — one plugin per PR is fine, and preferred over bundling unrelated
  changes together.
- Fill out the PR template checklist; it covers the `marketplace.json`/README sync step above and
  confirms you've run the local checks.

---
name: markdown-editor
description: This skill should be used when the user asks to "write a README", "create a Markdown doc", "edit this .md file", "fix the markdown", "add a section to the docs", "format this as Markdown", or whenever a `.md` file is read, created, or modified. Provides the workflow and style-resolution rules for producing Markdown that matches the repository's own conventions.
license: MIT
---

# Markdown Editor Skill

## When to Use

Create, edit, or restructure Markdown files (README, docs, notes, changelogs)
in any repository — including ones with no Markdown linting configuration.

## Core Principle: Never Invent a House Style

Do not apply a personal or remembered Markdown style (a specific line-length
limit, list-marker choice, heading style, prose dialect, etc.). Style
resolution is fully delegated to `markdownlint-cli2`, which already resolves
in this order:

1. A local config file if one exists (`.markdownlint-cli2.{jsonc,yaml,json}`,
   `.markdownlint.{jsonc,yaml,json}`, a `markdownlint-cli2.config.*` file, or
   a `markdownlint-cli2` key in `package.json`) — that config is the
   repository's style and takes full precedence.
2. Its own built-in defaults when no config exists — ATX headings, ~80-char
   soft line length, consistent list markers, blank lines around block
   elements, fenced code blocks, a single trailing newline. These defaults
   are sane, widely-adopted community conventions, not this skill's opinion.

In both cases, running the linter and fixing what it reports is sufficient —
there is never a need to hand-author or guess at style rules.

## Core Workflow

A `PostToolUse` hook (`hooks/hooks.json`) automatically runs
`scripts/run-markdownlint.sh` on every `.md` file after each `Edit`/`Write`,
surfacing failures back to Claude. It is advisory only — it reports issues,
it never rewrites the file itself.

After any content modification to a `.md` file, and before considering the
task finished:

1. **Lint:** automatic via the hook above; if it reports issues, fix them
   and let the hook re-check on the next edit.
2. **Check links** (only once the content is otherwise finished — this step
   makes network requests, so it is not run on every edit):
   `${CLAUDE_PLUGIN_ROOT}/scripts/check-links.sh <file-or-glob>`.
   - If it reports broken links, fix or remove them.
   - If it reports `lychee` is unavailable, tell the user URLs were not
     checked rather than silently treating the file as verified.
3. **Repeat:** if any issues were found and fixed, re-run both checks.

For a batch sweep across many files at once (e.g. before a commit), use the
`/markdown-editor:lint` command instead of checking file by file.

## Tool Resolution

Both the hook and the manual checks resolve `markdownlint-cli2` the same
way: prefer a global/PATH install, fall back to `npx markdownlint-cli2`
(auto-fetches on first run, requires Node/npm and network access). See the
plugin `README.md` for full detail — mention this to the user if a check
fails because neither is available.

## Writing Content

Beyond linter-enforced structure, when authoring new content:

* Give every document exactly one top-level (`#`) heading.
* Use fenced code blocks with a language tag when the content has one
  (```` ```bash ````, ```` ```json ````, etc.) — improves readability even
  where markdownlint doesn't require it (MD040 is commonly disabled).
* Prefer relative links for files within the same repository.
* Do not add a spelling or prose-style pass (British vs. American English,
  tone, etc.) unless the repository's own config or CLAUDE.md says to —
  that is a project-specific choice, not a default of this skill.

## Handling Lint Failures Claude Can't Auto-Fix

Some rules (e.g. heading structure, line length in prose) require rewriting
content rather than reformatting. Read the `markdownlint-cli2` output
carefully — it names the rule (e.g. `MD013/line-length`) and line number —
and edit the offending line directly rather than disabling the rule.

## Handling Unreachable Links

If `check-links.sh` reports a link as unreachable: first try to correct it.
If it is confirmed correct but still unreachable (auth wall, flaky host,
etc.), check whether the repository has a lychee ignore file (commonly
`.lycheeignore` or configured in `lychee.toml`) and add it there with a
comment explaining why, rather than leaving the link check red. If the
repository has no such mechanism, flag it to the user instead of silently
leaving a broken link.

## References

* [markdownlint rules](https://github.com/DavidAnson/markdownlint)
* [markdownlint-cli2 configuration](https://github.com/DavidAnson/markdownlint-cli2#configuration)
* [lychee link-exclusion
  docs](https://lychee.cli.rs/recipes/excluding-links/#permanently-excluding-links)

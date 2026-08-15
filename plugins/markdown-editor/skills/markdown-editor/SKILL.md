---
name: markdown-editor
description: This skill should be used when the user asks to "write a README", "create a Markdown doc", "edit this .md file", "fix the markdown", "add a section to the docs", "format this as Markdown", or whenever a `.md` file that belongs to the project repository is read, created, or modified. Does not apply to temporary or scratch Markdown that isn't meant to become part of the repository (e.g. a GitHub issue body being drafted, an ad hoc plan or notes file). Provides the workflow and style-resolution rules for producing Markdown that matches the repository's own conventions.
license: MIT
model: haiku
---

# Markdown Editor Skill

## When to Use

Create, edit, or restructure Markdown files (README, docs, notes, changelogs)
in any repository — including ones with no Markdown linting configuration.

## Out of Scope: Temporary and Scratch Markdown

This skill governs Markdown that is, or will become, part of a repository. It
does not apply to Markdown that only exists as an intermediate artifact —
for example, a GitHub issue or PR body drafted in a scratch file before
being passed to `gh issue create`/`gh pr create`, or a plan/notes file
written out for the user's reference. Content like that was never meant to
follow repository conventions, so don't run the lint → link-check workflow
below against it, and don't manually invoke `check-links.sh` or
`/markdown-editor:lint` on it either.

The `PostToolUse` hook (`hooks/hooks.json`) already enforces this
automatically for the per-edit auto-lint: it only fixes `.md` files inside
the project directory (`$CLAUDE_PROJECT_DIR`, falling back to the git
repository root), so scratch files elsewhere — e.g. the session
scratchpad — are left untouched. Apply the same judgment yourself for the
manual steps this skill drives.

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

`markdownlint-cli2` is the only tool that lints or rewrites Markdown in
this repository — do not use any other tool for that purpose. A different
tool can silently fight its rules (emphasis style, list markers,
blank-line placement) and, if invoked via `Bash`, bypasses the
`PostToolUse` hook entirely, since the hook only fires on `Edit`/`Write`.

## Core Workflow

A `PostToolUse` hook (`hooks/hooks.json`) automatically runs
`scripts/run-markdownlint.sh --fix` on every `.md` file after each
`Edit`/`Write`, silently applying whatever `markdownlint-cli2` can fix on its
own and surfacing only the issues it couldn't resolve back to Claude.

After any content modification to a `.md` file, and before considering the
task finished:

1. **Lint:** automatic via the hook above — it already ran `--fix`. If it
   still reports issues, they're ones `--fix` couldn't resolve (structural
   rules like heading levels or line length): fix them by editing the file
   directly — do not disable the rule to make the failure go away. Let the
   hook re-check on the next edit.
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

- Give every document exactly one top-level (`#`) heading.
- Use fenced code blocks with a language tag when the content has one
  (```` ```bash ````, ```` ```json ````, etc.) — required by MD040 unless
  the repository's own config disables it.
- Prefer relative links for files within the same repository.
- Do not add a spelling or prose-style pass (British vs. American English,
  tone, etc.) unless the repository's own config or CLAUDE.md says to —
  that is a project-specific choice, not a default of this skill.

## Handling Issues That Can't Be Fixed Automatically

**Lint failures `markdownlint-cli2` reports:** some rules (e.g. heading
structure, line length in prose) require rewriting content rather than
reformatting. Read the output carefully — it names the rule (e.g.
`MD013/line-length`) and line number — then consult that rule's entry in
the markdownlint rules reference (see References below) for exactly what
it expects, and edit the offending line directly rather than disabling the
rule.

**Unreachable links `check-links.sh` reports:**

1. Try `WebFetch` on the link to check whether it's genuinely down or just
   flaky.
2. If it's genuinely down, use `WebSearch` to find the same information at
   a working URL and swap it in.
3. If the link is confirmed correct but persistently unreachable (auth
   wall, flaky host, etc.), ask the user to confirm before adding it to the
   repository's lychee ignore mechanism (commonly `.lycheeignore` or
   configured in `lychee.toml`) — never add an exclusion unilaterally.
   Include a dated comment recording who actually verified access, using
   whichever of these two forms applies:

   ```none
   # Access to the URL was manually verified by <git user>. (Last access: YYYY-MM-DD)
   ```

   ```none
   # Access to the URL was verified by <AI tool + model, e.g. Claude Code (Sonnet 5)> using <tool name, e.g. WebFetch>. (Last access: YYYY-MM-DD)
   ```

   Use the first form when the user checked the URL themselves (e.g. in a
   browser); use the second when Claude performed the check with a tool
   (e.g. `WebFetch`) — Claude always knows which of the two just happened,
   since it's the one that did (or didn't) run the check. Fill in the real
   git user, model, tool name, and current date; never leave the
   angle-bracket placeholders in the committed comment.

4. If the repository has no such ignore mechanism, flag it to the user
   instead of silently leaving a broken link.

## References

- [markdownlint rules](https://github.com/DavidAnson/markdownlint/blob/v0.41.0/doc/Rules.md) —
  consult the specific rule (e.g. `MD013`) to fix a reported failure
  directly, or to explain the tradeoff to the user before deciding.
- [markdownlint-cli2 configuration](https://github.com/DavidAnson/markdownlint-cli2#configuration)
- [lychee link-exclusion docs](https://lychee.cli.rs/recipes/excluding-links/#permanently-excluding-links)

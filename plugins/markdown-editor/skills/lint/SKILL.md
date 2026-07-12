---
name: lint
description: Run markdownlint-cli2 across every Markdown file in the repository, optionally auto-fixing what it can. Invoke as /markdown-editor:lint or /markdown-editor:lint --fix.
argument-hint: "[--fix]"
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/run-markdownlint.sh:*)
---

# Lint Markdown

Run a repository-wide Markdown lint sweep using the plugin's shared linting
script, which resolves `markdownlint-cli2` (global install preferred, `npx`
fallback) the same way the per-file hook does.

Default sweep (no arguments):

```sh
!`${CLAUDE_PLUGIN_ROOT}/scripts/run-markdownlint.sh "**/*.md"`
```

If the argument `--fix` is present in `$ARGUMENTS`, run with auto-fix instead:

```sh
!`${CLAUDE_PLUGIN_ROOT}/scripts/run-markdownlint.sh --fix "**/*.md"`
```

The leading `!` followed by a backtick-quoted command is Claude Code's
bash-execution syntax for commands (see `command-development`): it runs the
command inline and substitutes its output into the prompt before Claude
processes the rest of this file, rather than Claude having to invoke Bash
separately after reading the instructions.

After running:

1. Report the results to the user: files checked, issues found (and, in
   `--fix` mode, issues auto-fixed vs. remaining).
2. For any remaining issues `--fix` could not resolve (structural rules like
   heading levels or line length), fix them by editing the reported files
   and lines directly — do not disable the rule to make the failure go away.
3. If the script reports that neither `markdownlint-cli2` nor `npx` is
   available, relay that installation guidance to the user rather than
   treating the sweep as passing.
4. If a local markdownlint config exists in the repository, respect it as
   the authority on style — do not second-guess or override its rules.

# Description

<!-- What does this change do, and why? -->

## Checklist

- [ ] If this adds or changes a plugin, `.claude-plugin/marketplace.json` is updated to match.
- [ ] If this adds or changes a plugin, `README.md`'s `## Plugins` list bullet matches the
      corresponding `marketplace.json` entry's `name`/`description` verbatim.
- [ ] `markdownlint-cli2 "**/*.md"` passes locally.
- [ ] `lychee --config lychee.toml ./` passes locally.

---
max_turns: 12
timeout_seconds: 240
allowed_tools: [Write, Edit]
runs: 3
---
Create `.markdownlint-cli2.yaml` at the repository root with exactly this
content:

```yaml
config:
  MD013: false
  MD004:
    style: dash
```

Then write `docs/style-guide.md` with a "Writing Conventions" section that
includes:

- One paragraph of flowing prose (2-3 sentences) about keeping documentation
  tone casual and direct — don't manually wrap the lines
- A bulleted list of three conventions we follow when writing docs

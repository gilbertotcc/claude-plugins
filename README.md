# Gilberto's Claude Plugins

This repository serves as a Claude marketplace, presenting a personal collection of plugins designed
to support a range of tasks.

## Plugins

<!-- This list must stay in sync with the `plugins` array in .claude-plugin/marketplace.json:
     one bullet per entry, using that entry's `name` and `description` verbatim. -->

* [`markdown-editor`](plugins/markdown-editor/) — Create and edit Markdown documents,
  automatically recognizing and following each repository's own Markdown style (or
  markdownlint-cli2's sane defaults when no config exists).

## Usage

### Installing a plugin from this marketplace

1. Add this marketplace to Claude Code:

   ```text
   /plugin marketplace add gilbertotcc/claude-plugins
   ```

   While developing locally, a filesystem path works too:

   ```text
   /plugin marketplace add /path/to/claude-plugins
   ```

2. Install a plugin from it, using `<plugin-name>@gilbertotcc-claude-plugin`:

   ```text
   /plugin install markdown-editor@gilbertotcc-claude-plugin
   ```

3. Run `/plugin` at any time to browse installed and available plugins interactively.

### Trying a plugin without installing it

To iterate on a plugin in this repo before it's registered (or to try it out without adding the
marketplace), launch Claude Code pointed directly at the plugin's directory:

```sh
claude --plugin-dir /path/to/claude-plugins/plugins/markdown-editor
```

## Contributing

TODO

## References

The references below provide useful resources for using the marketplace and developing plugins.

**Marketplace:**

* [Create and distribute a plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces)

**Skills:**

* [Agent Skills](https://agentskills.io/)
* [Designing, Refining, and Maintaining Agent Skills at Perplexity](https://research.perplexity.ai/articles/designing-refining-and-maintaining-agent-skills-at-perplexity)

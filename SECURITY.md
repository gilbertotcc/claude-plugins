# Security Policy

## Scope

This repository is a Claude Code plugin marketplace: it distributes plugins that can include
executable hooks and scripts (for example, see
[`plugins/markdown-editor/hooks/hooks.json`](plugins/markdown-editor/hooks/hooks.json) and the
scripts under [`plugins/markdown-editor/scripts/`](plugins/markdown-editor/scripts/)). A security
report here can mean a vulnerability in the marketplace's own tooling (CI workflows, lint config),
or a malicious or unsafe plugin distributed through it — both are in scope.

## Reporting a Vulnerability

Please report security issues privately using GitHub's
[private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
feature, under this repository's **Security** tab → "Report a vulnerability". Do not open a public
issue for suspected security vulnerabilities.

Include as much detail as you can: the affected plugin or file, reproduction steps, and the
potential impact. We'll acknowledge reports as soon as possible and follow up with next steps.

---
type: regex
target: {source: file, path: notes/changelog-draft.md}
match: not_contains
flags: m
---
[ \t]+$

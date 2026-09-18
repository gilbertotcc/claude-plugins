---
max_turns: 10
timeout_seconds: 240
allowed_tools: [Write, Edit]
runs: 3
---
Create `notes/changelog-draft.md` with exactly this content:

```text
# Release Notes
Changes:
* Added export feature
- Fixed bug in parser
* Improved docs
## Known Issues
- flaky test on CI  
```

(Note: the last line has trailing spaces after "CI".)

Then fix the markdown formatting issues in that file.

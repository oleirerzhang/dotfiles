# Building, checking and publishing

## Build
```bash
python3 <skill>/scripts/build.py <project-dir>
```
Writes `<project-dir>/dist/index.html` and `<project-dir>/<title>.html` (identical, full HTML documents).

## Check (after every significant edit, and always before publishing)
```bash
python3 <skill>/scripts/check.py "<project-dir>/dist/index.html"
```
Reports duplicate ids, internal links with no target, and unbalanced tags. Missing targets that look like
`${next.id}` are JavaScript template strings and are fine; anything else must be fixed.

JavaScript syntax:
```bash
python3 - "<project-dir>/dist/index.html" <<'EOF'
import re,sys; s=open(sys.argv[1]).read()
open('/tmp/notes-scripts.js','w').write('\n;\n'.join(re.findall(r'<script(?![^>]*src)[^>]*>(.*?)</script>',s,re.S)))
EOF
node --check /tmp/notes-scripts.js && echo JS-OK
```
(Use the session scratchpad instead of /tmp when one exists.)

Jargon: `python3 <skill>/scripts/find_jargon.py <project-dir>`.

## Look at it in a browser
Serve the project folder with a static server (e.g. a `.claude/launch.json` entry running
`python3 -m http.server <port>` in the project dir) and open `/dist/index.html`. Check: no console errors; a
chapter with widgets works (change an input); dark mode; a phone-width viewport (375 px) has no horizontal page
scroll; the contents rail and glossary search work. Screenshots at reduced scale are enough.

## Publish as a claude.ai artifact (so the highlight-to-explain feature works)
The explainer calls `window.claude.use('sample')`, which needs the artifact's `sample` capability.

- If the artifact tools are the `claude-artifacts` MCP server: read its `guide` (topic "pages") first in a
  session, then call `publish_files` with `files: [{as: "index.html", path: "<abs path to dist/index.html>"}]`,
  a `title` and `icon: "book"`. Then declare the capability with `declare_capabilities` (`{"sample": {}}`) if the
  tools offer it; load `describe_capabilities` first to confirm the exact shape. On later republishes pass
  `slug` and `base_version` (from the last publish result); capabilities carry forward.
- If the session has the built-in `Artifact` tool instead: load the `artifact-capabilities` skill, then publish
  `dist/index.html` with `capabilities: {"sample": {}}`. Republish with the same file path to keep the URL.

Keep the page under 16 MB (text-only notes are usually 1–3 MB). Record the artifact URL/slug in the project's
`course.json` (add a field) so later sessions republish to the same link instead of creating a new one.

## Local copy
The `<title>.html` file opens directly in any browser; everything works offline except the explainer and the
Google Fonts (which fall back to system fonts).

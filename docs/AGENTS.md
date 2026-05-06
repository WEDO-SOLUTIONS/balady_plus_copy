# AGENTS.md for `docs`

Read the repository root `AGENTS.md` first. These instructions apply to the human-process documentation under `docs/`.

## Purpose

These files describe team workflow, governance, KPIs, and standards. They are useful context, but they are not always perfectly synchronized with the executable repo config.

## Editing Rules

- Preserve the current document structure, headings, and cross-links when making targeted edits.
- Do not silently rewrite governance or workflow policy to match code behavior unless the task explicitly asks for policy alignment.
- If you notice drift between docs and hooks or CI, call it out explicitly in your summary instead of auto-normalizing everything.
- Prefer concise, policy-like language over marketing phrasing.

## Source Of Truth Caveat

- For engineering behavior, `justfile`, `lefthook.yml`, `.lefthook/*`, workflow YAML, and package manifests are more authoritative than these docs.
- Use docs to explain intent and process, not to infer runtime behavior when code says otherwise.

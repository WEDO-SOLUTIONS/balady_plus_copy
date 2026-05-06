---
applyTo: ".github/workflows/**,.github/**/*.yml,.github/**/*.yaml"
---

Follow the nearest `AGENTS.md` when editing GitHub workflows or repository automation config.

Be conservative with:

- trigger changes
- branch globs
- path filters
- runner labels
- secret names
- release/build naming

Assume some workflows rely on self-hosted runner state, local keychains, certificates, or vendor tooling that is not obvious from the YAML alone.

Do not print or inline secret values. Treat reviewer mappings and team mappings as operational configuration with stable formats.

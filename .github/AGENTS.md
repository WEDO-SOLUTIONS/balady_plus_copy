# AGENTS.md for `.github`

Read the repository root `AGENTS.md` first. These instructions apply to CI, PR automation, labels, reviewer routing, and repository metadata under `.github/`.

## Scope

This directory contains:

- GitHub Actions workflows
- PR templates
- reviewer and team mapping files
- helper scripts used by CI

## Workflow Editing Rules

- Be conservative with trigger changes. Branch globs, path filters, and event types often encode legacy release policy.
- Keep secrets usage in workflow files opaque. Do not print secret values, derived tokens, or credential file contents.
- Assume some workflows run on self-hosted runners and rely on machine-local tools, keychains, or certificates.
- Preserve manual-dispatch inputs and release/build naming unless the task explicitly changes release operations.

## Known Drift

- CI still contains some legacy branch patterns such as `feature/*`, while hooks and local conventions emphasize `feat/*`.
- When changing workflow triggers or PR validation rules, treat this as a policy change and adjust the related docs and templates deliberately.

## PR And Automation Files

- Keep `.github/PULL_REQUEST_TEMPLATE.md` aligned with the actual review expectations.
- Mapping files like `reviewers.yml`, `teams_mapping.yml`, and related YAML are operational config; change them carefully and keep formats stable.

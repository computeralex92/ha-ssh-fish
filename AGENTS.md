# Agents

This is a Home Assistant App repository (HA App Store addon). It is not a standard code project with local test/lint/build tooling — everything is CI-driven.

## Repository structure

- `repository.yaml` — HA App Store repository manifest (single app: `ssh/`)
- `ssh/` — the only app (Terminal & SSH with fish shell + neovim)
- `.github/workflows/` — CI only; no local tooling

## App discovery

HA's `find-addons` action scans for directories containing `config.yaml`. This repo has one app in `ssh/`.

## CI/CD

### Lint (`lint.yaml`)
Runs `frenck/action-addon-linter` on each app found. No local lint command.

### Build (`builder.yaml` → `build-app.yaml`)
- Triggers on changes to monitored files: `config.json config.yaml config.yml Dockerfile rootfs`
- Uses `home-assistant/builder/actions` (version pinned to `62a1597`) for multi-arch builds
- Publishes to `ghcr.io/computeralex92/ha-ssh-fish/ha-ssh-fish` on push to `main`
- Architectures: `aarch64`, `amd64`

## Versioning

Version is read from `ssh/config.yaml` (`version` field). Increment it before publishing.

## Local development

No local build or test commands exist. Validate changes with the lint workflow locally or trust CI. Ensure `ssh/config.yaml` has a matching `version` before merging to `main`.

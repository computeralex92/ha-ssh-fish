# Agents

This is a Home Assistant App repository (HA App Store addon). It is not a standard code project with local test/lint/build tooling — everything is CI-driven.

## Repository structure

- `repository.yaml` — HA App Store repository manifest (single app: `ssh/`)
- `ssh/` — the only app (Terminal & SSH with fish shell + neovim)
- `.github/workflows/` — CI only; no local tooling

## App discovery

HA's `find-addons` action scans for directories containing `config.yaml`. This repo has one app in `ssh/`.

## CI/CD

### CI (`ci.yaml`)
Runs on pull requests to `main`:
- **Lint**: Runs `frenck/action-addon-linter` on the `ssh/` app
- **Shellcheck**: Lints shell scripts (ignores dotfiles)
- **Hadolint**: Lints `ssh/Dockerfile`
- **Prek**: Runs prek checks

### Release (`release.yaml`)
Triggers on push to `main`:
1. **Check version**: Compares `ssh/config.yaml` version with latest git tag
2. **Build**: If version bumped, builds multi-arch image (`aarch64`, `amd64`) and publishes to `ghcr.io/computeralex92/ha-ssh-fish/ha-ssh-fish`
3. **Release**: Creates GitHub release with auto-generated changelog from commits

Uses `home-assistant/builder/actions` (version pinned to `62a1597`).

## Versioning

Version is read from `ssh/config.yaml` (`version` field). Increment it before publishing.

- **Patch version (x.y.z)**: For minor changes like adding .gitignore, small fixes, or maintenance tasks
- **Minor version (x.y.0)**: For package updates, dependency updates, or small feature additions
- **Major version (x.0.0)**: For significant changes, breaking changes, or major feature additions

## Changelog

Home Assistant requires `CHANGELOG.md` to be in the addon directory (`ssh/`) to detect and display it. Only maintain `ssh/CHANGELOG.md` — do not create a root-level `CHANGELOG.md`.

## Local development

No local build or test commands exist. Validate changes with the lint workflow locally or trust CI. Ensure `ssh/config.yaml` has a matching `version` before merging to `main`.

## Shell scripts

Run `shellcheck` on init scripts before committing:
```bash
shellcheck ssh/rootfs/etc/cont-init.d/*.sh
shellcheck ssh/rootfs/etc/services.d/*/run
```

Init scripts use `bashio` library from Home Assistant base image.

## Upstream

This repo tracks [hassio-addons/app-ssh](https://github.com/hassio-addons/app-ssh) upstream. When porting changes:
- Use `git fetch upstream && git diff main..upstream/main -- ssh/` to see upstream changes
- Keep fish shell as default (upstream uses zsh) — adapt shell-specific scripts accordingly
- The upstream uses `s6-rc.d` service model; this repo uses the older `cont-init.d/` + `services.d/` layout — translate between them
- Config is structured with a nested `ssh:` block (match this pattern)

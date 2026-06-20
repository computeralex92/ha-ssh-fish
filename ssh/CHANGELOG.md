# Changelog

## 1.5.0

- Restructure config with nested `ssh:` block: add username, sftp, compatibility_mode, forwarding options
- Add `log_level`, `packages`, `init_commands`, and `backup_exclude` configuration options
- Add new packages: screen, ncdu, tcpdump, nmap-ncat, mtr, rsync, wget
- Keep starting when custom package installation fails (log warning instead of crash)
- Exit cleanly when SSH port is disabled (early exit in init instead of sleep hack)
- SSH moduli hardening (remove weak Diffie-Hellman parameters)
- Exclude `.ssh/environment` from backups (contains SUPERVISOR_TOKEN)
- Restrict permissions on credential files
- Fix sshd_config: add explicit crypto, auth, and forwarding settings
- Migrate from `bashio::addon.*` to `bashio::app.*` API
- Update renovate config to match upstream patterns

## 1.4.0

- Update base image to Alpine 3.24
- Update packages: git 2.54.0, libuv 1.52.1, mosquitto-clients 2.1.2, openssh 10.3_p1, tmux 3.6b, neovim 0.12.2, fish 4.6.0, htop 3.5.1, bottom 0.12.3

## 1.3.2

- Remove AppArmor profile (temporarily disabled, causes SSH connection failures)

## 1.3.1

- Fix AppArmor profile: add sshd-session subprofile for OpenSSH 10.x

## 1.3.0

- Add AppArmor profile for enhanced container security
- Add `ports_description` for better network configuration UI
- Add `homeassistant` minimum version pin for compatibility
- Add `tmpfs: true` and `timeout: 20` for reliability and security
- Restrict `ssl` and `backup` directory mappings to read-only
- Remove unused `audio`, `uart`, and `host_dbus` subsystems
- Remove unused PulseAudio, ALSA, and BlueZ packages
- Add license section to DOCS.md
- Add README link to DOCS.md for discoverability

## 1.2.2

- Add prek GitHub Action for pre-commit hooks in CI workflow

## 1.2.1

- Add .gitignore to exclude node_modules from version control
- Remove node_modules from git tracking

## 1.2.0

- Consolidate CHANGELOG.md to ssh/ directory for Home Assistant detection
- Update documentation with changelog location requirements
- Restructure CI workflows for better PR linting

## 1.1.0

- Restructure CI workflows for better PR linting and simplified release process
- Add shellcheck and hadolint to PR checks
- Update Dockerfile and shell scripts
- Add CHANGELOG.md

## 1.0.7

- Update base image to v20.1.0
- Add pre-commit configuration with shellcheck and YAML validation
- Update CI workflows for improved build process

## 1.0.6

- Automate release process with auto-generated changelog
- Pin action versions for security

## 1.0.5

- Fix symlink overwrite issues on container restart
- Fix keygen.sh glob matching for host key restoration
- Fix shellcheck issues in ttyd run script
- Switch from fish to bash for ttyd

## 1.0.4

- Fix shell script typos and improve code quality
- Add .dockerignore to reduce build context
- Add OpenCode development note to README

## 1.0.3

- Improve Dockerfile: reduce layers, remove debug output
- Improve Renovate config: better package detection, Alpine versioning, automerge
- Add integrity check for HA CLI download
- Add AGENTS.md for developer documentation
- Add code quality workflow

## 1.0.2

- Add htop & bottom to have a better overview of resources
- Remove devcontainer-config (no usage of this Github feature)
- Remove tasks for VSCode
- Initial release with fish shell and neovim

## 1.0.1

- Adjust Renovate and pin versions

## 1.0.0

- First stable version after getting it working

# Changelog

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

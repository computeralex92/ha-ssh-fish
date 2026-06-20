#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Install additional packages on startup
# ==============================================================================

# Check for packages (new format, fall back to old apks format)
if bashio::config.has_value "packages"; then
    PACKAGES=$(bashio::config "packages")
elif bashio::config.has_value "apks"; then
    bashio::log.warning "Using deprecated 'apks' config option. Migrate to 'packages'."
    PACKAGES=$(bashio::config "apks")
else
    bashio::exit.ok
fi

bashio::log.info "Installing custom packages..."

if apk update; then
    for package in ${PACKAGES}; do
        apk add "$package" \
            || bashio::log.warning "Failed installing ${package}"
    done
else
    bashio::log.warning "Failed updating Alpine package indexes, skipping..."
fi

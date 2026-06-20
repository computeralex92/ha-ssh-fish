#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Install additional packages on startup
# ==============================================================================

if ! bashio::config.has_value "packages"; then
    bashio::exit.ok
fi

bashio::log.info "Installing custom packages..."

if apk update; then
    for package in $(bashio::config "packages"); do
        apk add "$package" \
            || bashio::log.warning "Failed installing ${package}"
    done
else
    bashio::log.warning "Failed updating Alpine package indexes, skipping..."
fi

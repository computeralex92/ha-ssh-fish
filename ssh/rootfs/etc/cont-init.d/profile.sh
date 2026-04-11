#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Setup persistent user settings
# ==============================================================================
readonly DIRECTORIES=(addon_configs addons backup homeassistant media share ssl)

# Persist fish shell history by redirecting .fish_history to /data
if ! bashio::fs.file_exists /data/.fish_history; then
    touch /data/.fish_history
fi
chmod 600 /data/.fish_history

# Make Home Assistant TOKEN available on the CLI
mkdir -p /etc/profile.d
bashio::var.json \
    supervisor_token "${SUPERVISOR_TOKEN}" \
    | tempio \
        -template /usr/share/tempio/homeassistant.profile \
        -out /etc/profile.d/homeassistant.sh


# Persist fish config by redirecting to /data
if ! bashio::fs.file_exists /data/.fish_config; then
    touch /data/.fish_config
fi
chmod 600 /data/.fish_config

# Links some common directories to the user's home folder for convenience
for dir in "${DIRECTORIES[@]}"; do
    ln -s "/${dir}" "${HOME}/${dir}" \
        || bashio::log.warning "Failed linking common directory: ${dir}"
done

# Some links to "old" locations, to match documentation,
# backwards compatibility and musle memory
ln -s "/homeassistant" "/config" \
    || bashio::log.warning "Failed linking common directory: /config"
ln -s "/homeassistant" "${HOME}/config" \
    || bashio::log.warning "Failed linking common directory: ${HOME}/config"

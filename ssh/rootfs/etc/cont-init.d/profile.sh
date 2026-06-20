#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Setup persistent user settings
# ==============================================================================
readonly DIRECTORIES=(addon_configs addons backup homeassistant media share ssl)

# Persist fish shell history
if ! bashio::fs.file_exists /data/.fish_history; then
    touch /data/.fish_history
fi
chmod 600 /data/.fish_history

# Persist fish config
if ! bashio::fs.file_exists /data/.fish_config; then
    touch /data/.fish_config
fi
chmod 600 /data/.fish_config

# Make Home Assistant TOKEN available on the CLI
mkdir -p /etc/profile.d
echo "export SUPERVISOR_TOKEN=\"${SUPERVISOR_TOKEN}\"" \
    > /etc/profile.d/homeassistant.sh
{
    echo "ha banner"
    echo "source <(ha completion fish)"
} >> /etc/profile.d/homeassistant.sh

# Links some common directories to the user's home folder
for dir in "${DIRECTORIES[@]}"; do
    ln -sf "/${dir}" "${HOME}/${dir}" \
        || bashio::log.warning "Failed linking common directory: ${dir}"
done

ln -sf "/homeassistant" "/config" \
    || bashio::log.warning "Failed linking common directory: /config"
ln -sf "/homeassistant" "${HOME}/config" \
    || bashio::log.warning "Failed linking common directory: ${HOME}/config"

# Execute init commands
if bashio::config.has_value 'init_commands'; then
    length=$(bashio::config 'init_commands | length')
    for (( i=0; i<length; i++ )); do
        cmd=$(bashio::config "init_commands[${i}]")
        bashio::log.info "Running init command: ${cmd}"
        eval "${cmd}" || bashio::exit.nok "Failed executing init command: ${cmd}"
    done
fi

#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# SSH setup & user
# ==============================================================================

# Exit early if SSH port is not exposed
if ! bashio::var.has_value "$(bashio::app.port 22)"; then
    bashio::log.info "No SSH port configured, skipping SSH setup."
    exit 0
fi

# Sets up the users .ssh folder to be persistent
if ! bashio::fs.directory_exists /data/.ssh; then
    mkdir -p /data/.ssh \
        || bashio::exit.nok 'Failed to create a persistent .ssh folder'

fi
chmod 700 /data/.ssh \
    || bashio::exit.nok \
        'Failed setting permissions on persistent .ssh folder'

# Make Home Assistant TOKEN available for non-interactive SSH commands
echo "SUPERVISOR_TOKEN=${SUPERVISOR_TOKEN}" > /data/.ssh/environment
chmod 600 /data/.ssh/environment

if bashio::config.has_value 'ssh.authorized_keys'; then
    bashio::log.info "Setup authorized_keys"

    printf '%s\n' "$(bashio::config 'ssh.authorized_keys')" > /data/.ssh/authorized_keys
    chmod 600 /data/.ssh/authorized_keys

    # Unlock account with random password
    PASSWORD="$(pwgen -s 64 1)"
    echo "root:${PASSWORD}" | chpasswd 2>/dev/null
elif bashio::config.has_value 'ssh.password'; then
    bashio::log.info "Setup password login"

    PASSWORD=$(bashio::config 'ssh.password')
    echo "root:${PASSWORD}" | chpasswd 2>/dev/null
elif bashio::var.has_value "$(bashio::app.port 22)"; then
    bashio::exit.nok "You need to setup a login!"
fi

# Generate config
mkdir -p /etc/ssh
tempio \
    -conf /data/options.json \
    -template /usr/share/tempio/sshd_config \
    -out /etc/ssh/sshd_config

# Apply compatibility mode
if bashio::config.true 'ssh.compatibility_mode'; then
    sed -i '/^Ciphers /s/^/#/' /etc/ssh/sshd_config
    sed -i '/^MACs /s/^/#/' /etc/ssh/sshd_config
    sed -i '/^KexAlgorithms /s/^/#/' /etc/ssh/sshd_config
fi

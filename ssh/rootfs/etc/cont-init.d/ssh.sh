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

# Initialize variables for backward compat checks
AUTHORIZED_KEYS=""
PASSWORD=""

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

# Check for authorized_keys (new nested format, fall back to old flat format)
if bashio::config.has_value 'ssh.authorized_keys'; then
    AUTHORIZED_KEYS=$(bashio::config 'ssh.authorized_keys')
elif bashio::config.has_value 'authorized_keys'; then
    bashio::log.warning "Using deprecated flat config format. Migrate to ssh.authorized_keys."
    AUTHORIZED_KEYS=$(bashio::config 'authorized_keys')
fi

# Check for password (new nested format, fall back to old flat format)
if bashio::config.has_value 'ssh.password'; then
    PASSWORD=$(bashio::config 'ssh.password')
elif bashio::config.has_value 'password'; then
    bashio::log.warning "Using deprecated flat config format. Migrate to ssh.password."
    PASSWORD=$(bashio::config 'password')
fi

# Generate config
mkdir -p /etc/ssh
tempio \
    -conf /data/options.json \
    -template /usr/share/tempio/sshd_config \
    -out /etc/ssh/sshd_config

# Backward compat: handle old flat config format in sshd_config
# If old server.tcp_forwarding was set, apply it
if bashio::config.true 'server.tcp_forwarding' \
    && ! bashio::config.has_value 'ssh.allow_tcp_forwarding'; then
    bashio::log.warning "Using deprecated server.tcp_forwarding. Migrate to ssh.allow_tcp_forwarding."
    sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config
fi

# Default log_level to INFO if not set (backward compat with old configs)
if ! bashio::config.has_value 'log_level'; then
    sed -i 's/^LogLevel .*/LogLevel INFO/' /etc/ssh/sshd_config
fi

# Apply compatibility mode
if bashio::config.true 'ssh.compatibility_mode'; then
    sed -i '/^Ciphers /s/^/#/' /etc/ssh/sshd_config
    sed -i '/^MACs /s/^/#/' /etc/ssh/sshd_config
    sed -i '/^KexAlgorithms /s/^/#/' /etc/ssh/sshd_config
fi

# Setup authentication
if bashio::var.has_value "${AUTHORIZED_KEYS}"; then
    bashio::log.info "Setup authorized_keys"

    printf '%s\n' "${AUTHORIZED_KEYS}" > /data/.ssh/authorized_keys
    chmod 600 /data/.ssh/authorized_keys

    # Unlock account with random password
    NEWPASSWORD="$(pwgen -s 64 1)"
    echo "root:${NEWPASSWORD}" | chpasswd 2>/dev/null
elif bashio::var.has_value "${PASSWORD}"; then
    bashio::log.info "Setup password login"

    echo "root:${PASSWORD}" | chpasswd 2>/dev/null
else
    bashio::log.warning "No SSH credentials configured!"
    bashio::log.warning "Set ssh.authorized_keys or ssh.password to enable SSH login."
    bashio::log.warning "The SSH port is enabled but all login attempts will be rejected."
fi

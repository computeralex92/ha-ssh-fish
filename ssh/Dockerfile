ARG BUILD_FROM=ghcr.io/hassio-addons/base:20.1.0
ARG HA_CLI_VERSION="5.0.0"
FROM $BUILD_FROM

# Setup base
RUN apk add --no-cache \
        pulseaudio-utils=17.0-r5 \
        alsa-plugins-pulse=1.2.12-r2 \
        bluez=5.85-r0 \
        git=2.52.0-r0 \
        libuv=1.51.0-r0 \
        mosquitto-clients=2.0.22-r0 \
        openssh=10.2_p1-r0 \
        pwgen=2.08-r3 \
        tmux=3.6-r0 \
        ttyd=1.7.7-r0 \
        neovim=0.11.7-r0 \
        fish=4.0.2-r0 \
        htop=3.4.1-r1 \
        bottom=0.10.2-r0 \
        bottom-fish-completion=0.10.2-r0 \
    && ln -sf /usr/bin/nvim /usr/local/bin/vi \
    && ln -sf /usr/bin/nvim /usr/local/bin/vim

# Use fish as default shell
RUN sed -i "s|/bin/sh|/usr/bin/fish|" /etc/passwd

# Home Assistant CLI
ARG BUILD_ARCH
ARG HA_CLI_VERSION
RUN curl -Lso /usr/bin/ha \
        "https://github.com/home-assistant/cli/releases/download/${HA_CLI_VERSION}/ha_${BUILD_ARCH}" \
    && test -s /usr/bin/ha \
    && chmod a+x /usr/bin/ha \
    && /usr/bin/ha completion fish > /usr/share/fish/completions/ha.fish

# Copy data
COPY rootfs /

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="app" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Alexander Lauster <alexander@macwinlin.de>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Alexander Lauster <alexander@macwinlin.de>" \
    org.opencontainers.image.authors="Alexander Lauster <alexander@macwinlin.de>" \
    org.opencontainers.image.licenses="Apache License" \
    org.opencontainers.image.url="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

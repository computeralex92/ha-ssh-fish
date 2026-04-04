ARG BUILD_FROM
FROM $BUILD_FROM

# Setup base
RUN \
    set -x \
    && apk add --no-cache \
        pulseaudio-utils \
        alsa-plugins-pulse \
        bluez \
        git \
        libuv \
        mosquitto-clients \
        openssh \
        pwgen \
        tmux \
        ttyd \
        neovim \
        fish

# Use bash as default shell
RUN sed -i "s|/bin/sh|/usr/bin/fish|" /etc/passwd

# Home Assistant CLI
ARG BUILD_ARCH
ARG CLI_VERSION
RUN curl -Lso /usr/bin/ha \
        "https://github.com/home-assistant/cli/releases/download/${CLI_VERSION}/ha_${BUILD_ARCH}" \
    && chmod a+x /usr/bin/ha \
    && /usr/bin/ha completion fish > /usr/share/fish/completions/ha.completion

# Copy data
COPY rootfs /

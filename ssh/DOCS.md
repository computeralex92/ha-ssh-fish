# Home Assistant App: Terminal & SSH - Fish edition

## Installation

Follow these steps to get the app installed on your system:

1. This app is only visible to "Advanced Mode" users. To enable advanced mode, go to **Profile** -> and turn on **Advanced Mode**.
2. In Home Assistant, go to **Settings** > **Apps** > **Install app**.
3. Find the "Terminal & SSH" app and click it.
4. Click on the "INSTALL" button.

## How to use

This app adds two main features to your Home Assistant installation:

- a web terminal that you can use from your browser, and
- enable connecting to your system using an SSH client.

Regardless of how you connect (using the web terminal or using an SSH client), you end up in this app's container. The Home Assistant configuration
directory is located on the path `/config`.

This app comes bundled with [The Home Assistant CLI](https://www.home-assistant.io/common-tasks/os#home-assistant-via-the-command-line). Try it out using:

```bash
ha help
```

### The Web Terminal

You can access the web terminal by clicking the "Open Web UI" button on this app's Info tab. If you set the "Show in sidebar" setting (found on the same Info tab) to "on", a shortcut is added to the sidebar allowing you to access the web terminal quickly.

To copy text from the Web UI:
1. Hold down the SHIFT key.
2. Select the text you want to copy using your mouse.
3. On releasing the left mouse button, the text gets copied to your system clipboard.

To paste text into the Web UI:
1. Press SHIFT + INSERT.

### SSH Server Connection

Remote SSH access from the network is disabled by default (See Network below). To connect using an SSH client, such as PuTTY or Linux terminal, you need to supply additional configuration for this app. To enable SSH connectivity, you need to:

- Provide authentication credentials - a password or SSH key(s) under `ssh.authorized_keys` or `ssh.password`
- Specify which TCP port to bind to, on the Home Assistant host

You can then connect to the port specified, using the configured username (default: `root`). Please note that enabling the SSH Server potentially makes your Home Assistant system less secure, as it might enable anyone on the internet to try to access your system. The security of your system also depends on your network set up, router settings, use of firewalls, etc. As a general recommendation, you should not activate this part of the app unless you understand the ramifications.

If you enable connecting to the SSH Server using an SSH client, you are strongly recommended to use private/public keys to log in. As long as you keep the private part of your key safe, this makes your system much harder to break into. Using passwords is, therefore, generally considered a less secure mechanism. To generate private/public SSH keys, follow the [instructions for Windows][keygen-windows] and [these for other platforms][keygen].

**Note**: Enabling login via password will disable key-based login. You can not run both variants at the same time.

## Configuration

App configuration:

```yaml
log_level: info
ssh:
  username: root
  password: ''
  authorized_keys: []
  sftp: false
  compatibility_mode: false
  allow_agent_forwarding: false
  allow_remote_port_forwarding: false
  allow_tcp_forwarding: false
packages: []
init_commands: []
```

### Option: `log_level`

Controls the log level of the SSH daemon and the app. Supported values: `trace`, `debug`, `info`, `notice`, `warning`, `error`, `fatal`.

### Option group `ssh`

SSH server configuration options.

#### Option `ssh.username`

The username to use for SSH login. Defaults to `root`. Changing this creates a non-root user with sudo access.

#### Option `ssh.password`

Set a password for login. **We do NOT recommend this variant**. When `ssh.authorized_keys` is set, password authentication is automatically disabled.

#### Option `ssh.authorized_keys`

Your **public keys** that you wish to accept for login. You can authorize multiple keys by adding multiple public keys to the list.

If you get errors when adding your key, it is likely that the public key you're trying to add, contains characters that intervene with YAML syntax. Try enclosing your key in double quotes to avoid this issue.

#### Option `ssh.sftp`

Enables the SFTP subsystem. **Note**: SFTP only works when `ssh.username` is set to `root`.

#### Option `ssh.compatibility_mode`

Disables the strict cipher/MAC/Kex algorithm restrictions to allow older SSH clients to connect. **This reduces security**.

#### Option `ssh.allow_agent_forwarding`

Specifies whether SSH agent forwarding (`-A`) is permitted.

#### Option `ssh.allow_remote_port_forwarding`

Specifies whether remote port forwarding (`-R`) is permitted.

#### Option `ssh.allow_tcp_forwarding`

Specifies whether TCP port forwarding (`-L -R` etc.) is permitted. **Note**: Enabling this lowers the security of your SSH server.

### Option: `packages`

Additional Alpine packages to install in the app container on startup. These are installed every time the app starts. If installation fails, a warning is logged but the app continues.

### Option: `init_commands`

Shell commands to execute on app startup, after everything is configured. Useful for custom setup tasks. Example:

```yaml
init_commands:
  - "touch /root/.custom_config"
  - "echo 'export MY_VAR=value' >> /etc/profile.d/custom.sh"
```

## Network

This section is only relevant if you want to connect to Home Assistant using an SSH client, such as PuTTY or Linux terminal. To enable SSH remote access from the Network, specify the desired SSH TCP server port in the Network configuration input box. The number you enter will be used to map that port from the host into the running **Terminal & SSH** app. The standard port used for the SSH protocol is `22`.

Remote SSH access can be disabled again, by clearing the input box, saving the configuration and restarting the app.

## Preinstalled tools

- **Shell**: fish (with neovim as vi/vim alternative)
- **Terminal**: tmux, screen
- **System**: htop, bottom, ncdu, procps-ng
- **Network**: tcpdump, mtr, nmap-ncat, mosquitto-clients, bind-tools
- **File**: rsync, wget, git
- **Disk**: lsblk

## Known issues and limitations

- This app will not enable you to install packages or do anything as root.
  This is not working with Home Assistant.

## License

Apache License 2.0

## Support

In case you've found a bug, please [open an issue on our GitHub][issue].

[discord]: https://www.home-assistant.io/join-chat
[forum]: https://community.home-assistant.io
[issue]: https://github.com/computeralex92/ha-ssh-fish/issues
[keygen-windows]: https://www.digitalocean.com/community/tutorials/how-to-create-ssh-keys-with-putty-to-connect-to-a-vps
[keygen]: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
[reddit]: https://reddit.com/r/homeassistant

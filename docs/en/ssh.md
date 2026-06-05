# SSH Configuration Guide

This document covers SSH usage with these dotfiles: prompt behavior, key
management, and recommended configuration.

---

## Prompt behavior on SSH sessions

When you connect to a remote host via SSH, Starship automatically shows
additional context to help you avoid confusion between local and remote shells.

### What changes on SSH

| Element | Local | SSH |
| --- | --- | --- |
| Username | Hidden (normal user) | Shown in green |
| Hostname | Hidden | Shown in yellow |
| Right prompt SSH label | Not shown | `SSH` label shown |
| Path | Full absolute path | Full absolute path |
| Git status | Shown | Shown |

The SSH detection relies on the `SSH_CONNECTION` environment variable, which
is set by the OpenSSH daemon on every standard SSH connection. It is not set
in local terminal sessions.

### Why hostname display matters

When managing multiple servers, it is critical to always know which machine
you are operating on. The Starship configuration displays the hostname
immediately after the username on every SSH session, making it impossible to
confuse a remote root shell with a local one.

---

## SSH key management

### Generate a new Ed25519 key

The `sshkey` function is available after sourcing `~/.bashrc`:

```bash
sshkey work-server "user@workstation"
```

This creates:

- `~/.ssh/work-server` — private key
- `~/.ssh/work-server.pub` — public key

Ed25519 keys are preferred over RSA for new deployments: smaller, faster, and
more secure.

### Recommended `~/.ssh/config` structure

```sshconfig
# Global defaults
Host *
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    AddKeysToAgent yes

# Work server
Host work
    HostName 192.168.1.10
    User admin
    IdentityFile ~/.ssh/work-server
    Port 22

# Jump host pattern
Host internal-*
    ProxyJump bastion
    User admin
    IdentityFile ~/.ssh/internal-key

Host bastion
    HostName bastion.example.com
    User admin
    IdentityFile ~/.ssh/bastion-key
```

---

## Recommended server-side configuration

For servers you administer, add these settings to `/etc/ssh/sshd_config`:

```sshconfig
# Disable password authentication — use keys only
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes

# Only allow Ed25519 and ECDSA keys
PubkeyAcceptedAlgorithms ssh-ed25519,ecdsa-sha2-nistp256

# Limit access
AllowUsers your-username
LoginGraceTime 30
MaxAuthTries 3

# Logging
LogLevel VERBOSE
```

Reload after changes:

```bash
sudo systemctl reload sshd
```

---

## Using tmux on remote servers

When connecting to a remote server, starting a tmux session ensures your work
survives connection drops:

```bash
ssh work
# On the remote server:
tmux new-session -s main
# or reconnect:
tmux attach -t main
```

The tmux configuration in this repository (prefix `Ctrl+a`) works identically
on both local and remote sessions.

---

## Using Zellij on remote servers

If Zellij is installed on the remote server:

```bash
zellij attach main 2>/dev/null || zellij --session main
```

---

## SSH agent setup

Add to `~/.bash_profile`:

```bash
if [[ -z "${SSH_AUTH_SOCK}" ]]; then
    eval "$(ssh-agent -s)"
fi
ssh-add ~/.ssh/work-server 2>/dev/null || true
```

Or use the system keyring (`gnome-keyring-daemon` or `kde-wallet`) which
manages the agent automatically on desktop systems.

---

## Checking the SSH_CONNECTION variable

You can verify that SSH detection is working:

```bash
# On a local session — should be empty
echo "${SSH_CONNECTION:-not set}"

# On an SSH session — should show: <client_ip> <client_port> <server_ip> <server_port>
echo "${SSH_CONNECTION}"
```

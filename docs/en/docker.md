# Docker Guide

This document covers Docker CE installation, usage, and Docker Rootless
configuration.

---

## Docker CE installation

Docker CE is installed during `make install` (phase `01-repos.sh`). The
packages installed are:

- `docker-ce` — Docker daemon and CLI
- `docker-ce-cli` — Docker command-line interface
- `containerd.io` — Container runtime
- `docker-buildx-plugin` — BuildKit plugin
- `docker-ce-rootless-extras` — Rootless mode support files
- `uidmap` — Required for rootless mode (user ID mapping)

The official Docker GPG key is added to `/etc/apt/keyrings/docker.asc` and
the repository is pinned to the `stable` channel.

---

## Standard Docker usage

After installation, Docker runs as root by default. Your user must be in the
`docker` group to use Docker without `sudo`:

```bash
sudo usermod -aG docker "${USER}"
newgrp docker
```

Verify:

```bash
docker info
docker run --rm hello-world
```

---

## Docker Rootless mode

Docker Rootless runs the Docker daemon entirely without root privileges.
This improves security by eliminating the risk of container escapes gaining
root on the host.

### Prerequisites (already installed by make install)

- `docker-ce-rootless-extras`
- `uidmap`
- `/etc/subuid` and `/etc/subgid` entries for your user

Check if your user has subuid/subgid entries:

```bash
grep "^$(id -un):" /etc/subuid
grep "^$(id -un):" /etc/subgid
```

If the entries are missing, ask the system administrator to run:

```bash
sudo usermod --add-subuids 100000-165535 "${USER}"
sudo usermod --add-subgids 100000-165535 "${USER}"
```

### Setup

```bash
make setup-docker-rootless
```

This runs `dockerd-rootless-setuptool.sh install` as your user and enables
the systemd user service.

### Verify rootless Docker

```bash
systemctl --user status docker
docker info | grep -i rootless
```

The output should include `rootless` in the security options section.

### DOCKER_HOST

The rootless Docker socket is at a different path than the root socket. Your
`~/.bash_profile` automatically sets `DOCKER_HOST` when the socket exists:

```bash
# Set automatically in ~/.bash_profile:
export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/docker.sock"
```

### Troubleshooting rootless

**Issue: `newuidmap` not found**

```bash
sudo apt-get install uidmap
```

**Issue: no subuid/subgid entries**

```bash
sudo usermod --add-subuids 100000-165535 "${USER}"
sudo usermod --add-subgids 100000-165535 "${USER}"
```

**Issue: service not starting**

```bash
systemctl --user status docker
journalctl --user -u docker
```

**Issue: DOCKER_HOST not set after reboot**

Ensure `~/.bash_profile` is sourced on login. The dotfiles set this
automatically via the Stow-managed `~/.bash_profile`.

---

## lazydocker

[lazydocker](https://github.com/jesseduffield/lazydocker) provides a terminal
UI for managing containers, images, volumes, and networks.

Launch with:

```bash
lzd
```

lazydocker reads `DOCKER_HOST` automatically, so it works with both standard
and rootless Docker.

---

## Docker in CI

The `docker/Dockerfile` in this repository builds a test image based on
`debian:trixie-slim`. It installs all dotfiles and runs the full test suite.

Build locally:

```bash
make docker-build
make docker-test
```

The Docker test validates:

1. All apt packages installed
2. All external binaries installed
3. All symlinks created by Stow
4. Bash startup without errors
5. Starship initialization
6. Reinstallation idempotency

---

## Useful Docker aliases

Defined in `~/.config/bash/aliases.sh`:

| Alias | Command |
|---|---|
| `dps` | `docker ps` with formatted table output |
| `dpsa` | `docker ps -a` (including stopped containers) |
| `dimg` | `docker images` |
| `dprune` | `docker system prune -f` |
| `denter` | Interactive container entry (with fzf selection) |

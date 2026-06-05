#!/usr/bin/env bash
# =============================================================================
# scripts/setup-docker-rootless.sh — Configure Docker Rootless mode
#
# Configures Docker to run without root privileges for the current user.
# Requires Docker CE and docker-ce-rootless-extras to be installed first.
# Run: make setup-docker-rootless
#
# Prerequisites (handled by install/01-repos.sh):
#   - docker-ce-rootless-extras
#   - uidmap
#
# References:
#   https://docs.docker.com/engine/security/rootless/
# =============================================================================

set -euo pipefail

echo "==> Setting up Docker Rootless mode..."

# Verify prerequisites
if ! command -v dockerd-rootless-setuptool.sh &>/dev/null; then
    echo "ERROR: dockerd-rootless-setuptool.sh not found." >&2
    echo "       Install docker-ce-rootless-extras first:" >&2
    echo "         sudo apt-get install docker-ce-rootless-extras uidmap" >&2
    exit 1
fi

if ! command -v newuidmap &>/dev/null; then
    echo "ERROR: newuidmap not found. Install uidmap:" >&2
    echo "         sudo apt-get install uidmap" >&2
    exit 1
fi

# Ensure running as non-root
if [[ "${EUID}" -eq 0 ]]; then
    echo "ERROR: Do not run this script as root. Run as the target user." >&2
    exit 1
fi

# Check /etc/subuid and /etc/subgid entries for the current user
if ! grep -q "^$(id -un):" /etc/subuid 2>/dev/null; then
    echo "ERROR: No entry for '$(id -un)' in /etc/subuid." >&2
    echo "       Ask an administrator to run:" >&2
    echo "         sudo usermod --add-subuids 100000-165535 $(id -un)" >&2
    echo "         sudo usermod --add-subgids 100000-165535 $(id -un)" >&2
    exit 1
fi

# Run the rootless setup tool
dockerd-rootless-setuptool.sh install

# Enable and start the user systemd service
if command -v systemctl &>/dev/null; then
    systemctl --user enable docker
    systemctl --user start docker
    echo "    Docker rootless service enabled and started."
fi

# Set DOCKER_HOST for the current session
DOCKER_HOST_PATH="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/docker.sock"
echo ""
echo "Docker Rootless setup complete."
echo ""
echo "Add the following to your ~/.bash_profile or ~/.bashrc:"
echo ""
echo "  export DOCKER_HOST=unix://${DOCKER_HOST_PATH}"
echo "  export PATH=\$HOME/.local/bin:\$PATH"
echo ""
echo "Verify with: docker info"

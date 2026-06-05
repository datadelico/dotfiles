#!/usr/bin/env bash
# =============================================================================
# install/01-repos.sh — Set up external apt repositories
#
# Configures:
#   - GitHub CLI  (cli.github.com/packages)
#   - Docker CE   (download.docker.com)
#   - VSCodium    (download.vscodium.com) — OPTIONAL, set INSTALL_VSCODIUM=1
#
# All sources use official GPG keys and are pinned to stable channels.
#
# Environment variables:
#   SKIP_DOCKER=1      — skip Docker CE repository setup
#                        Set automatically in Docker containers.
#   INSTALL_VSCODIUM=1 — also install VSCodium (GUI editor, optional)
# =============================================================================

set -euo pipefail

# Set INSTALL_VSCODIUM=1 to also configure the VSCodium repository.
INSTALL_VSCODIUM="${INSTALL_VSCODIUM:-0}"

# Set SKIP_DOCKER=1 to skip Docker CE installation (e.g. inside containers).
SKIP_DOCKER="${SKIP_DOCKER:-0}"

# ---------------------------------------------------------------------------
# GitHub CLI
# ---------------------------------------------------------------------------
setup_gh_repo() {
    if command -v gh &>/dev/null; then
        echo "    gh already installed, skipping repo setup."
        return 0
    fi

    echo "    Setting up GitHub CLI repository..."

    # Prerequisites for downloading and verifying the GPG key
    sudo apt-get install -y --no-install-recommends ca-certificates curl gnupg

    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
        sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" |
        sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

    sudo apt-get update -qq
    sudo apt-get install -y gh
    echo "    GitHub CLI installed."
}

# ---------------------------------------------------------------------------
# Docker CE (required for docker-ce-rootless-extras)
# ---------------------------------------------------------------------------
setup_docker_repo() {
    if command -v docker &>/dev/null; then
        echo "    Docker already installed, skipping repo setup."
        return 0
    fi

    echo "    Setting up Docker CE repository..."

    sudo apt-get install -y --no-install-recommends \
        ca-certificates curl uidmap

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg \
        -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # shellcheck disable=SC1091
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "${VERSION_CODENAME}") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    sudo apt-get update -qq
    sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-ce-rootless-extras

    echo "    Docker CE installed."
}

# ---------------------------------------------------------------------------
# VSCodium (optional — GUI editor)
# Source: https://vscodium.com
# ---------------------------------------------------------------------------
setup_vscodium_repo() {
    if command -v codium &>/dev/null; then
        echo "    VSCodium already installed, skipping repo setup."
        return 0
    fi

    echo "    Setting up VSCodium repository..."

    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg |
        gpg --dearmor |
        sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] \
https://download.vscodium.com/debs vscodium main" |
        sudo tee /etc/apt/sources.list.d/vscodium.list >/dev/null

    sudo apt-get update -qq
    sudo apt-get install -y codium
    echo "    VSCodium installed."
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
echo "==> [01-repos] Setting up external repositories..."

setup_gh_repo

if [[ "${SKIP_DOCKER}" == "1" ]]; then
    echo "    SKIP_DOCKER=1: skipping Docker CE repository setup."
else
    setup_docker_repo
fi

if [[ "${INSTALL_VSCODIUM}" == "1" ]]; then
    setup_vscodium_repo
fi

echo "==> [01-repos] Done."

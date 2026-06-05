#!/usr/bin/env bash
# =============================================================================
# install/00-core.sh — Install core apt packages for Debian 13 (trixie)
#
# Installs only packages that are missing (idempotent).
# Run as a user with sudo privileges.
# =============================================================================

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> [00-core] Installing core apt packages..."

# Core system utilities
CORE_PACKAGES=(
    build-essential
    curl
    file
    fontconfig
    git
    gnupg
    iproute2
    unzip
    wget
    tar
    jq
    chafa
    bash-completion
    openssh-client
    htop
    btop
    stow
)

# Shell enhancement tools available in Debian trixie repos
SHELL_PACKAGES=(
    fzf
    zoxide
    eza
    bat
    fd-find
    ripgrep
    tmux
    alacritty
)

# Quality tools
QUALITY_PACKAGES=(
    shellcheck
    shfmt
)

# Theme
THEME_PACKAGES=(
    papirus-icon-theme
)

ALL_PACKAGES=(
    "${CORE_PACKAGES[@]}"
    "${SHELL_PACKAGES[@]}"
    "${QUALITY_PACKAGES[@]}"
    "${THEME_PACKAGES[@]}"
)

# Collect packages that are not yet installed
to_install=()
for pkg in "${ALL_PACKAGES[@]}"; do
    if ! dpkg -l "$pkg" &>/dev/null 2>&1; then
        to_install+=("$pkg")
    fi
done

if [[ ${#to_install[@]} -eq 0 ]]; then
    echo "    All core packages already installed."
    exit 0
fi

echo "    Installing: ${to_install[*]}"
sudo apt-get update -qq
sudo apt-get install -y "${to_install[@]}"

echo "==> [00-core] Done."

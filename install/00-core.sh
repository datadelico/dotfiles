#!/usr/bin/env bash
# =============================================================================
# install/00-core.sh — Install core apt packages for Debian 13 (trixie)
#
# Installs only packages that are missing (idempotent).
# Run as a user with sudo privileges.
#
# Environment variables:
#   SKIP_GUI=1    — skip GUI/display packages (alacritty, papirus-icon-theme)
#                   Useful in headless servers and Docker containers.
# =============================================================================

set -euo pipefail

# Set to 1 to skip graphical packages (set automatically in Docker)
SKIP_GUI="${SKIP_GUI:-0}"

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
)

# GUI/display packages — skipped in headless/Docker environments
GUI_PACKAGES=(
    alacritty
)

# Quality tools
QUALITY_PACKAGES=(
    shellcheck
    shfmt
)

# Theme packages — skipped in headless/Docker environments
THEME_PACKAGES=(
    papirus-icon-theme
)

ALL_PACKAGES=(
    "${CORE_PACKAGES[@]}"
    "${SHELL_PACKAGES[@]}"
    "${QUALITY_PACKAGES[@]}"
)

if [[ "${SKIP_GUI}" != "1" ]]; then
    ALL_PACKAGES+=(
        "${GUI_PACKAGES[@]}"
        "${THEME_PACKAGES[@]}"
    )
else
    echo "    SKIP_GUI=1: skipping alacritty and papirus-icon-theme."
fi

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

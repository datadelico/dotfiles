#!/usr/bin/env bash
# =============================================================================
# config/versions.sh — Centralized version definitions
#
# Update these values to upgrade tools across the entire installation.
# All install scripts source this file before downloading binaries.
# =============================================================================

# Starship prompt — https://github.com/starship/starship/releases
STARSHIP_VERSION="1.25.1"

# lazygit — https://github.com/jesseduffield/lazygit/releases
LAZYGIT_VERSION="0.62.2"

# lazydocker — https://github.com/jesseduffield/lazydocker/releases
LAZYDOCKER_VERSION="0.25.2"

# zellij — https://github.com/zellij-org/zellij/releases
ZELLIJ_VERSION="0.44.3"

# HackGen Nerd Font — https://github.com/yuru7/HackGen/releases
HACKGEN_VERSION="2.10.0"

# Installation directories
INSTALL_BIN_DIR="${HOME}/.local/bin"
INSTALL_FONTS_DIR="${HOME}/.local/share/fonts"

export STARSHIP_VERSION LAZYGIT_VERSION LAZYDOCKER_VERSION ZELLIJ_VERSION
export HACKGEN_VERSION INSTALL_BIN_DIR INSTALL_FONTS_DIR

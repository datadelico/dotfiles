#!/usr/bin/env bash
# =============================================================================
# install/05-shell.sh — Configure Bash environment
#
# Ensures ~/.local/bin is in PATH and that BATS submodules are initialized.
# This script is safe to run multiple times.
# =============================================================================

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> [05-shell] Configuring shell environment..."

# Create ~/.local/bin if it doesn't exist
mkdir -p "${HOME}/.local/bin"

# Ensure ~/.local/bin is in PATH — the .bash_profile managed by Stow already
# handles this, but if the user's current session predates the Stow operation,
# we also add it to the active session path here.
if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
    export PATH="${HOME}/.local/bin:${PATH}"
    echo "    Added ~/.local/bin to PATH for this session."
fi

# Initialize BATS git submodules if inside the dotfiles repo
if [[ -f "${REPO_ROOT}/.gitmodules" ]]; then
    echo "    Initializing git submodules..."
    git -C "${REPO_ROOT}" submodule update --init --recursive
fi

echo "==> [05-shell] Done."
echo ""
echo "NOTE: Start a new shell session (or run 'source ~/.bashrc') to apply"
echo "      all Bash configuration changes."

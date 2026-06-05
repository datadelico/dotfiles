#!/usr/bin/env bash
# =============================================================================
# install/04-stow.sh — Apply dotfiles using GNU Stow
#
# Creates symlinks from the dotfiles/ packages into $HOME.
# Uses --restow so the operation is idempotent — safe to run multiple times.
#
# Each subdirectory of dotfiles/ is a Stow package:
#   dotfiles/bash/           → manages ~/.bashrc, ~/.bash_profile, etc.
#   dotfiles/starship/       → manages ~/.config/starship.toml
#   dotfiles/alacritty/      → manages ~/.config/alacritty/
#   dotfiles/tmux/           → manages ~/.config/tmux/
#   dotfiles/zellij/         → manages ~/.config/zellij/
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly REPO_ROOT
readonly DOTFILES_DIR="${REPO_ROOT}/dotfiles"

if ! command -v stow &>/dev/null; then
    echo "ERROR: GNU Stow is not installed. Run install/00-core.sh first." >&2
    exit 1
fi

echo "==> [04-stow] Applying dotfiles with GNU Stow..."

PACKAGES=(
    bash
    starship
    alacritty
    tmux
    zellij
)

for pkg in "${PACKAGES[@]}"; do
    if [[ ! -d "${DOTFILES_DIR}/${pkg}" ]]; then
        echo "    WARNING: package '${pkg}' not found in dotfiles/, skipping."
        continue
    fi
    echo "    Stowing: ${pkg}"
    stow --dir="${DOTFILES_DIR}" --target="${HOME}" --restow "${pkg}"
done

echo "==> [04-stow] Done."

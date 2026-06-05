#!/usr/bin/env bash
# =============================================================================
# tests/smoke/smoke.sh — Smoke tests: quick binary existence checks
#
# Does not require BATS. Checks that all required binaries are available after
# installation. Exits 0 if all checks pass, 1 if any check fails.
#
# Usage: bash tests/smoke/smoke.sh
# =============================================================================

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[0;33m'
readonly NC='\033[0m'

PASS=0
FAIL=0
SKIP=0

check() {
    local label="${1}"
    local cmd="${2}"
    if eval "${cmd}" &>/dev/null; then
        echo -e "  ${GREEN}PASS${NC}  ${label}"
        ((PASS++))
    else
        echo -e "  ${RED}FAIL${NC}  ${label}"
        ((FAIL++))
    fi
}

skip_check() {
    local label="${1}"
    local reason="${2}"
    echo -e "  ${YELLOW}SKIP${NC}  ${label} (${reason})"
    ((SKIP++))
}

echo "======================================================"
echo " Smoke Tests — dotfiles"
echo "======================================================"
echo ""
echo "Core system tools:"
check "git"             "command -v git"
check "curl"            "command -v curl"
check "wget"            "command -v wget"
check "jq"              "command -v jq"
check "gpg"             "command -v gpg"
check "stow"            "command -v stow"
check "unzip"           "command -v unzip"
check "tar"             "command -v tar"

echo ""
echo "Shell enhancement tools:"
check "fzf"             "command -v fzf"
check "zoxide"          "command -v zoxide"
check "eza"             "command -v eza"
check "bat (batcat)"    "command -v batcat || command -v bat"
check "fd (fdfind)"     "command -v fdfind || command -v fd"
check "ripgrep (rg)"    "command -v rg"
check "tmux"            "command -v tmux"
check "zellij"          "command -v zellij"

echo ""
echo "External binaries:"
check "starship"        "command -v starship"
check "lazygit"         "command -v lazygit"
check "lazydocker"      "command -v lazydocker"
check "gh"              "command -v gh"

echo ""
echo "Quality tools:"
check "shellcheck"      "command -v shellcheck"
check "shfmt"           "command -v shfmt"

echo ""
echo "System monitoring:"
check "htop"            "command -v htop"
check "btop"            "command -v btop"

echo ""
echo "Dotfile symlinks:"
check "~/.bashrc"                        "test -e \${HOME}/.bashrc"
check "~/.bash_profile"                  "test -e \${HOME}/.bash_profile"
check "~/.inputrc"                       "test -e \${HOME}/.inputrc"
check "~/.config/bash/aliases.sh"        "test -e \${HOME}/.config/bash/aliases.sh"
check "~/.config/bash/functions.sh"      "test -e \${HOME}/.config/bash/functions.sh"
check "~/.config/starship.toml"          "test -e \${HOME}/.config/starship.toml"
check "~/.config/tmux/tmux.conf"         "test -e \${HOME}/.config/tmux/tmux.conf"
check "~/.config/zellij/config.kdl"      "test -e \${HOME}/.config/zellij/config.kdl"
check "~/.config/alacritty/alacritty.toml" "test -e \${HOME}/.config/alacritty/alacritty.toml"

echo ""
echo "Starship initialization:"
if command -v starship &>/dev/null; then
    check "starship --version"  "starship --version"
    check "starship init bash"  "starship init bash"
else
    skip_check "starship --version" "starship not installed"
    skip_check "starship init bash" "starship not installed"
fi

echo ""
echo "Display-required tools (GUI):"
if [[ -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]; then
    check "alacritty"       "command -v alacritty"
else
    skip_check "alacritty"  "no display server (headless)"
fi

echo ""
echo "======================================================"
echo " Results: ${PASS} passed | ${FAIL} failed | ${SKIP} skipped"
echo "======================================================"

if [[ "${FAIL}" -gt 0 ]]; then
    exit 1
fi
exit 0

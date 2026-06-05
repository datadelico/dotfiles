#!/usr/bin/env bash
# =============================================================================
# docker/test.sh — Standalone test runner for the Docker container
#
# Runs all verification steps in sequence. Intended to be executed inside the
# Docker container after installation completes.
#
# Usage (inside container): bash docker/test.sh
# Usage (from host):        make docker-test
# =============================================================================

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

step() {
    echo -e "\n${BOLD}=== ${1} ===${NC}"
}

pass() {
    echo -e "  ${GREEN}PASS${NC}  ${1}"
}

fail() {
    echo -e "  ${RED}FAIL${NC}  ${1}"
}

ERRORS=0

verify_binary() {
    local name="${1}"
    local cmd="${2:-${1}}"
    if command -v "${cmd}" &>/dev/null; then
        pass "${name}"
    else
        fail "${name} — not found in PATH"
        ((++ERRORS))
    fi
}

# ---------------------------------------------------------------------------
step "Binary verification"
# ---------------------------------------------------------------------------
verify_binary "starship"
verify_binary "lazygit"
verify_binary "lazydocker"
verify_binary "zellij"
verify_binary "gh"
verify_binary "fzf"
verify_binary "zoxide"
verify_binary "eza"
verify_binary "ripgrep" "rg"
verify_binary "tmux"
verify_binary "git"
verify_binary "jq"
verify_binary "shellcheck"
verify_binary "shfmt"

# bat on Debian is batcat
if command -v batcat &>/dev/null || command -v bat &>/dev/null; then
    pass "bat (batcat)"
else
    fail "bat — neither 'bat' nor 'batcat' found"
    ((++ERRORS))
fi

# fd on Debian is fdfind
if command -v fdfind &>/dev/null || command -v fd &>/dev/null; then
    pass "fd (fdfind)"
else
    fail "fd — neither 'fd' nor 'fdfind' found"
    ((++ERRORS))
fi

# ---------------------------------------------------------------------------
step "Dotfile symlinks"
# ---------------------------------------------------------------------------
check_link() {
    local path="${HOME}/${1}"
    if [[ -e "${path}" ]]; then
        pass "${path}"
    else
        fail "${path} — missing"
        ((++ERRORS))
    fi
}

check_link ".bashrc"
check_link ".bash_profile"
check_link ".inputrc"
check_link ".config/bash/aliases.sh"
check_link ".config/bash/functions.sh"
check_link ".config/bash/completions.sh"
check_link ".config/starship.toml"
check_link ".config/tmux/tmux.conf"
check_link ".config/zellij/config.kdl"
check_link ".config/alacritty/alacritty.toml"

# ---------------------------------------------------------------------------
step "Bash startup"
# ---------------------------------------------------------------------------
if bash --norc -c 'source "${HOME}/.bashrc" && echo "bashrc_ok"' 2>/dev/null | grep -q "bashrc_ok"; then
    pass "${HOME}/.bashrc sources without errors"
else
    fail "${HOME}/.bashrc has errors on source"
    ((++ERRORS))
fi

# ---------------------------------------------------------------------------
step "Starship initialization"
# ---------------------------------------------------------------------------
if command -v starship &>/dev/null; then
    if starship init bash &>/dev/null; then
        pass "starship init bash"
    else
        fail "starship init bash failed"
        ((++ERRORS))
    fi
    starship_version="$(starship --version | head -1)"
    pass "starship version: ${starship_version}"
else
    fail "starship not found"
    ((++ERRORS))
fi

# ---------------------------------------------------------------------------
step "Reinstallation (idempotency)"
# ---------------------------------------------------------------------------
if bash install/04-stow.sh; then
    pass "stow --restow is idempotent"
else
    fail "stow --restow failed on second run"
    ((++ERRORS))
fi

if bash install/02-binaries.sh; then
    pass "install/02-binaries.sh is idempotent"
else
    fail "install/02-binaries.sh failed on second run"
    ((++ERRORS))
fi

# ---------------------------------------------------------------------------
echo ""
echo "======================================================"
if [[ "${ERRORS}" -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}All Docker tests passed (0 errors)${NC}"
    exit 0
else
    echo -e "${RED}${BOLD}${ERRORS} error(s) found.${NC}"
    exit 1
fi

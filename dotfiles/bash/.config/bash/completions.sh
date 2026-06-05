# shellcheck shell=bash
# =============================================================================
# ~/.config/bash/completions.sh — Extra shell completions
#
# Sourced by ~/.bashrc. Loads completion scripts from tools that are
# installed but do not provide automatic Debian package completion.
# =============================================================================

# ---------------------------------------------------------------------------
# starship
# ---------------------------------------------------------------------------
if command -v starship &>/dev/null; then
    # shellcheck source=/dev/null
    source <(starship completions bash)
fi

# ---------------------------------------------------------------------------
# GitHub CLI (gh)
# ---------------------------------------------------------------------------
if command -v gh &>/dev/null; then
    # shellcheck source=/dev/null
    source <(gh completion -s bash)
fi

# ---------------------------------------------------------------------------
# zoxide
# ---------------------------------------------------------------------------
# zoxide completion is handled by 'zoxide init bash' in .bashrc

# ---------------------------------------------------------------------------
# Docker (completion from docker-ce package)
# ---------------------------------------------------------------------------
if [[ -f /usr/share/bash-completion/completions/docker ]]; then
    # shellcheck source=/dev/null
    source /usr/share/bash-completion/completions/docker
fi

# ---------------------------------------------------------------------------
# lazygit
# ---------------------------------------------------------------------------
if command -v lazygit &>/dev/null; then
    # shellcheck source=/dev/null
    source <(lazygit completion bash 2>/dev/null) || true
fi
